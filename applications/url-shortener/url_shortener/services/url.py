from logging import getLogger
import re
from url_shortener.config import settings
from pyshorteners import Shortener
from pyshorteners.exceptions import ShorteningErrorException
from sqlalchemy.orm import Session
from url_shortener.database.schemas import ShortUrlCreate
from url_shortener.database.models import ShortURL
from sqlalchemy.exc import SQLAlchemyError
from fastapi import HTTPException

_LOGGER = getLogger(settings.LOGGER_NAME)


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
        result = db.query(ShortURL).filter(ShortURL.url == short_url).first()
        if result:
            raise HTTPException(
                status_code=500, detail=f"{input_url.url} has already been generated"
            )
        db_short_url = ShortURL(url=short_url, original_url=input_url.url)
        db.add(db_short_url)
        db.commit()
        db.refresh(db_short_url)
    except SQLAlchemyError as e:
        error_msg = f"Error generating short url. Error: {e}"
        _LOGGER.debug(error_msg)
        raise HTTPException(status_code=500, detail=error_msg)
    except ShorteningErrorException as e:
        error_msg = f"There was an error on trying to short the url: url may be invalid"
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


def delete_short_url(db: Session, short_url: str):
    result = db.query(ShortURL).filter(ShortURL.url == short_url).first()
    if not result:
        raise HTTPException(
            status_code=404, detail="URL does not exist in the database"
        )

    try:
        _LOGGER.debug(f"Deleting short URL id: {short_url}")
        db.delete(result)
        db.commit()
    except SQLAlchemyError as e:
        error_msg = f"Error deleting state. Message: {e}"
        _LOGGER.debug(error_msg)
        raise HTTPException(status_code=500, detail=error_msg)

    return {"successful": True}
