from pydantic import BaseModel, ConfigDict


class ShortUrlBase(BaseModel):
    url: str


class ShortUrlCreate(ShortUrlBase):
    pass


class ShortUrl(ShortUrlBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    url: str
    original_url: str
