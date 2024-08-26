import os
from os.path import dirname, abspath
from typing import Optional, Union
from pydantic import PostgresDsn, field_validator, ValidationInfo
from pydantic_settings import BaseSettings, SettingsConfigDict

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

    LOG_LEVEL: str = "INFO"
    LOGGER_NAME: str = "url-shortener-log"

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
