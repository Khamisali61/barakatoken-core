from sqlalchemy.orm import Session
from app.models.user import User
from app.models.mpesa import MpesaTransaction
from decimal import Decimal
from fastapi import HTTPException

class WalletService:
    def deposit(self, db: Session, user_id: int, amount: Decimal, currency: str = "KES"):
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        if currency == "KES":
            user.kes_balance += amount
        elif currency == "USD":
            user.usd_balance += amount
        else:
            raise HTTPException(status_code=400, detail="Invalid currency")

        db.commit()
        return user

    def one_tap_invest(self, db: Session, user_id: int, asset_id: int, amount: Decimal, currency: str = "KES"):
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        if currency == "KES":
            if user.kes_balance < amount:
                raise HTTPException(status_code=400, detail="Insufficient KES balance")
            user.kes_balance -= amount
        elif currency == "USD":
            if user.usd_balance < amount:
                raise HTTPException(status_code=400, detail="Insufficient USD balance")
            user.usd_balance -= amount
        else:
            raise HTTPException(status_code=400, detail="Invalid currency")

        # Record the investment (logic to update SukukAsset tokens would go here)
        # For this slice, we assume success

        db.commit()
        return {"status": "success", "new_balance": user.kes_balance if currency == "KES" else user.usd_balance}

wallet_service = WalletService()
