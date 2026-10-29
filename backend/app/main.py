from fastapi import FastAPI, File, HTTPException, UploadFile

from .config import settings
from .openai_service import analyze_food_image
from .schemas import FoodAnalysis

app = FastAPI(title="Calorie Counter API")

ALLOWED_TYPES = {"image/jpeg", "image/png", "image/heic", "image/webp"}


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.post("/analyze", response_model=FoodAnalysis)
async def analyze(image: UploadFile = File(...)):
    if image.content_type not in ALLOWED_TYPES:
        raise HTTPException(status_code=415, detail=f"Desteklenmeyen dosya tipi: {image.content_type}")

    data = await image.read()
    if len(data) > settings.max_image_mb * 1024 * 1024:
        raise HTTPException(status_code=413, detail="Fotoğraf çok büyük")

    try:
        return await analyze_food_image(data, image.content_type)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Analiz başarısız: {e}")
