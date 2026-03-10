#  Movie Browser

Built as part of a hiring process. The goal was to demonstrate
clean architecture and professional Flutter practices.

## Features
-  Search movies with pagination
-  Full movie details
- ️ Favorites (persisted locally)
-  Search history with delete support
-  Offline support with Hive cache
-  Accessibility – Semantics + large text scaling
-  Localization with `intl`

## Architecture
Feature-first Clean Architecture with BLoC state management.
```
lib/
├── core/               # Shared infrastructure
│   ├── api/            # Dio client
│   ├── storage/        # Hive setup
│   ├── errors/         # Failure classes
│   └── constants/      # API keys, box names
├── features/
│   ├── movies/         # Search + Results
│   │   ├── data/
│   │   ├── bloc/
│   │   └── presentation/
│   ├── details/        # Movie Details
│   │   ├── data/
│   │   ├── bloc/
│   │   └── presentation/
│   └── favorites/      # Favorites
│       ├── data/
│       ├── bloc/
│       └── presentation/
├── l10n/               # ARB localization files
└── main.dart
```

## Tech Stack
State management with flutter_bloc, local storage with Hive,
networking with Dio, and get_it for dependency injection.

## Getting Started

1. Create a `.env` file in the root directory:
```
OMDB_API_KEY=your_api_key_here
```
2. Run `flutter pub get`
3. Run `dart run build_runner build --delete-conflicting-outputs`
4. Run `flutter gen-l10n`
5. Run `flutter run`
