# AluOp-Connect Project Directory Structure (`lib/`)

Below is the directory tree of the `lib` folder of the **AluOp-Connect** mobile application, showing the Clean Architecture and Feature-First design pattern.

```
lib/
├── firebase_options.dart      # Auto-generated Firebase configurations
├── main.dart                  # App entry point initializing Firebase and Riverpod
├── core/                      # Core module shared across all features
│   ├── models/                # Immutable data models (using Freezed & JSON serialization)
│   │   ├── application_model.dart
│   │   ├── employer_profile_model.dart
│   │   ├── opportunity_model.dart
│   │   ├── student_profile_model.dart
│   │   └── user_model.dart
│   ├── routing/               # Navigation using GoRouter
│   │   └── app_router.dart
│   ├── services/              # Core Firebase database operations (Firestore services)
│   │   ├── application_service.dart
│   │   ├── bookmark_service.dart
│   │   ├── employer_service.dart
│   │   ├── opportunity_service.dart
│   │   └── student_service.dart
│   └── theme/                 # Global styling (design tokens, colors, custom text theme)
│       ├── app_colors.dart
│       └── app_theme.dart
└── features/                  # Feature modules
    ├── auth/                  # Authentication & Verification Feature
    │   ├── presentation/
    │   │   ├── screens/
    │   │   │   ├── sign_in_screen.dart
    │   │   │   └── sign_up_screen.dart
    │   │   └── widgets/
    │   │       ├── auth_tab_switch.dart
    │   │       ├── custom_text_field.dart
    │   │       ├── primary_button.dart
    │   │       └── social_sign_in_button.dart
    │   ├── providers/
    │   │   └── auth_providers.dart
    │   └── services/
    │       └── auth_service.dart
    ├── employer_home/         # Employer/Startup Dashboard, Posting & Review Features
    │   └── presentation/
    │       ├── screens/
    │       │   ├── applicant_review_hub_screen.dart
    │       │   ├── employer_home_feed.dart
    │       │   ├── employer_main_scaffold.dart
    │       │   ├── employer_profile_screen.dart
    │       │   ├── employer_profile_setup_screen.dart
    │       │   ├── post_engine_screen.dart
    │       │   ├── post_success_screen.dart
    │       │   └── student_evaluation_screen.dart
    │       └── widgets/
    │           ├── active_role_item.dart
    │           ├── employer_home_header.dart
    │           ├── hire_talent_card.dart
    │           ├── metric_card.dart
    │           └── smart_matching_card.dart
    └── student_home/          # Student Search, Explore, Applying & Tracking Features
        └── presentation/
            ├── screens/
            │   ├── applications_tracker_screen.dart
            │   ├── apply_submission_screen.dart
            │   ├── apply_success_screen.dart
            │   ├── employer_detail_profile_screen.dart
            │   ├── explore_screen.dart
            │   ├── opportunity_details_screen.dart
            │   ├── student_home_feed.dart
            │   ├── student_main_scaffold.dart
            │   ├── student_profile_screen.dart
            │   └── student_profile_setup_screen.dart
            └── widgets/
                ├── filter_chip_list.dart
                ├── home_header.dart
                ├── recommended_job_card.dart
                └── top_match_card.dart
```

> [!NOTE]
> Auto-generated code-generation output files (`*.freezed.dart`, `*.g.dart`) created by the build runner (`freezed` and `json_serializable` packages) are omitted from this visual tree structure for readability.
