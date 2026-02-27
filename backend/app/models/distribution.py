from sqlalchemy import Column, Integer, String, Numeric, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.db.session import Base

class Distribution(Base):
    __tablename__ = "distributions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    asset_id = Column(Integer, ForeignKey("sukuk_assets.id"), nullable=False)
    amount = Column(Numeric(18, 4), nullable=False)
    currency = Column(String, default="KES")
    status = Column(String, default="Paid") # Paid, Pending
    distributed_at = Column(DateTime, server_default=func.now())
    transaction_type = Column(String, default="Yield") # Yield, Capital Gain
