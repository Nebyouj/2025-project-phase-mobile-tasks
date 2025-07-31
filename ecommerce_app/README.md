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


## 🗂️ Project Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart          # NetworkInfo contract
│   └── usecase/
│       └── usecase.dart               # Base UseCase class
│
├── features/
│   └── product/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── product.dart        # Product entity
│       │   ├── repositories/
│       │   │   └── product_repository.dart  # Contract for repository
│       │   └── usecases/
│       │       ├── create_product.dart
│       │       ├── update_product.dart
│       │       ├── delete_product.dart
│       │       ├── view_product.dart
│       │       └── view_all_products.dart
│       │
│       ├── data/
│       │   ├── models/
│       │   │   └── product_model.dart  # Maps to entity + JSON conversion
│       │   ├── datasources/
│       │   │   ├── product_remote_data_source.dart # Contract
│       │   │   ├── product_local_data_source.dart  # Contract
│       │   └── repositories/
│       │       └── product_repository_impl.dart        # Implementation
│       │
│       ├── presentation/
│             └── screens/
│             |     ├── home_page.dart
│             |     ├── details_page.dart
│             |     ├── add_update_page.dart
│             |     └── search_page.dart
│             └── widgets/
│                   └── product_card.dart
│
└── main.dart

## 🚀 How to Run

Make sure you have **Flutter** installed on your system.

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/shoe-store-flutter.git
cd shoe-store-flutter
```

### 2. Run the App

```bash
flutter pub get
flutter run
```

