from fastapi import APIRouter
from app.api.endpoints import health

api_router = APIRouter(prefix="/api/v1")

# Include OCR endpoints
api_router.include_router(health.router, tags=["health"])
