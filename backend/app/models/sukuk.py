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
    status = Column(String, default="Draft") # Draft, Onboarded, Minted, Active
    contract_address = Column(String, nullable=True)
    construction_milestone_percent = Column(Numeric(18, 4), default=0.0000)
    units_pre_sold = Column(Integer, default=0)
    fund_utilization_percent = Column(Numeric(18, 4), default=0.0000)
    fatwa_summary = Column(Text, nullable=True)
    shariah_cert_high_res_url = Column(String, nullable=True)
