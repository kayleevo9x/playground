import url_shortener.config as config
from logging import getLogger
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from url_shortener.database.schemas import ShortUrl, ShortUrlCreate
from url_shortener.database.database import get_db
from url_shortener.services.generator import (
    create_short_url,
    search_original_url,
    get_short_urls,
)

_LOGGER = getLogger(config.LOGGER_NAME)

router = APIRouter(prefix="/shorturl")


@router.post(
    "/", summary="Create short url", tags=["shorturl"], response_model=ShortUrl
)
def create_short_url(input_url: ShortUrlCreate, db: Session = Depends(get_db)):
    """
    Create short URL
    """
    return create_short_url(db=db, input_url=input_url)


@router.get(
    "/{short_url}",
    summary="Search original url from short url",
    tags=["shorturl"],
    response_model=ShortUrl,
)
def search_original_url(short_url: str, db: Session = Depends(get_db)):
    """
    Search original URL from short URL
    """
    return search_original_url(db=db, short_url=short_url)


@router.get(
    "/",
    summary="Get all existing short URLs",
    tags=["shorturl"],
    response_model=ShortUrl,
)
def get_short_urls(db: Session = Depends(get_db)):
    """
    Retreive all existing short URLs
    """
    return get_short_urls(db=db)
