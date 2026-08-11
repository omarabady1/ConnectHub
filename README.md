# 🚀 ConnectHub

<div align="center">

  ![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
  ![Bloc](https://img.shields.io/badge/State%20Management-Bloc%2FCubit-blue?style=for-the-badge)
  ![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success?style=for-the-badge)

  <p align="center">
    <b>A modern, feature-rich social media application built with Flutter, Firebase, and Clean Architecture.</b>
  </p>

</div>

---

## 🌐 Overview

**ConnectHub** is a cross-platform social network mobile application designed for seamless community interaction and content creation. Built with **Flutter** and powered by **Firebase**, the platform offers authentication, real-time post feeds, interactive engagement (likes and comments), profile management, and an **AI-powered assistant chatbot** to help users spark post ideas and draft engaging content.

The project strictly follows **Clean Architecture** principles and **Feature-based organization**, guaranteeing high maintainability, testability, and scalability.

---

## ✨ Key Features

- 🔐 **Authentication System**:
  - Email & Password Sign Up / Login with robust error handling.
  - One-tap **Google Sign-In** integration.
  - Persistent login state and secure user session management.

- 📰 **Interactive Newsfeed**:
  - Real-time updates for posts shared across the community.
  - Post interaction capabilities including likes and comments.
  - Detailed post views with threaded discussions.

- ✍️ **Post Creation & Media Upload**:
  - Rich text formatting and image upload support.
  - Cloud image hosting powered by **ImgBB API**.

- 🤖 **AI Assistant Chatbot**:
  - Smart AI companion integrated into the app.
  - Helps users brainstorm creative post ideas, caption suggestions, and content outlines.
  - Configurable backend webhooks with dynamic fallback configuration via Cloud Firestore and `.env`.

- 👤 **Personalized User Profiles**:
  - User-specific profile dashboard showing published posts and user stats.
  - Profile image customization and personal account overview.

- 🎨 **Modern UI & UX**:
  - Beautiful Material Design 3 interface with Google Fonts typography (`google_fonts`).
  - Optimized image caching via `cached_network_image`.
  - SVG support using `flutter_svg`.

---

## 📱 App Screenshots

<table align="center">
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/1c0b495a-c905-45e6-bbbb-32d0acd79d36" width="230"><br><br>
      <b>🏠 Home Feed</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/66f45c49-abf2-42fa-a2a8-9ef48d3e99ec" width="230"><br><br>
      <b>🤖 AI Chatbot</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/f3e83f46-91fd-4dc5-b52e-773992344fda" width="230"><br><br>
      <b>👤 User Profile</b>
    </td>
  </tr>
</table>

---

## 🏗️ Architecture & Design Pattern

ConnectHub adheres to **SOLID principles** and **Clean Architecture**, separating software responsibilities into three primary layers per feature:

```
                  ┌─────────────────────────────────┐
                  │       Presentation Layer        │
                  │   (UI Widgets & Bloc / Cubit)   │
                  └────────────────┬────────────────┘
                                   │
                                   ▼
                  ┌─────────────────────────────────┐
                  │          Domain Layer           │
                  │   (Entities & Use Cases/Repos)  │
                  └────────────────┬────────────────┘
                                   │
                                   ▼
                  ┌─────────────────────────────────┐
                  │            Data Layer           │
                  │ (Models, Repos Impl, DataSrcs)  │
                  └─────────────────────────────────┘
```

- **Data Layer**: Implements database interactions (Cloud Firestore), API calls (ImgBB API, Webhooks), and handles data transformations (Models, Serializers).
- **Domain Layer**: Contains business entities and repository abstractions, fully decoupled from external dependencies.
- **Presentation Layer**: Consists of modular Flutter widgets driven by **Bloc / Cubit** for reactive state management.
- **Core Layer**: Houses global services, routing logic, dependency injection setup (`get_it`), custom exceptions, and utility functions.

---

## 🛠️ Tech Stack & Dependencies

| Category | Technologies / Libraries |
| :--- | :--- |
| **Framework & Language** | [Flutter](https://flutter.dev), [Dart](https://dart.dev) |
| **Backend & Auth** | Firebase Core, Firebase Auth, Cloud Firestore, Google Sign-In |
| **State Management** | `flutter_bloc` (Bloc / Cubit), `rxdart` |
| **Dependency Injection** | `get_it` |
| **Error & Data Handling**| `dartz` (Functional programming & Either type) |
| **Network & Media** | ImgBB API, `cached_network_image`, `image_picker`, `flutter_svg` |
| **Configuration** | `flutter_dotenv` |
| **UI & Typography** | `google_fonts`, `cupertino_icons` |

---

## 📂 Project Structure

```bash
lib/
├── main.dart                      # Application entry point
├── firebase_options.dart          # Firebase platform options
├── constants.dart                 # Application-wide constants
├── core/                          # Shared utilities and infrastructure
│   ├── errors/                    # Custom failure and exception classes
│   ├── functions/                 # Dependency injection setup & helpers
│   ├── services/                  # Firebase, Firestore, ImgBB & Local Storage
│   └── utils/                     # App styles, backend endpoints, and assets
└── features/                      # Feature-first modular organization
    ├── authentication/            # Sign In, Sign Up, Google Auth
    ├── splash/                    # Animated initial landing screen
    ├── home/                      # Main community post feed
    ├── create_post/              # Post publishing and image uploads
    ├── post_details/              # Individual post view and comment thread
    ├── profile/                   # User profile and post history
    └── chatbot/                   # AI content assistant bot
```

---

## 🚀 Getting Started

Follow these steps to set up and run ConnectHub locally on your machine.

### Prerequisites

Ensure you have the following installed on your development environment:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.12+ recommended)
- [Dart SDK](https://dart.dev/get-started/get-dart)
- Android Studio or VS Code with Flutter extensions
- A Firebase project set up on the [Firebase Console](https://console.firebase.google.com/)
- An ImgBB API key from [ImgBB API](https://api.imgbb.com/)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/omarabady1/ConnectHub.git
   cd connect_hub
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**:
   Create a `.env` file in the project root directory and define the following variables:
   ```env
   IMGBB_API_KEY=your_imgbb_api_key_here
   CHATBOT_WEBHOOK_URL=your_chatbot_webhook_url_here
   ```

4. **Setup Firebase**:
   - Add your `google-services.json` file inside `android/app/`.
   - Ensure `firebase_options.dart` matches your Firebase application credentials.

5. **Run the Application**:
   ```bash
   flutter run
   ```

---

## 📄 License

This project is open-source and available under the standard project license.

