from .health import router as health_router, metadata as health_metadata
from .url import router as short_url_router

all_routers = [
    health_router,
    short_url_router,
]
all_metadata = [
    health_metadata,
]
__all__ = ["all_routers", "all_metadata"]
