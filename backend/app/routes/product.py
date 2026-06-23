from typing import List

from fastapi import APIRouter
from fastapi import Depends

from sqlalchemy.orm import Session

from app.db.database import get_db
from app.models.product import Product
from app.schemas.product import ProductCreate
from app.schemas.product import ProductResponse

router = APIRouter()


@router.get(
    "/products",
    response_model=List[ProductResponse]
)
def get_products(
    db: Session = Depends(get_db)
):

    return db.query(Product).all()


@router.post(
    "/products",
    response_model=ProductResponse
)
def create_product(
    product: ProductCreate,
    db: Session = Depends(get_db)
):

    db_product = Product(
        name=product.name,
        price=product.price
    )

    db.add(db_product)

    db.commit()

    db.refresh(db_product)

    return db_product