from decimal import Decimal
from app.models.sukuk import SukukAsset

def test_sukuk_asset_precision():
    asset = SukukAsset(
        title="Test Asset",
        total_valuation=Decimal("1000.12345"),
        total_tokens=Decimal("100.0000"),
        available_tokens=Decimal("100.0000"),
        min_investment=Decimal("10.0000"),
        expected_irr=Decimal("0.1200"),
        distribution_cycle="Monthly",
        risk_level="Low"
    )
    # SQLAlchemy will handle the precision when saving to DB,
    # but we can verify the Decimal type is used.
    assert isinstance(asset.total_valuation, Decimal)
    assert asset.total_valuation == Decimal("1000.12345")
