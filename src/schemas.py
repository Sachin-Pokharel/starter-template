from pydantic import BaseModel
from typing import Optional

class Item(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None

class User(BaseModel):
    id: int
    username: str
    email: str
    is_active: bool = True
