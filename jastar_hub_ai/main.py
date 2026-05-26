import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer
import requests
import os
import logging
import re
from datetime import datetime

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Jastar Hub AI Service")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BACKEND_URL = os.getenv("BACKEND_URL", "http://localhost:3000")


# ─── Модели запросов ──────────────────────────────────────────────────────────

class ChatMessage(BaseModel):
    message: str
    user_id: str | None = None
    context: list[dict] | None = None  # история предыдущих сообщений


class ChatResponse(BaseModel):
    reply: str
    suggestions: list[str] = []


# ─── Вспомогательные функции ──────────────────────────────────────────────────

def fetch_data():
    """Получаем пользователей и события с бэкенда."""
    try:
        users_resp = requests.get(f"{BACKEND_URL}/users", timeout=10)
        events_resp = requests.get(f"{BACKEND_URL}/events", timeout=10)

        if users_resp.status_code != 200 or events_resp.status_code != 200:
            return [], []

        return users_resp.json(), events_resp.json()
    except requests.exceptions.ConnectionError as e:
        logger.warning(f"Backend unreachable: {e}")
        return [], []


def build_tfidf(events):
    if not events:
        return None, None
    texts = [
        f"{e.get('title', '')} {e.get('description', '')} {e.get('category', '')} {e.get('city', '')}"
        for e in events
    ]
    tfidf = TfidfVectorizer(stop_words='english')
    matrix = tfidf.fit_transform(texts)
    return tfidf, matrix


def format_event(event: dict) -> str:
    """Форматируем событие для ответа ассистента."""
    title = event.get('title', 'Без названия')
    date = event.get('date', '')
    location = event.get('location', '')
    price = event.get('price', 0)
    price_str = 'Бесплатно' if price == 0 else f'{int(price)} ₸'

    try:
        dt = datetime.fromisoformat(date.replace('Z', '+00:00'))
        date_str = dt.strftime('%d %b, %H:%M')
    except Exception:
        date_str = date

    return f"• **{title}** — {date_str}, {location} ({price_str})"


# ─── AI Ассистент ─────────────────────────────────────────────────────────────

def generate_ai_reply(message: str, user_id: str | None, events: list) -> tuple[str, list[str]]:
    """
    Простой rule-based + content-based ассистент.
    Отвечает на вопросы о событиях, категориях, рекомендациях.
    """
    msg_lower = message.lower().strip()
    suggestions = []

    # Приветствие
    if any(w in msg_lower for w in ['привет', 'здравствуй', 'hello', 'hi', 'салем']):
        return (
            "Привет! 👋 Я ИИ-ассистент Jastar Hub. Могу помочь найти интересные события, "
            "ответить на вопросы о мероприятиях или порекомендовать что-то по твоим интересам.\n\n"
            "Попробуй спросить:\n• «Что есть бесплатного?»\n• «Покажи IT события»\n• «Что популярно сейчас?»",
            ["Бесплатные события", "IT события", "Популярное"]
        )

    # Бесплатные события
    if any(w in msg_lower for w in ['бесплатн', 'free', 'тегін']):
        free = [e for e in events if e.get('price', 0) == 0][:5]
        if not free:
            return "Сейчас бесплатных событий нет, но скоро появятся! 🙂", []
        lines = [format_event(e) for e in free]
        return f"Вот бесплатные мероприятия 🎉\n\n" + "\n".join(lines), ["Показать все", "IT события", "Спорт"]

    # Поиск по категории
    category_map = {
        'технолог': 'technology', 'it': 'technology', 'программ': 'technology', 'flutter': 'technology',
        'спорт': 'sports', 'фитнес': 'sports', 'йога': 'wellness',
        'музык': 'music', 'концерт': 'music',
        'искусств': 'art', 'выставк': 'art',
        'еда': 'food', 'фестиваль': 'food', 'гастро': 'food',
        'образован': 'education', 'курс': 'education', 'воркшоп': 'education',
        'бизнес': 'business', 'стартап': 'business',
        'культур': 'culture',
        'здоровь': 'wellness', 'wellness': 'wellness',
        'развлечен': 'entertainment', 'кино': 'entertainment',
    }

    matched_category = None
    for keyword, cat in category_map.items():
        if keyword in msg_lower:
            matched_category = cat
            break

    if matched_category:
        cat_events = [e for e in events if e.get('category', '').lower() == matched_category][:5]
        if not cat_events:
            return f"По категории «{matched_category}» пока ничего нет. Попробуй другую! 🔍", []
        lines = [format_event(e) for e in cat_events]
        return f"Нашёл события по теме 🔎\n\n" + "\n".join(lines), ["Бесплатные", "Популярное", "Все события"]

    # Популярные / трендовые
    if any(w in msg_lower for w in ['популярн', 'тренд', 'топ', 'popular', 'trending']):
        popular = sorted(events, key=lambda x: x.get('attendeesCount', 0), reverse=True)[:5]
        if not popular:
            return "Пока нет данных о популярных событиях.", []
        lines = [format_event(e) for e in popular]
        return "Самые популярные события прямо сейчас 🔥\n\n" + "\n".join(lines), ["Бесплатные", "IT события"]

    # Ближайшие / скоро
    if any(w in msg_lower for w in ['ближайш', 'скоро', 'сегодня', 'завтра', 'upcoming']):
        now = datetime.utcnow()
        upcoming = [
            e for e in events
            if e.get('date') and datetime.fromisoformat(e['date'].replace('Z', '+00:00')).replace(tzinfo=None) > now
        ]
        upcoming.sort(key=lambda x: x.get('date', ''))
        top = upcoming[:5]
        if not top:
            return "Ближайших событий пока нет.", []
        lines = [format_event(e) for e in top]
        return "Ближайшие мероприятия 📅\n\n" + "\n".join(lines), ["Популярное", "Бесплатные"]

    # Поиск по тексту
    if len(msg_lower) > 3:
        found = [
            e for e in events
            if msg_lower in e.get('title', '').lower()
            or msg_lower in e.get('description', '').lower()
            or msg_lower in e.get('location', '').lower()
        ][:5]
        if found:
            lines = [format_event(e) for e in found]
            return f"Нашёл по запросу «{message}» 🔍\n\n" + "\n".join(lines), []

    # Помощь
    if any(w in msg_lower for w in ['помог', 'help', 'что умеешь', 'что ты']):
        return (
            "Я умею:\n\n"
            "🔍 Искать события по категории или ключевому слову\n"
            "🎉 Показывать бесплатные мероприятия\n"
            "🔥 Рассказывать о популярных событиях\n"
            "📅 Показывать ближайшие мероприятия\n\n"
            "Просто напиши что тебя интересует!",
            ["IT события", "Бесплатные", "Популярное"]
        )

    # Дефолтный ответ
    suggestions = ["Бесплатные события", "IT события", "Популярное", "Ближайшие"]
    return (
        f"Не совсем понял запрос «{message}» 🤔\n\n"
        "Попробуй спросить о конкретной категории или написать название события. "
        "Например: «IT события», «бесплатные», «популярное».",
        suggestions
    )


# ─── Эндпоинты ────────────────────────────────────────────────────────────────

@app.get("/")
def read_root():
    return {"message": "Jastar Hub AI Service is running", "version": "3.0"}


@app.post("/chat", response_model=ChatResponse)
def chat_with_assistant(body: ChatMessage):
    """Чат с AI ассистентом."""
    try:
        _, events = fetch_data()
        reply, suggestions = generate_ai_reply(body.message, body.user_id, events)
        return ChatResponse(reply=reply, suggestions=suggestions)
    except Exception as e:
        logger.error(f"Chat error: {e}")
        return ChatResponse(
            reply="Произошла ошибка. Попробуй ещё раз! 🙏",
            suggestions=[]
        )


@app.get("/recommend/{user_id}")
def recommend_events(user_id: str):
    try:
        users, events = fetch_data()
        if not events:
            return []

        target_user = next((u for u in users if u['id'] == user_id), None)
        if not target_user:
            raise HTTPException(status_code=404, detail="User not found")

        user_interests = " ".join(target_user.get('interests', []))

        if not user_interests:
            popular = sorted(events, key=lambda x: x.get('attendeesCount', 0), reverse=True)
            return popular[:10]

        tfidf, tfidf_matrix = build_tfidf(events)
        if tfidf is None:
            return []

        user_vector = tfidf.transform([user_interests])
        content_scores = cosine_similarity(user_vector, tfidf_matrix)[0]

        max_att = max(e.get('attendeesCount', 1) for e in events) or 1
        popularity_scores = [e.get('attendeesCount', 0) / max_att for e in events]

        hybrid = [0.7 * c + 0.3 * p for c, p in zip(content_scores, popularity_scores)]
        scored = sorted(enumerate(hybrid), key=lambda x: x[1], reverse=True)

        return [events[i] for i, _ in scored[:10]]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Recommendation error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/trending")
def get_trending(limit: int = 10):
    try:
        _, events = fetch_data()
        if not events:
            return []
        return sorted(events, key=lambda x: x.get('attendeesCount', 0), reverse=True)[:limit]
    except Exception as e:
        logger.error(f"Trending error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/similar/{event_id}")
def get_similar_events(event_id: str, limit: int = 5):
    try:
        _, events = fetch_data()
        if not events:
            return []

        target_idx = next((i for i, e in enumerate(events) if e['id'] == event_id), None)
        if target_idx is None:
            raise HTTPException(status_code=404, detail="Event not found")

        tfidf, tfidf_matrix = build_tfidf(events)
        if tfidf is None:
            return []

        sim = cosine_similarity(tfidf_matrix[target_idx:target_idx+1], tfidf_matrix)[0]
        scored = sorted([(i, s) for i, s in enumerate(sim) if i != target_idx], key=lambda x: x[1], reverse=True)

        return [events[i] for i, _ in scored[:limit]]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Similar events error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/health")
def health_check():
    return {"status": "healthy"}


if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BACKEND_URL = os.getenv("BACKEND_URL", "http://localhost:3000")


def fetch_data():
    """Fetch users and events from backend."""
    try:
        users_resp = requests.get(f"{BACKEND_URL}/users", timeout=10)
        events_resp = requests.get(f"{BACKEND_URL}/events", timeout=10)

        if users_resp.status_code != 200:
            logger.error(f"Failed to fetch users: {users_resp.status_code} - {users_resp.text}")
            raise Exception(f"Failed to fetch users from backend: {users_resp.status_code}")
            
        if events_resp.status_code != 200:
            logger.error(f"Failed to fetch events: {events_resp.status_code} - {events_resp.text}")
            raise Exception(f"Failed to fetch events from backend: {events_resp.status_code}")

        return users_resp.json(), events_resp.json()
    except requests.exceptions.ConnectionError as e:
        logger.warning(f"Backend unreachable at {BACKEND_URL}: {e}")
        return [], []


def build_tfidf(events):
    """Build TF-IDF matrix from event texts."""
    if not events:
        return None, None
    event_texts = [
        f"{e.get('title', '')} {e.get('description', '')} {e.get('category', '')} {e.get('city', '')}"
        for e in events
    ]
    tfidf = TfidfVectorizer(stop_words='english')
    tfidf_matrix = tfidf.fit_transform(event_texts)
    return tfidf, tfidf_matrix


@app.get("/")
def read_root():
    return {"message": "Jastar Hub AI Service is running", "version": "2.0"}


@app.get("/recommend/{user_id}")
def recommend_events(user_id: str):
    try:
        users, events = fetch_data()
        if not events:
            return []

        # Find target user
        target_user = next((u for u in users if u['id'] == user_id), None)
        if not target_user:
            raise HTTPException(status_code=404, detail="User not found")

        user_interests = " ".join(target_user.get('interests', []))

        # Fallback: return popular events if no interests
        if not user_interests:
            popular = sorted(events, key=lambda x: x.get('attendeesCount', 0), reverse=True)
            return popular[:10]

        # Content-Based Filtering using TF-IDF
        tfidf, tfidf_matrix = build_tfidf(events)
        if tfidf is None:
            return []

        user_vector = tfidf.transform([user_interests])
        content_scores = cosine_similarity(user_vector, tfidf_matrix)[0]

        # Popularity score (normalized)
        max_attendees = max(e.get('attendeesCount', 1) for e in events) or 1
        popularity_scores = [e.get('attendeesCount', 0) / max_attendees for e in events]

        # Hybrid score: 70% content + 30% popularity
        hybrid_scores = [
            0.7 * content + 0.3 * popularity
            for content, popularity in zip(content_scores, popularity_scores)
        ]

        # Sort by hybrid score
        scored_events = list(enumerate(hybrid_scores))
        scored_events.sort(key=lambda x: x[1], reverse=True)

        # Return top 10
        top_indices = [i for i, _ in scored_events[:10]]
        return [events[i] for i in top_indices]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Recommendation error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/trending")
def get_trending(limit: int = 10):
    """Get trending events based on popularity."""
    try:
        _, events = fetch_data()
        if not events:
            return []

        # Sort by attendees (popularity)
        trending = sorted(events, key=lambda x: x.get('attendeesCount', 0), reverse=True)
        return trending[:limit]

    except Exception as e:
        logger.error(f"Trending error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/similar/{event_id}")
def get_similar_events(event_id: str, limit: int = 5):
    """Get events similar to a given event using content similarity."""
    try:
        _, events = fetch_data()
        if not events:
            return []

        # Find target event
        target_idx = None
        for i, e in enumerate(events):
            if e['id'] == event_id:
                target_idx = i
                break

        if target_idx is None:
            raise HTTPException(status_code=404, detail="Event not found")

        # Build TF-IDF and compute similarity
        tfidf, tfidf_matrix = build_tfidf(events)
        if tfidf is None:
            return []

        cosine_sim = cosine_similarity(tfidf_matrix[target_idx:target_idx+1], tfidf_matrix)[0]

        # Get similar events (exclude self)
        sim_scores = [(i, score) for i, score in enumerate(cosine_sim) if i != target_idx]
        sim_scores.sort(key=lambda x: x[1], reverse=True)

        top_indices = [i for i, _ in sim_scores[:limit]]
        return [events[i] for i in top_indices]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Similar events error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/health")
def health_check():
    return {"status": "healthy"}


if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
