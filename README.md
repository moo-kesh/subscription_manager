# Subscription Manager

A comprehensive Flutter application for managing and tracking personal subscriptions. Built with clean architecture principles and modern Flutter development practices.

## 📱 Features

- **Subscription Tracking**: Add, view, and manage your subscriptions
- **Dashboard Overview**: Get insights into your spending patterns
- **Multiple Platforms**: iOS, Android, macOS, Linux, Windows, and Web support
- **Modern UI**: Beautiful, responsive interface with smooth animations
- **Offline Support**: Local data persistence with Hive database
- **Dark/Light Theme**: Adaptive theming support

## 🏗️ Architecture

This project follows **Clean Architecture** principles with the following layer structure:

```
lib/
├── core/                    # Shared utilities and configurations
│   ├── animations/         # Animation utilities
│   ├── theme/             # App theming
│   ├── utils/             # Utility functions
│   └── widgets/           # Reusable widgets
├── features/              # Feature modules
│   ├── subscriptions/     # Subscription management
│   │   ├── domain/        # Business logic & entities
│   │   ├── data/          # Data sources & repositories
│   │   └── presentation/  # UI & state management
│   ├── dashboard/         # Analytics dashboard
│   ├── home/             # Home screen
│   └── welcome/          # Onboarding
└── main.dart             # App entry point
```

### Architecture Layers

- **Domain Layer**: Contains business entities, repository interfaces, and use cases
- **Data Layer**: Implements repositories, data sources, and models
- **Presentation Layer**: BLoC state management, UI screens, and widgets

### State Management

The app uses **BLoC (Business Logic Component)** pattern for state management:
- Clean separation of concerns
- Reactive programming with streams
- Testable business logic

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd subscription_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-specific Setup

#### Android
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 34

#### iOS
- Minimum iOS version: 12.0
- Xcode 12.0 or later

#### Desktop (macOS/Linux/Windows)
- Flutter desktop support enabled
- Platform-specific dependencies installed

## 📦 Dependencies

### Core Dependencies
- **flutter_bloc**: State management
- **hive**: Local database
- **hive_flutter**: Flutter integration for Hive
- **path_provider**: File system access

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: Linting rules
- **build_runner**: Code generation
- **hive_generator**: Hive type adapters

## 🗂️ Project Structure

```
subscription_manager/
├── android/               # Android platform files
├── ios/                  # iOS platform files
├── linux/                # Linux platform files
├── macos/                # macOS platform files
├── web/                  # Web platform files
├── windows/              # Windows platform files
├── assets/               # Static assets
│   └── icons/           # Subscription service icons
├── lib/                  # Flutter source code
├── test/                 # Unit and widget tests
├── pubspec.yaml         # Project configuration
└── README.md           # This file
```

## 🧪 Testing

Run tests using:

```bash
# All tests
flutter test

# Specific test file
flutter test test/features/subscriptions/domain/entities/subscription_entity_test.dart

# With coverage
flutter test --coverage
```

## 🔧 Development

### Code Generation

For Hive type adapters:
```bash
flutter packages pub run build_runner build
```

### Linting

The project uses Flutter recommended lints:
```bash
flutter analyze
```

## 📁 Key Files

- `lib/main.dart`: Application entry point and dependency setup
- `lib/features/subscriptions/`: Core subscription management feature
- `pubspec.yaml`: Project dependencies and configuration
- `analysis_options.yaml`: Linting and analysis rules

## 🎯 Clean Architecture Compliance

**Current Score: 6/10**

### ✅ Strengths
- Clear layer separation (domain, data, presentation)
- Repository pattern implementation
- BLoC pattern for state management
- Proper dependency direction

### ⚠️ Areas for Improvement
1. **Domain Contamination**: Remove Hive annotations from domain entities
2. **Missing Use Cases**: Implement use case layer for business operations
3. **Dependency Injection**: Add proper DI container
4. **Business Logic**: Move business logic from BLoC to use cases

### 🔄 Planned Improvements
- [ ] Create separate data models with mappers
- [ ] Implement use cases for all business operations
- [ ] Add dependency injection container (GetIt)
- [ ] Extract business logic from presentation layer
- [ ] Add comprehensive error handling
- [ ] Implement proper testing structure

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the Flutter documentation: [docs.flutter.dev](https://docs.flutter.dev/)

## 🚧 Development Status

This project is actively under development. Current focus areas:
- Improving clean architecture compliance
- Adding comprehensive testing
- Implementing additional subscription features
- Performance optimizations
