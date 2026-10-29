# Kalori Sayacı

Yemek fotoğrafından kalori hesaplayan iOS uygulaması.

- `ios/` — SwiftUI uygulaması (iOS 17+)
- `backend/` — FastAPI + OpenAI Vision

Akış: iOS fotoğraf çeker/seçer → `POST /analyze` (multipart) → backend OpenAI'a gönderir → JSON sonuç döner.

## Backend

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env   # OPENAI_API_KEY'i yaz
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Test: http://localhost:8000/docs

## iOS

```bash
brew install xcodegen
cd ios
xcodegen generate
open CalorieCounter.xcodeproj
```

Simülatörde `localhost` çalışır. Gerçek cihazda `ios/CalorieCounter/Config.swift` içindeki adresi Mac'in yerel IP'si yap.
Kamera simülatörde yok; simülatörde galeri butonunu kullan.
