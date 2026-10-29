from typing import List

from pydantic import BaseModel, Field


class FoodItem(BaseModel):
    name: str = Field(description="Yemeğin adı (Türkçe)")
    portion: str = Field(description="Tahmini porsiyon, ör. '1 tabak (250 g)'")
    calories: int = Field(description="Tahmini kalori (kcal)")
    protein_g: float
    carbs_g: float
    fat_g: float


class FoodAnalysis(BaseModel):
    items: List[FoodItem]
    total_calories: int
    confidence: float = Field(description="0-1 arası güven skoru")
    notes: str = Field(description="Kullanıcıya kısa açıklama veya uyarı")
