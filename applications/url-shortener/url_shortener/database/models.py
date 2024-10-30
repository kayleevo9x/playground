from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass


class ShortURL(Base):
    __tablename__ = "short_url"
    id = Column(Integer, primary_key=True)
    url = Column(String, unique=True)
    original_url = Column(String)
