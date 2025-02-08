# Blood Donation Management System

## 📌 Overview
A Flutter-based blood donation management system designed to connect individuals in need of blood with potential donors efficiently. The system includes user authentication, request management, and a well-structured UI with multilingual support (Arabic & English).

## 🛠️ Tech Stack
- **Flutter** (Dart)
- **State Management**: Cubit
- **Database**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Cloud Storage**: Firebase Storage
- **Localization**: Supports Arabic & English
- **CI/CD**: Using Shorebird 

## ✨ Features
- 🔹 **User Authentication** (Signup/Login using Firebase Auth)
- 🔹 **Request Management** (Create, update, and track blood donation requests)
- 🔹 **Multilingual Support** (Arabic & English localization)
- 🔹 **Optimized UI Components** (Custom widgets for better UX)
- 🔹 **Error Handling & Performance Enhancements**

## 📂 Project Structure
```
lib/
│-- main.dart
│-- core/
│   ├── errors/
│   ├── helper_function/
│   ├── services/
│   ├── utils/
│-- features/
│   ├── auth/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   ├── localization/
│   │   ├── app_localizations.dart
│   │   ├── language_cache_helper.dart
│   ├── settings_page.dart
│   ├── notification/
│   ├── on_boarding/
│   │   ├── presentation/
│   │   │   ├── views/
│   │   │   │   ├── choose_to_signup_or_login_view.dart
│   │   │   │   ├── on_boarding_view.dart
│   │   ├── widget/
│-- shared/
│   ├── widgets/
│   ├── helper/
│-- splash/
│   ├── app_blood_bank.dart
│   ├── constants.dart
│   ├── firebase_options.dart
│-- 
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
For any inquiries, feel free to reach out via scarlow011@gmail.com - basel.a.embaby@gmail.com or open an issue in the repository.
