from sqlalchemy import Column, Integer, String, Numeric, Text
from app.db.session import Base

class SukukAsset(Base):
    __tablename__ = "sukuk_assets"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True, nullable=False)
    description = Column(Text, nullable=True)
    location = Column(String, nullable=True)
    total_valuation = Column(Numeric(18, 4), nullable=False)
    total_tokens = Column(Numeric(18, 4), nullable=False)
    available_tokens = Column(Numeric(18, 4), nullable=False)
    min_investment = Column(Numeric(18, 4), nullable=False)
    expected_irr = Column(Numeric(18, 4), nullable=False)
    distribution_cycle = Column(String, nullable=False) # e.g., Monthly, Quarterly
    risk_level = Column(String, nullable=False) # e.g., Low, Medium, High
    legal_doc_url = Column(String, nullable=True)
    shariah_cert_url = Column(String, nullable=True)
    image_url = Column(String, nullable=True)
    status = Column(String, default="Active") # Active, Closed, Funded
