import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer
import requests
import os
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Jastar Hub AI Recommendation Service")

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

        if users_resp.status_code != 200 or events_resp.status_code != 200:
            raise Exception("Failed to fetch data from backend")

        return users_resp.json(), events_resp.json()
    except requests.exceptions.ConnectionError:
        logger.warning("Backend unreachable, returning empty data")
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
