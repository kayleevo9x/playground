from logging import getLogger
from fastapi import APIRouter
from sqlalchemy import text

from url_shortener.config import settings
from url_shortener.database.database import engine

_LOGGER = getLogger(settings.LOGGER_NAME)

router = APIRouter(prefix="/health")

metadata = {
    "name": "health",
    "description": "Healthcheck endpoint for monitoring",
}


@router.get("/", summary="Health Check", tags=["health"], include_in_schema=False)
async def health():
    """
    API health check endpoint
    """
    is_database_working = True
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
    except Exception as e:
        _LOGGER.error(str(e))
        is_database_working = False

    return {"api": True, "database": is_database_working}
