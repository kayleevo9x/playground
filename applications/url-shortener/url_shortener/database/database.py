from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from url_shortener.config import settings
from url_shortener.database.models import Base

engine = create_engine(settings.SQLALCHEMY_DATABASE_URI)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def create_db():
    Base.metadata.create_all(engine)
