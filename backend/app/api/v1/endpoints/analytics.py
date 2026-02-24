from typing import Any, List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api import deps
from app.db.session import get_db
from app.models.sukuk import SukukAsset
from app.services.returns import returns_service
from app.services.wallet import wallet_service
from decimal import Decimal

router = APIRouter()

@router.get("/{asset_id}/returns-calendar")
def get_returns_calendar(
    asset_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(deps.get_current_active_user)
) -> Any:
    asset = db.query(SukukAsset).filter(SukukAsset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")

    projections = returns_service.get_projections(asset)
    actuals = returns_service.get_actuals(db, current_user.id, asset_id)

    return {"projections": projections, "actuals": actuals}

@router.post("/deposit")
def deposit_to_wallet(
    amount: Decimal,
    currency: str = "KES",
    db: Session = Depends(get_db),
    current_user = Depends(deps.get_current_active_user)
) -> Any:
    return wallet_service.deposit(db, current_user.id, amount, currency)

@router.post("/one-tap-invest")
def one_tap_invest(
    asset_id: int,
    amount: Decimal,
    currency: str = "KES",
    db: Session = Depends(get_db),
    current_user = Depends(deps.get_current_active_user)
) -> Any:
    return wallet_service.one_tap_invest(db, current_user.id, asset_id, amount, currency)

@router.get("/analytics/tvl-growth")
def get_tvl_growth_analytics(
    db: Session = Depends(get_db)
) -> Any:
    # Dummy data for Bloomberg-style charts
    return {
        "tvl_history": [
            {"date": "2023-01", "value": 100000000},
            {"date": "2023-02", "value": 150000000},
            {"date": "2023-03", "value": 280000000},
            {"date": "2023-04", "value": 450000000},
            {"date": "2023-05", "value": 850000000},
        ],
        "investor_growth": [
            {"date": "2023-01", "count": 120},
            {"date": "2023-02", "count": 450},
            {"date": "2023-03", "count": 1200},
            {"date": "2023-04", "count": 2800},
            {"date": "2023-05", "count": 4200},
        ]
    }
