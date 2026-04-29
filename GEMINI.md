# FinSage Project Analysis

## Project Overview

FinSage is a premium, cross-platform personal finance management application built with Flutter. It is designed to be modular, secure, and user-friendly.

- **Project Name:** fin_sage
- **Description:** A premium personal finance app with smart insights and secure cloud backup.
- **Technologies:**
    - **Framework:** Flutter (v3.19+)
    - **State Management:** Bloc/Cubit (`flutter_bloc`)
    - **Database:** SQLite with Drift (`sqflite`, `sqflite_sqlcipher`, `drift`) for local, encrypted storage.
    - **Cloud Backup:** Google Drive integration using `google_sign_in` and `googleapis`.
    - **UI Components:** Utilizes `fl_chart` for charts, `flutter_svg` for vector graphics, and `lottie` for animations.
    - **Localization:** Supports English (`en`) and Indonesian (`id`) using the `intl` package and `.arb` files.
- **Architecture:** The project follows a modular architecture, separating code into four main directories:
    - `lib/core`: Contains shared constants, error handling, utilities, and reusable widgets.
    - `lib/data`: Manages data sources, repositories, and data models.
    - `lib/features`: Implements specific application features like authentication, dashboard, transactions, etc.
    - `lib/logic`: Holds the business logic using Cubits for state management for each feature.

## Building and Running

The project includes a CI workflow that defines the steps for building and testing the application.

### Key Commands

- **Install Dependencies:**
  ```bash
  flutter pub get
  ```

- **Format Code:** To check if the code is correctly formatted.
  ```bash
  dart format --output=none --set-exit-if-changed .
  ```

- **Static Analysis:** To analyze the code for potential errors.
  ```bash
  flutter analyze --no-fatal-infos
  ```

- **Run Tests:**
    - **Unit/Widget Tests:**
      ```bash
      flutter test
      ```
    - **Integration Tests:**
      ```bash
      flutter test integration_test -d linux
      ```

- **Run Application:**
  ```bash
  flutter run
  ```
  You may need to provide `--dart-define` flags for Google OAuth credentials as specified in the `README.md`.

## Development Conventions

- **State Management:** The project uses the Cubit pattern from the `flutter_bloc` package. Each feature has its own Cubit to manage its state.
- **Dependency Injection:** `get_it` is used for service locator-based dependency injection.
- **Immutability:** Models and states often use `equatable` to simplify value comparisons.
- **Testing:**
    - Unit and widget tests are located in the `test/` directory.
    - Integration tests are in the `integration_test/` directory.
    - `mocktail` is the preferred library for creating mocks.
- **CI/CD:** GitHub Actions are configured in `.github/workflows/`.
    - `testing.yml`: Runs on every push to the `main` branch to perform code formatting checks, static analysis, and run all tests.
    - `release.yml`: Is set up for creating tagged releases.
- **Localization:** All user-facing strings should be localized. Add new strings to `lib/l10n/app_en.arb` and `lib/l10n/app_id.arb` and run `flutter gen-l10n` to generate the necessary files.
