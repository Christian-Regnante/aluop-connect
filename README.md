# AluOp-Connect

AluOp-Connect is a modern, feature-rich mobile application built with Flutter that bridges the gap between **African Leadership University (ALU) students** and **employers/startups**. It offers students a structured way to find, apply for, and track opportunities (internships, missions, projects) while enabling employers to seamlessly post roles, manage applicants, and evaluate talent.

---

## 🚀 Features

### 👤 Student Hub
* **Explore Opportunities**: Search, filter, and discover open missions and projects tailored to your interests and skills.
* **Smart Recommendations**: A personalized feed highlighting top matched positions.
* **Easy Application**: Submit applications directly from the app.
* **Application Tracker**: Track the real-time status of all your applications (Submitted, Under Review, Shortlisted, etc.).
* **Profile Setup**: Build your professional profile detailing your skills, experiences, and background.

### 💼 Employer Hub
* **Opportunity Posting**: Create and publish new opportunities with detailed specifications (roles, requirements, tags, deadlines).
* **Applicant Review Hub**: Track all applicants per role in one dashboard.
* **Talent Evaluation**: Grade and evaluate students during or after completing their missions.
* **Company Profile**: Customize your company's information and branding.

### 🔐 Authentication & Core
* **Tab-Switch Sign-In/Sign-Up**: Clean, visual authentication interface for both students and employers.
* **Role-Based Routing**: Secure page redirection depending on whether the signed-in user is a student or an employer.

---

## 🛠️ Tech Stack & Architecture

* **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.11.5`)
* **State Management**: [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) (v3)
* **Routing**: [GoRouter](https://pub.dev/packages/go_router)
* **Database & Auth**: [Firebase](https://firebase.google.com/) (Auth, Firestore, Google Sign-In)
* **Models & Serialization**: [Freezed](https://pub.dev/packages/freezed) & [JSON Serializable](https://pub.dev/packages/json_serializable)

### Architecture
The project follows a **Feature-First Clean Architecture** pattern. Code is modularized into feature directories (`auth`, `student_home`, `employer_home`), each containing:
* **Presentation**: Screens, layouts, and reusable UI widgets.
* **Providers**: Riverpod state management.
* **Services**: Local database or Firebase operations specific to the feature.

See the detailed tree and layout in [PROJECT_STRUCTURE.md](file:///G:/flutterProjects/aluop_connect/aluop_connect/PROJECT_STRUCTURE.md).

---

## 🏁 Getting Started

### 📋 Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
* [Dart SDK](https://dart.dev/get-started) configured.
* A Firebase Project configured with your Android/iOS configurations (uses `firebase_options.dart`).

### ⚙️ Setup & Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd aluop_connect
   ```

2. **Fetch Dart packages**:
   ```bash
   flutter pub get
   ```

3. **Generate serialization and immutable code**:
   This project uses `freezed` and `json_serializable` for model code generation. Run the build runner to compile the generated files:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   *(Or run `flutter pub run build_runner watch` during active development to auto-rebuild on save)*

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## 📂 Key Directory Outline

* `lib/main.dart` - Entrypoint of the app initializing Firebase configurations and the Riverpod `ProviderScope`.
* `lib/core/` - Reusable styling tokens, global theme, data models, router configurations, and global firebase services.
* `lib/features/` - Modules categorized by functional domain containing screen layouts and providers.

---

## Startup Verification Code

ALU-9283-2833
