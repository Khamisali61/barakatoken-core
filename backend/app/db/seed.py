from sqlalchemy.orm import Session
from app.db.session import SessionLocal, engine
from app.models.user import User
from app.models.sukuk import SukukAsset
from app.core.security import get_password_hash
from decimal import Decimal

def seed_db():
    db = SessionLocal()

    # Create a test user
    test_user = db.query(User).filter(User.email == "ahmed@example.com").first()
    if not test_user:
        test_user = User(
            full_name="Ahmed Hassan",
            email="ahmed@example.com",
            hashed_password=get_password_hash("password123"),
            is_active=True,
            is_verified=True,
            is_admin=False,
            wallet_address="0x1234567890123456789012345678901234567890"
        )
        db.add(test_user)

    # Create an admin user
    admin_user = db.query(User).filter(User.email == "admin@barakatoken.com").first()
    if not admin_user:
        admin_user = User(
            full_name="Platform Admin",
            email="admin@barakatoken.com",
            hashed_password=get_password_hash("admin123"),
            is_active=True,
            is_verified=True,
            is_admin=True
        )
        db.add(admin_user)

    # Create assets
    assets_data = [
        {
            "title": "Nairobi Green Housing",
            "description": "Sustainable affordable housing project in Nairobi's Westlands area. Phase 1 includes 200 units with solar power and rain water harvesting.",
            "location": "Nairobi, Kenya",
            "total_valuation": Decimal("500000000.0000"),
            "total_tokens": Decimal("50000.0000"),
            "available_tokens": Decimal("11000.0000"), # ~78% funded
            "min_investment": Decimal("5000.0000"),
            "expected_irr": Decimal("0.1200"),
            "distribution_cycle": "Quarterly",
            "risk_level": "Low-Med",
            "image_url": "https://lh3.googleusercontent.com/aida-public/AB6AXuDRDRtd7I-eNIyDLFv8zIRYJi526Z5liZPFn26mMlhhwmZPR8Gdg9lS-vhFlhXclQq9568Cw7AYM21XRP8f0U8kpyQSg5g7Sa5t4eKdrlHfMUNtAR4Md9v-grpVtIgrVclRiP75l2H7tqsxvIAXbEZPA7pFUZy93dXD0Ouar8T1pe5HQhWsNs3wdx77MqUAE6K5URXA1RGLI8HPYIG_tMBJmF1uDL3E7arO-8BBIIa8q-D42Sf6LLkRnCh2oUMKxetdoa3s59lBxnw",
            "legal_doc_url": "https://barakatoken.com/docs/nairobi-green-housing-legal.pdf",
            "shariah_cert_url": "https://barakatoken.com/docs/nairobi-green-housing-shariah.pdf",
            "status": "Active"
        },
        {
            "title": "Mombasa Solar Farm",
            "description": "5MW solar power plant providing clean energy to the coastal region. Guaranteed off-take agreement with local industries.",
            "location": "Mombasa, Kenya",
            "total_valuation": Decimal("350000000.0000"),
            "total_tokens": Decimal("35000.0000"),
            "available_tokens": Decimal("20300.0000"), # ~42% funded
            "min_investment": Decimal("10000.0000"),
            "expected_irr": Decimal("0.1250"),
            "distribution_cycle": "Monthly",
            "risk_level": "Medium",
            "image_url": "https://lh3.googleusercontent.com/aida-public/AB6AXuAWGly4_dI-rp9bYeAsCWTHpIcda3SaQLDhWi-RegJVZzPsIkO2iaGLcTY1AKYGwuj_8YSH8RO261Dj25bCfH192X1O2IbdWrN2EDnxz06iN7Zo3YVC3qNW2AOqOPVhqrbV7ZocL9maPzh5AHEXVXy0u17M7HiGh12sBIb2CzUK2EGFgEVP0fCvoT9K5QO1oucaVeoVddPPpaVrPnWHthmbfhOn5QLjJ3xPA7KO5bTI_Rs_FcdRDH9nimqn1rnybmZcZ8BwyeB3Adw",
            "legal_doc_url": "https://barakatoken.com/docs/mombasa-solar-farm-legal.pdf",
            "shariah_cert_url": "https://barakatoken.com/docs/mombasa-solar-farm-shariah.pdf",
            "status": "Draft"
        }
    ]

    for asset_data in assets_data:
        asset = db.query(SukukAsset).filter(SukukAsset.title == asset_data["title"]).first()
        if not asset:
            asset = SukukAsset(**asset_data)
            db.add(asset)

    db.commit()
    db.close()
    print("Database seeded successfully!")

if __name__ == "__main__":
    seed_db()
