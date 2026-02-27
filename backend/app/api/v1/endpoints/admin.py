import os
import shutil
from typing import Any, List
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.api import deps
from app.db.session import get_db
from app.models.sukuk import SukukAsset
from app.models.user import User
from app.models.mpesa import MpesaTransaction
from app.schemas.sukuk import SukukAsset as SukukAssetSchema
from app.core.config import settings
from app.services.blockchain import blockchain_service
from decimal import Decimal

router = APIRouter()

@router.get("/stats")
def get_platform_stats(
    db: Session = Depends(deps.get_current_active_admin),
) -> Any:
    tvl = db.query(func.sum(SukukAsset.total_valuation)).scalar() or 0
    total_investors = db.query(func.count(User.id)).filter(User.is_admin == False).scalar() or 0
    # Dummy platform fees for now
    platform_fees = Decimal("25400.0000")

    return {
        "tvl": tvl,
        "total_investors": total_investors,
        "platform_fees": platform_fees
    }

@router.get("/assets", response_model=List[SukukAssetSchema])
def get_admin_assets(
    db: Session = Depends(deps.get_current_active_admin),
) -> Any:
    return db.query(SukukAsset).all()

@router.post("/assets/onboard")
async def onboard_asset(
    title: str = Form(...),
    description: str = Form(...),
    location: str = Form(...),
    total_valuation: Decimal = Form(...),
    total_tokens: Decimal = Form(...),
    min_investment: Decimal = Form(...),
    expected_irr: Decimal = Form(...),
    distribution_cycle: str = Form(...),
    risk_level: str = Form(...),
    legal_doc: UploadFile = File(...),
    shariah_cert: UploadFile = File(...),
    db: Session = Depends(deps.get_current_active_admin),
) -> Any:
    # Ensure upload directory exists
    os.makedirs(settings.UPLOAD_DIR, exist_ok=True)

    legal_path = os.path.join(settings.UPLOAD_DIR, legal_doc.filename)
    shariah_path = os.path.join(settings.UPLOAD_DIR, shariah_cert.filename)

    with open(legal_path, "wb") as buffer:
        shutil.copyfileobj(legal_doc.file, buffer)

    with open(shariah_path, "wb") as buffer:
        shutil.copyfileobj(shariah_cert.file, buffer)

    asset = SukukAsset(
        title=title,
        description=description,
        location=location,
        total_valuation=total_valuation,
        total_tokens=total_tokens,
        available_tokens=total_tokens,
        min_investment=min_investment,
        expected_irr=expected_irr,
        distribution_cycle=distribution_cycle,
        risk_level=risk_level,
        legal_doc_url=f"/media/{legal_doc.filename}",
        shariah_cert_url=f"/media/{shariah_cert.filename}",
        status="Onboarded"
    )
    db.add(asset)
    db.commit()
    db.refresh(asset)
    return asset

@router.post("/assets/{asset_id}/mint")
async def mint_asset_trigger(
    asset_id: int,
    db: Session = Depends(deps.get_current_active_admin),
) -> Any:
    asset = db.query(SukukAsset).filter(SukukAsset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")

    if asset.status != "Onboarded":
        raise HTTPException(status_code=400, detail="Asset must be Onboarded before minting")

    # Execute Server-Side Minting
    try:
        contract_address = blockchain_service.mint_tokens(
            asset.title,
            float(asset.total_valuation),
            asset.legal_doc_url
        )
        asset.status = "Minted"
        asset.contract_address = contract_address
        db.commit()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Blockchain transaction failed: {str(e)}")

    return {"status": "success", "message": "Sukuk tokens minted on Polygon Amoy", "contract_address": asset.contract_address}
