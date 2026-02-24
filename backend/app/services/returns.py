from sqlalchemy.orm import Session
from app.models.sukuk import SukukAsset
from app.models.distribution import Distribution
from decimal import Decimal
from datetime import datetime, timedelta

class ReturnsService:
    def get_projections(self, asset: SukukAsset, months: int = 12):
        # Straight-line projection based on expected_irr
        monthly_rate = asset.expected_irr / Decimal("12")
        projections = []

        current_date = datetime.now()
        for i in range(1, months + 1):
            projected_date = current_date + timedelta(days=30 * i)
            projections.append({
                "month": projected_date.strftime("%b %Y"),
                "amount": float(asset.min_investment * monthly_rate),
                "type": "Projected"
            })
        return projections

    def get_actuals(self, db: Session, user_id: int, asset_id: int):
        actuals = db.query(Distribution).filter(
            Distribution.user_id == user_id,
            Distribution.asset_id == asset_id
        ).all()

        return [{
            "month": d.distributed_at.strftime("%b %Y"),
            "amount": float(d.amount),
            "type": "Actual"
        } for d in actuals]

returns_service = ReturnsService()
