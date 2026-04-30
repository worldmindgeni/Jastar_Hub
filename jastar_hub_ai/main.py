import uvicorn
from fastapi import FastAPI, HTTPException
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer
import requests

import os

app = FastAPI(title="Jastar Hub AI Recommendation Service")

BACKEND_URL = os.getenv("BACKEND_URL", "http://localhost:3000")

@app.get("/")
def read_root():
    return {"message": "Jastar Hub AI Service is running"}

@app.get("/recommend/{user_id}")
def recommend_events(user_id: str):
    try:
        # 1. Fetch data from backend
        users_resp = requests.get(f"{BACKEND_URL}/users")
        events_resp = requests.get(f"{BACKEND_URL}/events")
        
        if users_resp.status_code != 200 or events_resp.status_code != 200:
            raise HTTPException(status_code=500, detail="Failed to fetch data from backend")
            
        users = users_resp.json()
        events = events_resp.json()
        
        # 2. Find target user
        target_user = next((u for u in users if u['id'] == user_id), None)
        if not target_user:
            raise HTTPException(status_code=404, detail="User not found")
        
        user_interests = " ".join(target_user.get('interests', []))
        if not user_interests:
            # Return most popular events if no interests
            return sorted(events, key=lambda x: x.get('attendeesCount', 0), reverse=True)[:5]

        # 3. Content-Based Recommendation using TF-IDF
        # Combine event title, description and category for better matching
        event_texts = [f"{e['title']} {e['description']} {e['category']}" for e in events]
        
        tfidf = TfidfVectorizer(stop_words='english')
        tfidf_matrix = tfidf.fit_transform(event_texts)
        
        # Transform user interests into same space
        user_vector = tfidf.transform([user_interests])
        
        # Compute cosine similarity
        cosine_sim = cosine_similarity(user_vector, tfidf_matrix)
        
        # Get scores
        sim_scores = list(enumerate(cosine_sim[0]))
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
        
        # Get top 5 event indices
        top_indices = [i[0] for i in sim_scores[:5]]
        
        return [events[i] for i in top_indices]

    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
