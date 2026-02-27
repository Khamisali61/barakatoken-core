from typing import Any
from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.api import deps
from app.models.user import User
from app.services.mpesa import mpesa_service

router = APIRouter()

@router.post("/callback")
async def mpesa_callback(request: Request, db: Session = Depends(get_db)) -> Any:
    callback_data = await request.json()
    print(f"M-Pesa Callback: {callback_data}")
    result = mpesa_service.handle_callback(db, callback_data)
    return result

@router.post("/stk-push")
async def stk_push(
    amount: float,
    phone_number: str,
    user_id: int, # In production this would come from current_user
    db: Session = Depends(get_db)
) -> Any:
    result = mpesa_service.initiate_stk_push(db, user_id, amount, phone_number)
    return result

@router.post("/mock-topup")
async def mock_topup(
    amount: float,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user),
) -> Any:
    result = mpesa_service.mock_topup(db, current_user.id, amount)
    return result
