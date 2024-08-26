from fastapi import FastAPI
from logging.config import dictConfig
from url_shortener.config import log_config
from url_shortener.endpoints import all_routers, all_metadata
from prometheus_fastapi_instrumentator import Instrumentator
from url_shortener.database.database import create_db


create_db()
app = FastAPI(openapi_tags=all_metadata)
dictConfig(log_config)


for router in all_routers:
    app.include_router(router)

instrumentator = (
    Instrumentator(
        should_group_status_codes=False,
        should_ignore_untemplated=True,
        should_respect_env_var=True,
        should_instrument_requests_inprogress=True,
        excluded_handlers=["/metrics"],
        env_var_name="ENABLE_METRICS",
        inprogress_name="inprogress",
        inprogress_labels=True,
    )
    .instrument(app)
    .expose(app, include_in_schema=False, should_gzip=True)
)
