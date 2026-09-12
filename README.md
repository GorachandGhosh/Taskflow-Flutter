# TaskFlow — Modern Task Management for Gig Workers

TaskFlow is a production-quality, high-polish task management mobile application built for gig workers, designed following strict **Clean Architecture** and reactive **BLoC** state management.

Inspired by modern purple/indigo productivity interfaces, it delivers a clutter-free experience with real-time Firebase Authentication, Cloud Firestore synchronization, and intuitive filtering, sorting, and search capabilities.

---

## Architecture

TaskFlow adheres strictly to Uncle Bob's **Clean Architecture**, enforcing unidirectional dependency flow and separation of concerns:

```
Presentation (Pages, Widgets, BLoCs)
     │
     ▼
Domain (Entities, Use Cases, Repository Contracts)
     ▲
     │
Data (Models, Remote/Local Data Sources, Repository Implementations)
```

- **Zero UI-to-Firebase coupling**: Widgets dispatch events to `AuthBloc` and `TaskBloc` and render based on immutable states.
- **Zero BLoC-to-Firestore coupling**: BLoCs invoke atomic Use Cases (`CreateTask`, `GetTasks`, `UpdateTask`, `DeleteTask`, `ToggleTask`, `LoginUser`, etc.).
- **Data Isolation**: Firestore documents are scoped strictly to `users/{userId}/tasks/{taskId}`.

---

## Features

- **Authentication**:
  - Email & password registration with validation (email format, 6+ character passwords, confirmation match).
  - Email & password login with graceful, human-readable Firebase error translations.
  - Password Reset flow via Firebase Auth email dispatch.
  - Persistent authentication state via Firebase Auth stream.
  - Seamless logout flow with immediate state reset and confirmation dialog.
- **Task Management**:
  - Full CRUD: Create, View, Edit, Delete (with confirmation dialog), and Toggle Completion.
  - Offline-first local caching using `TaskLocalDataSource` via `SharedPreferences`.
  - Attributes: `id`, `title`, `description`, `dueDate`, `priority` (Low, Medium, High), `isCompleted`, `createdAt`, `updatedAt`.
  - Visual feedback: Completed tasks display strikethrough styling and muted contrast without vanishing from view.
- **Gig Worker Productivity & Profile Dashboard**:
  - Worker stats overview: Total tasks, Completed tasks, Incomplete tasks, and Urgent High-Priority counter.
  - Visual completion percentage indicator and progress bar.
  - Account actions: Reset password and Logout.
- **Search, Filter & Sort**:
  - Combined filtering: Filter by priority (`All`, `Low`, `Medium`, `High`) and completion status (`All`, `Completed`, `Incomplete`).
  - Real-time case-insensitive search matching task title or description.
  - Automatic ascending sorting by due date (earliest due date first, secondary sort by creation date).
  - Date-grouped task cards (`TODAY`, `TOMORROW`, `THIS WEEK`, `UPCOMING`, `OVERDUE`).
- **Unit Testing**:
  - Domain entity, model, date formatter, and input validator unit tests (`test/taskflow_unit_test.dart`).
  - BLoC state transition tests using `bloc_test` and `mocktail` (`test/auth_bloc_test.dart`, `test/task_bloc_test.dart`).
- **Onboarding & Splash**:
  - Minimal animated splash screen.
  - Clean onboarding with hero icon, headline, description, and persistence via `SharedPreferences`.

---

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: `flutter_bloc` / BLoC
- **Backend & Auth**: Firebase Authentication & Cloud Firestore
- **Local Persistence**: `shared_preferences`
- **Utilities & Formatting**: `intl`, `equatable`
- **Design System**: Material 3

---

## Firestore Database Structure

```
users/
  └── {userId}/
        └── tasks/
              └── {taskId}/
                    ├── title: String
                    ├── description: String
                    ├── dueDate: Timestamp
                    ├── priority: String ("Low" | "Medium" | "High")
                    ├── isCompleted: Boolean
                    ├── createdAt: Timestamp
                    └── updatedAt: Timestamp
```

---

## Firestore Security Rules

Deploy these rules to Firebase Console under **Firestore Database > Rules**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## Firebase Setup Instructions

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. In **Authentication > Sign-in method**, enable **Email/Password**.
3. In **Firestore Database**, create a database in production mode and deploy the security rules above.
4. Run the FlutterFire CLI from your terminal:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
5. Follow the interactive prompts to register your Android and iOS apps.

---

## Running the Project

```bash
# Get dependencies
flutter pub get

# Run unit tests
flutter test

# Run the app in debug mode
flutter run

# Build release APK
flutter build apk --release
```
