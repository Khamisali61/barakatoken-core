import os
from pydantic_settings import BaseSettings
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    PROJECT_NAME: str = "BarakaToken"
    SECRET_KEY: str = os.getenv("SECRET_KEY", "supersecret")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    DATABASE_URL: str = os.getenv("DATABASE_URL")

    MPESA_CONSUMER_KEY: str = os.getenv("MPESA_CONSUMER_KEY")
    MPESA_CONSUMER_SECRET: str = os.getenv("MPESA_CONSUMER_SECRET")
    MPESA_SHORTCODE: str = os.getenv("MPESA_SHORTCODE")
    MPESA_PASSKEY: str = os.getenv("MPESA_PASSKEY")
    MPESA_CALLBACK_URL: str = os.getenv("MPESA_CALLBACK_URL")

settings = Settings()
