# 🌤️ Weatherly — Flutter Weather App

Weatherly is a clean, Apple-inspired weather application built with **Flutter**.  
It provides real-time weather data, city-based forecasts, authentication, and a smooth user experience with modern UI principles.

This project was built as part of a **Flutter internship assignment** and focuses on clean architecture, reusable UI components, and proper state handling.

---

## ✨ Features

- 🔐 **Firebase Authentication**
    - Email & Password Sign Up / Login
    - Secure logout
    - Auth-based navigation (Login ↔ Home)

- 🌦️ **Real-Time Weather Data**
    - Current temperature & conditions
    - Weather icons and descriptions
    - API-based city search

- 📍 **Saved Cities**
    - Save favorite cities
    - View saved locations in a list
    - Quick access to weather details

- 🎨 **Modern UI / UX**
    - Apple-style clean design
    - Narrow weather tiles
    - Fullscreen weather detail view
    - Light & Dark theme support

- ⚙️ **State Management**
    - Provider for app state handling
    - Centralized weather and auth logic

- 🚦 **User Experience Handling**
    - Loading indicators
    - Error handling (API / network issues)
    - Friendly UI messages

---

## 🛠️ Tech Stack

- **Flutter (Dart)**
- **Firebase Authentication**
- **REST API (Weather API)**
- **Provider (State Management)**
- **Material & Cupertino Design Principles**

---

## 📁 Project Structure

lib/
│── core/
│ ├── app_colors.dart
│ ├── app_strings.dart
│ ├── constants.dart
│
│── models/
│ └── weather_model.dart
│
│── auth/
│ ├── auth_service.dart
│ └── auth_wrapper.dart
│
│── utils/
│ ├── network_helper.dart
│
│── providers/
│ ├── auth_provider.dart
│ └── weather_provider.dart
│
├── screens/
│ │ ├── login_screen.dart
│ │ ├── signup_screen.dart
│ │ ├── home_screen.dart
│ │ └── weather_detail_screen.dart
│ │ └── profile_screen.dart
│ │ └── search_city_sheet.dart
│ │
│ ├── widgets/
│ ├── weather_tile.dart
│ ├── loading_widget.dart
│ └── error_widget.dart
│ └── narrow_card.dart
│
│── firebase_options.dart
│── main.dart






---

## 🔄 App Flow

1. App starts with **AuthWrapper**
2. If user is **not logged in** → Login Screen
3. If user is **logged in** → Home Screen
4. Logout clears session and redirects back to Login
5. Weather data is fetched via API and managed through Provider

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Firebase project setup
- Weather API key

### Installation

```bash
git clone https://github.com/your-username/weatherly.git
cd weatherly
flutter pub get



👨‍💻 Author

Shahzaib
Flutter Developer | PHP & Web Developer