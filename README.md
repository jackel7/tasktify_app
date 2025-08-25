📝 Taskify – Real-time To-Do App (Flutter + Firebase)

A simple yet powerful To-Do application built with Flutter and Firebase Realtime Database.
Taskify allows users to create, update, and manage tasks in real-time, with multi-user support.

🚀 Features

✅ User Authentication (Firebase Auth – Email & Password)
✅ Add, Edit, Delete tasks in real-time
✅ Multi-user support (each user has their own task list)
✅ Task priority levels (with color indicators)
✅ Clean & responsive UI
✅ Firebase Realtime Database integration

📸 Screenshots

(Add your app screenshots here – e.g. login screen, task list, add task modal)

🛠️ Tech Stack

Flutter (Dart)

Firebase Authentication

Firebase Realtime Database

FirebaseAnimatedList for real-time UI updates

📂 Project Structure
lib/
 ┣ constants/       # App colors, styles
 ┣ screens/         # Login, Register, Home, AddTask screens
 ┣ widgets/         # Reusable widgets
 ┣ main.dart        # Entry point

⚡ Getting Started
Prerequisites

Flutter installed → Install Flutter

Firebase project set up → Firebase Console

Setup

Clone the repo:

git clone https://github.com/your-username/taskify.git
cd taskify


Install dependencies:

flutter pub get


Configure Firebase:

Add your google-services.json (Android) & GoogleService-Info.plist (iOS)

Enable Firebase Authentication (Email/Password)

Setup Firebase Realtime Database (rules for testing: allow read, write: true)

Run the app:

flutter run
