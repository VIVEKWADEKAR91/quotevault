# QuoteVault 📖✨

QuoteVault is a full-featured quote discovery and collection app built using **Flutter** and **Supabase**.  
The app allows users to discover inspirational quotes, save favorites, create collections, and personalize their experience.

---

## 🚀 Features

### Authentication (Supabase Auth)
- Email & password sign up
- Login / Logout
- Password reset
- Session persistence
- User profile screen

### Quote Discovery
- Browse quotes by category:
  - Motivation
  - Love
  - Success
  - Wisdom
  - Humor
- Search by quote text
- Search/filter by author
- Pull-to-refresh
- Loading & empty states

### Favorites & Collections
- Save quotes to favorites
- View all favorites
- Create custom collections
- Add / remove quotes from collections
- Cloud sync using Supabase

### Daily Quote
- Quote of the Day on home screen
- Daily quote logic
- (Planned) Push notification support

### Sharing
- Share quote text using system share
- Shareable quote cards
- Save quote cards as image

### Personalization
- Light / Dark mode
- Theme support
- Font size adjustment
- Settings persistence

---

## 🛠 Tech Stack

- **Flutter**
- **Supabase**
  - Authentication
  - PostgreSQL database
- **State Management:** Provider
- **Design:** Stitch (Google)

---

## 🗄 Database Schema

Tables:
- `quotes`
- `user_favorites`
- `collections`

Seeded with 100+ quotes across 5 categories.

---

## 🔐 Supabase Setup

1. Create a Supabase project
2. Enable Email Auth
3. Create required tables
4. Add Supabase URL & anon key in app config

---

## 🤖 AI Tools & Workflow

This project was built using AI tools to accelerate development:
- ChatGPT – architecture, Supabase setup, Flutter UI
- AI-assisted debugging & refactoring
- Prompt-driven UI generation using Stitch

AI helped:
- Design screens quickly
- Debug Gradle / Flutter issues
- Generate SQL schemas
- Improve UI & UX consistency

---

## 📹 Loom Video
(Explain app demo, design process, and AI workflow)

---

## ⚠️ Known Limitations
- Widget support not implemented
- Push notifications partially implemented

---

## 📄 License
MIT
