from fastapi import Request, APIRouter
import logging

# Set up logging
logger = logging.getLogger(__name__)

router = APIRouter()

@router.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "Starter Template"}