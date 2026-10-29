import base64
import json

from openai import AsyncOpenAI

from .config import settings
from .schemas import FoodAnalysis

client = AsyncOpenAI(api_key=settings.openai_api_key)

SYSTEM_PROMPT = (
    "Sen bir beslenme uzmanısın. Kullanıcının gönderdiği yemek fotoğrafındaki "
    "her yiyeceği tespit et, porsiyonunu tahmin et ve kalori ile makro besin "
    "değerlerini hesapla. Fotoğrafta yemek yoksa items listesini boş bırak, "
    "total_calories 0 olsun ve notes alanında bunu açıkla. Tüm metinler Türkçe olsun."
)

# OpenAI structured output: model cevabı bu şemaya uymak zorunda
RESPONSE_FORMAT = {
    "type": "json_schema",
    "json_schema": {
        "name": "food_analysis",
        "strict": True,
        "schema": {
            "type": "object",
            "additionalProperties": False,
            "required": ["items", "total_calories", "confidence", "notes"],
            "properties": {
                "items": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "additionalProperties": False,
                        "required": ["name", "portion", "calories", "protein_g", "carbs_g", "fat_g"],
                        "properties": {
                            "name": {"type": "string"},
                            "portion": {"type": "string"},
                            "calories": {"type": "integer"},
                            "protein_g": {"type": "number"},
                            "carbs_g": {"type": "number"},
                            "fat_g": {"type": "number"},
                        },
                    },
                },
                "total_calories": {"type": "integer"},
                "confidence": {"type": "number"},
                "notes": {"type": "string"},
            },
        },
    },
}


async def analyze_food_image(image_bytes: bytes, content_type: str) -> FoodAnalysis:
    b64 = base64.b64encode(image_bytes).decode("utf-8")
    data_url = f"data:{content_type};base64,{b64}"

    response = await client.chat.completions.create(
        model=settings.openai_model,
        response_format=RESPONSE_FORMAT,
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": "Bu yemeğin kalorisini hesapla."},
                    {"type": "image_url", "image_url": {"url": data_url}},
                ],
            },
        ],
    )

    content = response.choices[0].message.content or "{}"
    return FoodAnalysis.model_validate(json.loads(content))
