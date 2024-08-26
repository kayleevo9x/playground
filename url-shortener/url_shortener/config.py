import os
from os.path import dirname, abspath
from typing import Optional, Union
from pydantic import PostgresDsn, field_validator, ValidationInfo
from pydantic_settings import BaseSettings, SettingsConfigDict

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
LOGGER_NAME = os.getenv("LOGGER_NAME", "url-shortener-log")
API_DEV = os.getenv("API_DEV", False)

log_config = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "default": {
            "format": "%(asctime)s : %(levelname)s : %(module)s : %(funcName)s : %(lineno)d : (Process Details : (%(process)d, %(processName)s) - %(message)s",
            "datefmt": "%Y-%m-%d %H:%M:%S",
        },
    },
    "handlers": {
        "default": {
            "formatter": "default",
            "class": "logging.StreamHandler",
            "stream": "ext://sys.stderr",
        },
    },
    "loggers": {
        LOGGER_NAME: {"handlers": ["default"], "level": LOG_LEVEL},
    },
}


class Settings(BaseSettings):
    POSTGRES_PORT: int = "5432"
    POSTGRES_HOST: str = None
    POSTGRES_USER: str = None
    POSTGRES_PASSWORD: str = None
    POSTGRES_DB: str = None
    SQLALCHEMY_DATABASE_URI: Union[Optional[PostgresDsn], Optional[str]] = None
    ENABLE_METRICS: bool = True
    model_config = SettingsConfigDict(
        env_file=f"{dirname(dirname(abspath(__file__)))}/.env", env_file_encoding="utf-8", extra="allow"
    )

    @field_validator("SQLALCHEMY_DATABASE_URI", mode="before")
    @classmethod
    def assemble_db_connection(cls, v: Optional[str], values: ValidationInfo):
        if isinstance(v, str):
            return v
        return PostgresDsn.build(
            scheme="postgresql",
            port=values.data["POSTGRES_PORT"],
            username=values.data["POSTGRES_USER"],
            password=values.data["POSTGRES_PASSWORD"],
            host=values.data["POSTGRES_HOST"],
            path=f"{values.data["POSTGRES_DB"] or ''}",
        ).unicode_string()


settings = Settings()
