from typing import Optional
from pydantic import BaseModel
from decimal import Decimal

class SukukAssetBase(BaseModel):
    title: str
    description: Optional[str] = None
    location: Optional[str] = None
    total_valuation: Decimal
    total_tokens: Decimal
    available_tokens: Decimal
    min_investment: Decimal
    expected_irr: Decimal
    distribution_cycle: str
    risk_level: str
    legal_doc_url: Optional[str] = None
    shariah_cert_url: Optional[str] = None
    image_url: Optional[str] = None
    status: str = "Active"

class SukukAssetCreate(SukukAssetBase):
    pass

class SukukAssetUpdate(SukukAssetBase):
    title: Optional[str] = None
    total_valuation: Optional[Decimal] = None
    total_tokens: Optional[Decimal] = None
    available_tokens: Optional[Decimal] = None
    min_investment: Optional[Decimal] = None
    expected_irr: Optional[Decimal] = None
    distribution_cycle: Optional[str] = None
    risk_level: Optional[str] = None

class SukukAsset(SukukAssetBase):
    id: int

    class Config:
        from_attributes = True
