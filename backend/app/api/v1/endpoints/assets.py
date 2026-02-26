from typing import Any, List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.api import deps
from app.models.user import User
from app.models.sukuk import SukukAsset
from app.schemas.sukuk import SukukAsset as SukukAssetSchema

router = APIRouter()

@router.get("/", response_model=List[SukukAssetSchema])
def read_assets(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100,
) -> Any:
    assets = db.query(SukukAsset).offset(skip).limit(limit).all()
    return assets

@router.get("/{asset_id}", response_model=SukukAssetSchema)
def read_asset(
    asset_id: int,
    db: Session = Depends(get_db),
) -> Any:
    asset = db.query(SukukAsset).filter(SukukAsset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    return asset

from decimal import Decimal

@router.post("/{asset_id}/invest")
def invest_in_asset(
    asset_id: int,
    amount: float,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user),
) -> Any:
    asset = db.query(SukukAsset).filter(SukukAsset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")

    decimal_amount = Decimal(str(amount))
    if current_user.kes_balance < decimal_amount:
        raise HTTPException(status_code=400, detail="Insufficient KES balance")

    # Deduct balance
    current_user.kes_balance -= decimal_amount

    # Update Asset availability
    # Calculate tokens based on amount (1 token = 1 KES for simplicity in this vertical slice)
    tokens_to_buy = decimal_amount
    if asset.available_tokens < tokens_to_buy:
         raise HTTPException(status_code=400, detail="Not enough tokens available")

    asset.available_tokens -= tokens_to_buy

    # Record investment (Simplified: just update asset and maybe a log)
    # In a full system we'd have an Investment model
    from app.models.mpesa import MpesaTransaction # Reusing for simplicity or use a generic Transaction model
    import uuid

    # Actually, let's just commit the balance change for now to show it works
    db.commit()
    db.refresh(current_user)
    db.refresh(asset)

    return {
        "status": "success",
        "message": f"Successfully invested KES {amount} in {asset.title}",
        "new_balance": float(current_user.kes_balance)
    }
