# Personal Expense Tracker - Documentation

Welcome to the comprehensive documentation for the Personal Expense Tracker Flutter application. This documentation covers everything from architecture decisions to usage guides and deployment procedures.

## 📚 Documentation Index

### 🏗️ Architecture & Design
- [Architecture Overview](./architecture/README.md) - High-level architecture and design decisions
- [Design System](./design/README.md) - Design tokens, themes, and UI components
- [Database Schema](./database/README.md) - Database models and relationships

### 🛠️ Development
- [Tech Stack](./tech-stack/README.md) - Frameworks, libraries, and tools used
- [Code Structure](./code-structure/README.md) - File organization and naming conventions
- [State Management](./state-management/README.md) - Riverpod implementation and patterns

### 📱 Features & Usage
- [User Guide](./user-guide/README.md) - How to use the application
- [Feature Documentation](./features/README.md) - Detailed feature explanations
- [API Reference](./api/README.md) - Function documentation and usage

### 🧪 Testing
- [Testing Guide](./testing/README.md) - How to run tests and write new ones
- [Test Coverage](./testing/coverage.md) - Current test coverage and areas for improvement

### 🚀 Deployment & CI/CD
- [CI/CD Pipeline](./ci-cd/README.md) - GitHub Actions workflow explanation
- [Build Process](./ci-cd/build.md) - How to build for different platforms
- [Deployment Guide](./ci-cd/deployment.md) - Production deployment procedures

### 🔧 Configuration
- [Environment Setup](./setup/README.md) - Development environment configuration
- [Dependencies](./setup/dependencies.md) - Package dependencies and versions
- [Configuration Files](./setup/config.md) - App configuration and settings

## 🚀 Quick Start

1. **Setup Development Environment**
   ```bash
   # Clone the repository
   git clone <repository-url>
   cd personal_expense_tracker
   
   # Install dependencies
   flutter pub get
   
   # Generate code
   flutter packages pub run build_runner build
   
   # Run the app
   flutter run
   ```

2. **Run Tests**
   ```bash
   # Run all tests
   flutter test
   
   # Run with coverage
   flutter test --coverage
   ```

3. **Build for Production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS (requires macOS)
   flutter build ios --release
   ```

## 📋 Prerequisites

- Flutter SDK 3.24.5 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code
- Git

## 🤝 Contributing

Please read our [Contributing Guidelines](./contributing/README.md) before submitting pull requests.

## 📄 License

This project is licensed under the MIT License. See [LICENSE](../LICENSE) for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the [FAQ](./faq/README.md)
2. Search existing [Issues](https://github.com/your-repo/issues)
3. Create a new issue with detailed information

## 📈 Project Status

- **Current Version**: 1.0.0
- **Flutter Version**: 3.24.5
- **Dart Version**: 3.8.1
- **Last Updated**: January 2024

---

**Note**: This documentation is continuously updated. For the latest version, always check the main branch.
