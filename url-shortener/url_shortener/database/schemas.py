from pydantic import BaseModel


class ShortUrlBase(BaseModel):
    url: str
    original_url: str


class ShortUrlCreate(ShortUrlBase):
    pass


class ShortUrl(ShortUrlBase):
    id: int
    url: str
    original_url: str

    class Config:
        from_attributes = True
