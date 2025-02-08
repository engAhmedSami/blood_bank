تم تعديل ملف README.md ليعكس هيكلة المشروع كما هي موضحة في الصورة التي أرسلتها. إليك النسخة الجديدة:  

```markdown
# 🏥 Blood Donation Management System

## 📌 Overview
A Flutter-based blood donation management system designed to help users find and request blood donations efficiently. The system includes user authentication, request management, notifications, and a well-structured UI with multilingual support (Arabic & English).

## 🛠️ Tech Stack
- **Flutter** (Dart)
- **State Management**: Cubit
- **Database**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Cloud Storage**: Firebase Storage
- **Localization**: Supports Arabic & English

## ✨ Features
- 🔹 **User Authentication** (Signup/Login using Firebase Auth)
- 🔹 **Request Management** (Create, update, and track blood donation requests)
- 🔹 **Multilingual Support** (Arabic & English localization)
- 🔹 **Push Notifications** (Firebase Cloud Messaging)
- 🔹 **Optimized UI Components** (Reusable widgets for better UX)
- 🔹 **Error Handling & Performance Enhancements**

## 📂 Project Structure
```
lib/
│── main.dart                     # Main entry point
│── app_blood_bank.dart            # Main app file
│── constants.dart                 # Constants used across the app
│── firebase_options.dart          # Firebase configuration
│
│── core/                          # Core utilities and services
│   ├── errors/                    # Error handling
│   ├── helper_function/           # Helper functions
│   ├── services/                  # API & background services
│   ├── utils/                      # Utility functions & constants
│   ├── widget/                     # Reusable widgets
│
│── feature/                        # App features
│   ├── auth/                       # Authentication module
│   │   ├── data/                   # Data sources (API, Local storage)
│   │   ├── domain/                 # Models & business logic
│   │   ├── presentation/           # UI screens & components
│   │
│   ├── home/                       # Home screen feature
│   │   ├── data/                   
│   │   ├── domain/                 
│   │   ├── presentation/           
│   │
│   ├── localization/               # Localization & language settings
│   │   ├── cubit/                  # State management for languages
│   │   ├── app_localizations.dart  
│   │   ├── language_cache_helper.dart
│   │   ├── settings_page.dart
│   │
│   ├── notification/               # Push notifications module
│
│   ├── on_boarding/                # Onboarding flow
│   │   ├── presentation/           
│   │   │   ├── views/              # Onboarding screens
│   │   │   ├── widget/             # Onboarding widgets
│   │   │   ├── chooes_to_signup_or_login_view.dart
│   │   │   ├── on_boarding_view.dart
│
│── splash/                         # Splash screen
```

## 🚀 Getting Started
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/blood-donation-app.git
   ```
2. Navigate to the project folder:
   ```sh
   cd blood-donation-app
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## 📜 License
This project is open-source and available under the MIT License.

## 📩 Contact
For any inquiries, feel free to reach out via scarlow011@gmail.com - basel.a.emabay@gmail.com or open an issue in the repository.
```

🔹 تم تعديل **الـ structure** ليعكس الملفات والمجلدات الموجودة في الصورة التي أرسلتها.  
🔹 لو في أي إضافات أو تعديلات، قولي! 🚀🔥
