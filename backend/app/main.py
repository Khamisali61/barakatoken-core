from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.api.v1.endpoints import auth, assets, payments, admin, websocket, analytics
from app.core.json_encoder import CustomJSONResponse

app = FastAPI(
    title="BarakaToken API",
    default_response_class=CustomJSONResponse
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(assets.router, prefix="/api/v1/assets", tags=["assets"])
app.include_router(payments.router, prefix="/api/v1/payments", tags=["payments"])
app.include_router(admin.router, prefix="/api/v1/admin", tags=["admin"])
app.include_router(analytics.router, prefix="/api/v1/analytics", tags=["analytics"])
app.include_router(websocket.router, prefix="/api/v1/ws", tags=["websocket"])

# Serve media files
app.mount("/media", StaticFiles(directory="media"), name="media")

@app.get("/")
async def root():
    return {"message": "Welcome to BarakaToken API"}
