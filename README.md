# Todo Mobile App

A Flutter todo app with Firebase authentication and Firestore database integration.

## Features

- Google Sign-In Authentication
- Real-time database with Firestore
- Task management with progress tracking
- Three categories for tasks: Pending, In Progress, and Completed
- Edit and delete tasks

## Firebase Setup Instructions

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and follow the setup instructions
3. Once created, click on the project to enter its dashboard

### 2. Register Your Flutter App with Firebase

#### For Android:

1. In the Firebase console, click "Add app" and select Android
2. Enter your app's package name (found in android/app/build.gradle)
3. Download the google-services.json file and place it in the android/app directory
4. Follow the setup instructions provided by Firebase

#### For iOS:

1. In the Firebase console, click "Add app" and select iOS
2. Enter your app's bundle ID (found in ios/Runner.xcodeproj/project.pbxproj)
3. Download the GoogleService-Info.plist file and add it to your iOS app using Xcode
4. Follow the setup instructions provided by Firebase

### 3. Enable Google Authentication

1. In the Firebase console, go to "Authentication"
2. Click on "Sign-in method"
3. Enable "Google" as a sign-in provider
4. Configure any additional settings for Google sign-in

### 4. Set Up Firestore Database

1. In the Firebase console, go to "Firestore Database"
2. Click "Create database"
3. Choose either production or test mode
4. Set up Firestore security rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /todos/{todoId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 5. Update Firebase Configuration

1. Run `flutterfire configure` to generate the firebase_options.dart file
2. This will replace the placeholder file in lib/firebase_options.dart

## Development Setup

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Set up Firebase as outlined above
4. Run the app with `flutter run`

## Dependencies

- firebase_core
- firebase_auth
- google_sign_in
- cloud_firestore
- provider
- intl
