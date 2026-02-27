from sqlalchemy import text
from app.db.session import engine
from app.db.base import Base

def refresh_db():
    print("Refreshing database...")
    with engine.connect() as conn:
        print("Dropping all tables (with CASCADE)...")
        # Use a raw SQL command to drop everything in the public schema
        # This is more reliable for handling foreign key constraints than drop_all
        conn.execute(text("DROP SCHEMA public CASCADE;"))
        conn.execute(text("CREATE SCHEMA public;"))
        conn.execute(text("GRANT ALL ON SCHEMA public TO public;"))
        conn.commit()

    print("Creating all tables...")
    Base.metadata.create_all(bind=engine)
    print("Database refreshed successfully!")

if __name__ == "__main__":
    refresh_db()
