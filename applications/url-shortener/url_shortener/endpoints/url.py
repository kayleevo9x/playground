from url_shortener.config import settings
import os
from logging import getLogger
from fastapi import APIRouter, Depends, Request, Form, HTTPException
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session
from url_shortener.database.schemas import ShortUrl, ShortUrlCreate
from url_shortener.database.database import get_db
from url_shortener.services.url import (
    create_short_url,
    search_original_url,
    get_short_urls,
    delete_short_url,
)

_LOGGER = getLogger(settings.LOGGER_NAME)

templates = Jinja2Templates(
    directory=f"{os.getcwd()}/url_shortener/templates/")
router = APIRouter()


@router.get("/", response_class=HTMLResponse)
def read_form(request: Request, error_message: str = None, message: str = None):
    return templates.TemplateResponse(
        "form.html",
        {"request": request, "error_message": error_message, "message": message},
    )


@router.post(
    "/generate/",
    summary="Create short url",
    tags=["shorturl"],
    response_model=ShortUrl,
    response_class=HTMLResponse,
)
def generate(request: Request, url: str = Form(), db: Session = Depends(get_db)):
    """
    Create short URL
    """
    input_url = ShortUrlCreate(url=url)
    try:
        short_url = create_short_url(db=db, input_url=input_url)
        return templates.TemplateResponse(
            "result.html",
            {"request": request, "short_url": short_url},
        )
    except HTTPException as e:
        return RedirectResponse(url=f"/?error_message={e.detail}", status_code=303)


@router.get(
    "/search/{short_url:path}",
    summary="Search original url from short url",
    tags=["shorturl"],
    response_model=ShortUrl,
    response_class=HTMLResponse,
)
def fetch_original_url(request: Request, short_url: str, db: Session = Depends(get_db)):
    """
    Search original URL from short URL
    """
    try:
        original_url = search_original_url(db=db, short_url=short_url)
        return templates.TemplateResponse(
            "result.html",
            {
                "request": request,
                "short_url": short_url,
                "original_url": original_url,
            },
        )
    except HTTPException as e:
        return RedirectResponse(url=f"/?error_message={e.detail}", status_code=303)


@router.get(
    "/fetchall/",
    summary="Get all existing short URLs",
    tags=["shorturl"],
    response_model=list[ShortUrl],
    response_class=HTMLResponse,
)
def fetch_short_urls(request: Request, db: Session = Depends(get_db)):
    """
    Retreive all existing short URLs
    """
    try:
        all_urls = get_short_urls(db=db)
        return templates.TemplateResponse(
            "result.html", {"request": request, "short_urls": all_urls}
        )
    except HTTPException as e:
        return RedirectResponse(url=f"/?error_message={e.detail}", status_code=303)


@router.delete(
    "/delete/{short_url:path}",
    summary="Deletes short URL",
    tags=["shorturl"],
)
def delete_url(short_url: str, db: Session = Depends(get_db)):
    """
    Deletes short URL
    """
    return delete_short_url(db=db, short_url=short_url)
