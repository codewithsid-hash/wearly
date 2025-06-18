from typing import Optional
from pydantic import BaseModel

class ClothingItem(BaseModel):
    label: str
    category: str
    season: str
    washed: bool
    ironed: bool


class Season(BaseModel):
    name: str

class ClothingTag(BaseModel):
    item_id: int
    category: Optional[str] = None      # e.g., "Shirt", "Pant"
    season: Optional[str] = None        # e.g., "Summer"
    is_favorite: Optional[bool] = False
    tags: Optional[list[str]] = None     # e.g., ["Casual", "Office"]