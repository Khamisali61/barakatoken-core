from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from app.services.monitoring import monitor

router = APIRouter()

@router.websocket("/live-market")
async def websocket_endpoint(websocket: WebSocket):
    await monitor.connect(websocket)
    try:
        while True:
            # Keep connection alive
            await websocket.receive_text()
    except WebSocketDisconnect:
        monitor.disconnect(websocket)
