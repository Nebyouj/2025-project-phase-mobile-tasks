# ecommerce_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🏗️ Clean Architecture

This project follows the **Clean Architecture** pattern:

- **core/** → Shared utilities and error handling
- **features/product/**
  - **data/** → Models, repositories, and datasources
  - **domain/** → Entities, abstract repositories, and use cases
  - **presentation/** → UI (screens and widgets)

### Data Flow

1. **Presentation Layer** → Handles UI and sends events to Bloc/Provider.
2. **Domain Layer** → Contains business logic via UseCases and Entities.
3. **Data Layer** → Fetches data from local or remote sources and maps it to entities.

