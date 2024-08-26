from logging import getLogger
import re
import url_shortener.config as config
from pyshorteners import Shortener
from sqlalchemy.orm import Session
from url_shortener.database.schemas import ShortUrlCreate
from url_shortener.database.models import ShortURL
from sqlalchemy.exc import SQLAlchemyError
from fastapi import HTTPException

_LOGGER = getLogger(config.LOGGER_NAME)


def create_short_url(db: Session, input_url: ShortUrlCreate) -> ShortURL:
    url_pattern = "^https?:\\/\\/(?:www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_\\+.~#?&\\/=]*)$"
    valid_url = re.findall(url_pattern, input_url.url)
    if not valid_url:
        raise HTTPException(
            status_code=500, detail=f"{input_url.url} is not a valid URL"
        )
    try:
        short_url = Shortener().tinyurl.short(input_url.url)
        _LOGGER.debug(f"Short URL of {input_url.url} is: {short_url}")
        db_short_url = ShortURL(url=short_url, original_url=input_url.url)
        db.add(db_short_url)
        db.commit()
        db.refresh(db_short_url)
    except SQLAlchemyError as e:
        error_msg = f"Error generating short url. Error: {e}"
        _LOGGER.debug(error_msg)
        raise HTTPException(status_code=500, detail=error_msg)
    return db_short_url


def search_original_url(db: Session, short_url: str) -> ShortURL:
    _LOGGER.debug(f"Search original URL in DB from {short_url}")
    result = db.query(ShortURL).filter(ShortURL.url == short_url).first()

    if not result:
        raise HTTPException(
            status_code=404, detail="No original URL found for the given short URL"
        )

    return result


def get_short_urls(db: Session, skip: int = 0, limit: int = 100) -> list[ShortURL]:
    _LOGGER.debug("Return all existing URLs in DB")
    return db.query(ShortURL).offset(skip).limit(limit).all()
