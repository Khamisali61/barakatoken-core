from sqlalchemy import Column, Integer, String, Numeric, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.db.session import Base

class MpesaTransaction(Base):
    __tablename__ = "mpesa_transactions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    merchant_request_id = Column(String, unique=True, index=True, nullable=False)
    checkout_request_id = Column(String, unique=True, index=True, nullable=False)
    amount = Column(Numeric(18, 4), nullable=False)
    phone_number = Column(String, nullable=False)
    status = Column(String, default="Pending") # Pending, Success, Failed
    mpesa_receipt_number = Column(String, unique=True, index=True, nullable=True)
    transaction_date = Column(DateTime, server_default=func.now())
    result_code = Column(Integer, nullable=True)
    result_desc = Column(String, nullable=True)
