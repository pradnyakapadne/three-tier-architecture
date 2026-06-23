from fastapi import FastAPI

from app.db.database import Base
from app.db.database import engine

from app.routes.product import router

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(router)


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }