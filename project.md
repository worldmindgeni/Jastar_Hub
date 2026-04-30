# 📱 Jastar Hub Community

## Cross-Platform Mobile Application (Flutter) with AI-Based Event Recommendations (No Firebase, No Docker)

---

## 📊 Current Progress Status

| Module | Status | Progress |
| :--- | :--- | :--- |
| **Section 1: Authentication** | ✅ Done | 100% (JWT, Roles, Profile) |
| **Section 2: Event Actions** | ✅ Done | 100% (Join/Leave/Create backend + UI) |
| **Section 3: AI Recommendations**| ✅ Done | 100% (Hybrid FastAPI integration) |
| **Section 4: Real-time Chat** | ✅ Done | 100% (Socket.io Backend + Real Data UI) |
| **Section 5: Geolocation & Map** | ✅ Done | 100% (Interactive Map with live data) |
| **Section 11: Admin Panel** | ✅ Done | 100% (Backend + Flutter Admin UI) |

---

# 🧱 Technology Stack (Flutter)

## 📱 Frontend (Mobile)

* **Flutter (Dart)** — cross-platform development (iOS & Android)
* **Dart** — main programming language
* **Bloc / Cubit (flutter_bloc)** — state management
* **GoRouter / AutoRoute** — navigation
* **Dio** — HTTP client
* **Freezed + JSON Serializable** — models & serialization
* **Flutter Hooks** — optional reactive logic
* **Flutter Map / Google Maps Flutter** — maps & geolocation
* **Hive / Drift (SQLite)** — local storage & caching
* **Flutter Local Notifications** — local notifications
* **socket_io_client** — real-time communication

---

## 🌐 Backend (Custom Server)

* **Node.js (NestJS)** — main backend
* **REST API + WebSocket (Socket.IO)** — communication
* **JWT (Access + Refresh tokens)** — authentication
* **Passport.js** — auth strategies
* **Multer + S3 / Cloudinary** — file uploads

---

## 🗄 Database

* **PostgreSQL** — primary database
* **Prisma ORM** — database layer
* **Redis** — caching, sessions, pub/sub

---

## 🔔 Notifications (No Firebase)

* **Web Push (VAPID)** — push notifications
* **Socket.IO** — real-time notifications
* **node-cron** — scheduled notifications

---

## 🤖 AI / Recommendation System

* **Python (FastAPI)** — ML microservice
* **Scikit-learn** — ML algorithms
* **Pandas / NumPy** — data processing
* **REST API communication with backend**

---

## ☁️ Deployment (Without Docker)

### Manual / VPS Deployment:

* **Ubuntu Server**
* **Nginx** — reverse proxy
* **PM2** — process manager for Node.js
* **Systemd** — service management (optional)
* **Certbot (Let's Encrypt)** — SSL certificates

---

# ⚙️ Full Application Functionality

---

## 👤 1. Authentication & User Management

### Features:

* Registration:

  * Email & password
* Login:

  * JWT authentication (access + refresh tokens)
* Logout
* Password recovery via email

### Profile:

* Avatar upload
* Name, bio
* Interests (categories)
* Event history
* Favorites

---

## 📅 2. Event Management System

### Event Feed:

* List of events
* Infinite scroll (pagination)
* Sorting:

  * By date
  * By popularity
  * By distance

### Filters:

* Category
* City
* Date range
* Price (free/paid)

### Event Details:

* Title
* Description
* Images
* Date & time
* Location (map + coordinates)
* Organizer info
* Participants list

### Actions:

* Join event
* Leave event
* Add to favorites
* Share event

---

## 🤖 3. AI Recommendation System

### Data Used:

* User interests
* Event interactions (views, joins, likes)
* Time-based behavior
* Similar users

### Features:

* Personalized home feed
* “Recommended for you”
* Similar events block
* Trending events

### Algorithms:

* Content-Based Filtering
* Collaborative Filtering
* Hybrid Model

---

## 💬 4. Chat & Communication

### Technology:

* WebSocket (Socket.IO)
* Redis (pub/sub)

### Features:

* Private chat
* Event group chat
* Typing indicators
* Read receipts
* Message history

---

## 📍 5. Geolocation & Maps

* Detect user location
* Show nearby events
* Interactive map
* Radius filter
* Route to event

---

## 🔔 6. Notifications

### Types:

* New event recommendations
* Event reminders
* Chat messages
* System alerts

### Implementation:

* Web Push via backend
* Local notifications (Flutter)
* Real-time (WebSocket)

---

## 🎫 7. Ticket System & QR

* Generate QR code after registration
* Event check-in system
* QR scanning (organizers)
* Attendance tracking

---

## 🧑‍🤝‍🧑 8. Social Features

* Follow users
* Activity feed
* Invite friends
* Like & comment system

---

## 🎮 9. Gamification

* Points for participation
* Levels & ranks
* Achievements (badges)
* Leaderboard

---

## 💰 10. Monetization

* Paid events
* Commission system
* Event promotion (boost)
* Premium subscription

---

## 🛠 11. Admin Panel

### Features:

* CRUD events
* User moderation
* Ban / unblock users
* Category management
* Reports system

---

## 📊 12. Analytics

* User activity tracking
* Event popularity
* Engagement metrics
* Logs & monitoring

---

## 🔒 13. Security

* JWT authentication
* Password hashing (bcrypt)
* DTO validation
* Rate limiting
* CORS protection
* 2FA (optional)

---

## ⚡ 14. Additional Features

* Dark / light theme
* Multi-language support (EN / RU / KZ)
* Offline mode (cached events)
* Image optimization
* Deep linking

---

# 🏗 Architecture

Flutter App
⬇
REST API (NestJS)
⬇
PostgreSQL + Redis
⬇
AI Service (FastAPI)

---

# 📂 Flutter Project Structure

```id="flutter_struct_no_docker"
lib/
 ├── core/
 │    ├── network/
 │    ├── theme/
 │    ├── utils/
 │    └── constants/
 ├── features/
 │    ├── auth/
 │    ├── events/
 │    ├── profile/
 │    ├── chat/
 │    ├── map/
 │    ├── notifications/
 │    ├── recommendations/
 │    └── admin/
 ├── shared/
 │    ├── widgets/
 │    └── models/
 └── main.dart
```

---

# 📂 Backend Structure

```id="backend_struct_no_docker"
src/
 ├── modules/
 ├── controllers/
 ├── services/
 ├── gateways/
 ├── dto/
 ├── entities/
 └── utils/
```

---

# 🚀 Main Screens

* Splash Screen
* Onboarding
* Login / Register
* Home (AI Feed)
* Events List
* Event Details
* Map
* Chat
* Profile
* Notifications
* Admin Panel

---

# 💻 Local Development Setup

### 1. Backend (NestJS)
1. Navigate to `jastar_hub_backend`.
2. Install dependencies: `npm install`.
3. Configure `.env` with your PostgreSQL `DATABASE_URL`.
4. Run migrations: `npx prisma migrate dev`.
5. Seed database: `npm run seed`. (Populates 100+ events/users).
6. Start: `npm run start:dev`. (Listens on port 3000 at `0.0.0.0`).

### 2. Frontend (Flutter)
1. Navigate to `jastar_hub_community`.
2. Configure IP in `lib/core/network/dio_client.dart`:
   - Use `10.0.2.2` for Emulator.
   - Use your PC's local IP (e.g., `192.168.0.8`) for Physical Device.
3. Ensure JDK 17 is installed (Run `flutter doctor -v` to check).
4. For Physical Device: Enable **USB Debugging** and **Install via USB** in Developer Options.
5. Run: `flutter run`.

---

# 📌 Conclusion

The **Jastar Hub Community (Flutter version)** provides:

* Full control without Firebase and Docker
* Flexible manual deployment (VPS-ready)
* AI-powered personalization
* Scalable and production-ready architecture
* **Recent Updates**: Implemented Shimmer loading, pull-to-refresh, and secure JWT session management.

---
