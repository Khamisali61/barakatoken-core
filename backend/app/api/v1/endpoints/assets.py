from typing import Any, List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.session import get_db
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
