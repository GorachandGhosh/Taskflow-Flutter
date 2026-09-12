# TaskFlow — Task Management App

TaskFlow is a Flutter-based task management application designed for gig workers to create, organize, track, and manage their daily tasks efficiently.

The application provides secure email/password authentication, cloud-based task management using Firebase, local task caching, priority and status filtering, search, due-date sorting, and a clean Material 3 user interface.

The project follows a **Clean Architecture-inspired structure** with **BLoC** for state management to keep the presentation, business logic, and data layers separated.

---

## ✨ Features

### 🔐 Authentication

- Email and password registration
- Email and password login
- Input validation
- Password confirmation during registration
- Firebase Authentication
- Human-readable authentication error messages
- Forgot password / password reset
- Persistent authentication state
- Logout functionality
- Logout confirmation dialog

---

### 📋 Task Management

- Create new tasks
- View existing tasks
- Edit tasks
- Delete tasks
- Mark tasks as completed/incomplete
- Task title
- Task description
- Due date
- Task priority:
  - Low
  - Medium
  - High
- Created timestamp
- Updated timestamp
- Completed tasks remain visible with visual completion styling

---

### 🔎 Search, Filter & Sort

- Search tasks by title or description
- Case-insensitive search
- Filter by priority:
  - All
  - Low
  - Medium
  - High
- Filter by task status:
  - All
  - Completed
  - Incomplete
- Sort tasks by due date
- Earliest due date appears first
- Secondary sorting using task creation date
- Date-based task grouping:
  - TODAY
  - TOMORROW
  - THIS WEEK
  - UPCOMING
  - OVERDUE

---

### 📊 Dashboard & Profile

The application provides an overview of the user's task activity.

- Total tasks
- Completed tasks
- Incomplete tasks
- High-priority task overview
- Completion percentage
- Progress indicator
- Password reset
- Logout

---

### 💾 Local & Cloud Storage

TaskFlow uses both cloud and local data storage.

**Cloud Storage**
- Cloud Firestore is used to store and synchronize tasks.

**Local Storage**
- SharedPreferences is used for local task caching and application preferences.

This allows the application to maintain useful local data while using Firebase as the primary cloud backend.

---

### 🎨 UI & UX

- Material 3 design
- Clean and modern interface
- Responsive layouts
- Custom application theme
- Reusable widgets
- Loading states
- Error states
- Empty task states
- Confirmation dialogs
- Custom TaskFlow application icon
- Smooth onboarding and splash experience

---

### 🚀 Onboarding & Splash

- Animated splash screen
- Onboarding screen for first-time users
- Application branding and introduction
- Onboarding state stored using SharedPreferences

---

## 🏗️ Architecture

TaskFlow follows a **Clean Architecture-inspired project structure** combined with the **BLoC pattern** for state management.

### Architecture Flow

```text
┌───────────────────────────────┐
│        Presentation           │
│  Pages • Widgets • BLoCs      │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│           Domain              │
│ Entities • Use Cases          │
│ Repository Contracts          │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│             Data              │
│ Models • Repositories         │
│ Remote / Local Data Sources   │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│     Firebase / Local Storage  │
└───────────────────────────────┘


---

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** BLoC (`flutter_bloc`)
- **Authentication:** Firebase Authentication
- **Database:** Cloud Firestore
- **Local Storage:** SharedPreferences
- **Date Formatting:** Intl
- **Equality & State Comparison:** Equatable
- **Design:** Material 3

---

## 📁 Project Structure

```text
lib/
├── app/
│   └── app.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/
│   │   └── presentation/
│   │
│   └── tasks/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── firebase_options.dart
└── main.dart
