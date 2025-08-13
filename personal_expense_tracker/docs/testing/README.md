# Testing Guide - Personal Expense Tracker

This document provides comprehensive information about testing in the Personal Expense Tracker application, including how to run tests, write new tests, and understand the testing strategy.

## 🧪 Testing Strategy

### Testing Pyramid
Our testing strategy follows the testing pyramid approach:

```
    /\
   /  \     E2E Tests (Few)
  /____\    
 /      \   Integration Tests (Some)
/________\  Unit Tests (Many)
```

### Test Types

#### 1. Unit Tests
- **Purpose**: Test individual functions and classes in isolation
- **Location**: `test/` directory
- **Coverage**: Business logic, utilities, repositories
- **Speed**: Fast execution
- **Dependencies**: Mocked external dependencies

#### 2. Widget Tests
- **Purpose**: Test UI components in isolation
- **Location**: `test/` directory
- **Coverage**: Widget behavior, user interactions
- **Speed**: Medium execution
- **Dependencies**: Minimal mocking

#### 3. Golden Tests
- **Purpose**: Visual regression testing
- **Location**: `test/golden/` directory
- **Coverage**: UI consistency across themes and states
- **Speed**: Medium execution
- **Dependencies**: Screenshot comparison

#### 4. Integration Tests
- **Purpose**: Test feature workflows end-to-end
- **Location**: `integration_test/` directory
- **Coverage**: Complete user journeys
- **Speed**: Slow execution
- **Dependencies**: Full app environment

## 🚀 Running Tests

### Prerequisites
Before running tests, ensure you have:
- Flutter SDK installed and configured
- All dependencies installed (`flutter pub get`)
- Generated code (`flutter packages pub run build_runner build`)

### Basic Test Commands

#### Run All Tests
```bash
flutter test
```

#### Run Tests with Coverage
```bash
flutter test --coverage
```

#### Run Tests with Verbose Output
```bash
flutter test --verbose
```

#### Run Specific Test File
```bash
flutter test test/formatters_test.dart
```

#### Run Tests in a Directory
```bash
flutter test test/golden/
```

#### Run Tests with Custom Reporter
```bash
flutter test --reporter=expanded
```

### Golden Tests

#### Generate Golden Files
```bash
flutter test --update-goldens
```

#### Run Only Golden Tests
```bash
flutter test test/golden/
```

#### Update Specific Golden Test
```bash
flutter test test/golden/home_screen_golden_test.dart --update-goldens
```

### Coverage Reports

#### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

#### View Coverage Report
```bash
open coverage/html/index.html
```

#### Coverage Threshold
We aim for:
- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Integration Tests**: 60%+ coverage

## 📝 Writing Tests

### Unit Test Structure

#### Basic Unit Test
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/core/formatters.dart';

void main() {
  group('Formatters', () {
    group('formatCurrency', () {
      test('formats positive amount correctly', () {
        expect(Formatters.formatCurrency(1234.56), '₹1,234.56');
      });

      test('formats zero correctly', () {
        expect(Formatters.formatCurrency(0), '₹0.00');
      });

      test('formats negative amount correctly', () {
        expect(Formatters.formatCurrency(-1234.56), '₹-1,234.56');
      });
    });
  });
}
```

#### Repository Test with Riverpod
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:personal_expense_tracker/features/transactions/data/repositories/transaction_repository.dart';

void main() {
  group('TransactionRepository', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize repository', () async {
      final repository = container.read(transactionRepositoryProvider);
      expect(repository, isA<TransactionRepository>());
    });

    test('should add transaction', () async {
      final repository = container.read(transactionRepositoryProvider.notifier);
      final transaction = Transaction(
        type: TransactionType.expense,
        amount: 100.0,
        category: 'Food',
        date: DateTime.now(),
      );

      await repository.addTransaction(transaction);
      // Add assertions to verify transaction was added
    });
  });
}
```

### Widget Test Structure

#### Basic Widget Test
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:personal_expense_tracker/features/home/presentation/screens/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('displays app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );

      expect(find.text('Personal Finance'), findsOneWidget);
    });

    testWidgets('shows loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

#### Widget Test with User Interaction
```dart
testWidgets('can add new transaction', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: const AddTransactionScreen(),
      ),
    ),
  );

  // Enter amount
  await tester.enterText(find.byType(TextFormField).first, '100');
  
  // Select category
  await tester.tap(find.text('Select category'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Food & Dining'));
  await tester.pumpAndSettle();

  // Tap save button
  await tester.tap(find.text('Add Expense'));
  await tester.pumpAndSettle();

  // Verify success message
  expect(find.text('Transaction saved'), findsOneWidget);
});
```

### Golden Test Structure

#### Basic Golden Test
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:personal_expense_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:personal_expense_tracker/design/app_theme.dart';

void main() {
  group('HomeScreen Golden Tests', () {
    testWidgets('Home screen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('home_screen.png'),
      );
    });

    testWidgets('Home screen with dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('home_screen_dark.png'),
      );
    });
  });
}
```

## 🔧 Test Utilities and Helpers

### Test Data Builders

#### Transaction Test Data
```dart
class TransactionTestData {
  static Transaction createTransaction({
    String? id,
    TransactionType type = TransactionType.expense,
    double amount = 100.0,
    String category = 'Food',
    String? merchant,
    DateTime? date,
    String? note,
  }) {
    return Transaction(
      id: id,
      type: type,
      amount: amount,
      category: category,
      merchant: merchant,
      date: date ?? DateTime.now(),
      note: note,
    );
  }

  static List<Transaction> createTransactionList() {
    return [
      createTransaction(
        id: '1',
        type: TransactionType.income,
        amount: 50000.0,
        category: 'Salary',
        merchant: 'Company Inc.',
      ),
      createTransaction(
        id: '2',
        type: TransactionType.expense,
        amount: 1200.0,
        category: 'Food & Dining',
        merchant: 'Grocery Store',
      ),
    ];
  }
}
```

#### Asset Test Data
```dart
class AssetTestData {
  static Asset createAsset({
    String? id,
    String name = 'Test Asset',
    double amount = 1000.0,
    AssetType type = AssetType.savings,
    bool isRecurring = false,
    String? description,
  }) {
    return Asset(
      id: id,
      name: name,
      amount: amount,
      type: type,
      isRecurring: isRecurring,
      description: description,
    );
  }
}
```

### Mock Providers

#### Mock Repository Provider
```dart
final mockTransactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return MockTransactionRepository();
});

class MockTransactionRepository extends Mock implements TransactionRepository {
  @override
  Stream<List<Transaction>> watchAllTransactions() {
    return Stream.value(TransactionTestData.createTransactionList());
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    // Mock implementation
  }
}
```

### Test Helpers

#### Widget Test Helper
```dart
class TestHelper {
  static Future<void> pumpApp(
    WidgetTester tester,
    Widget widget, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: theme ?? AppTheme.lightTheme,
          home: widget,
        ),
      ),
    );
  }

  static Future<void> pumpAndSettleApp(
    WidgetTester tester,
    Widget widget, {
    ThemeData? theme,
  }) async {
    await pumpApp(tester, widget, theme: theme);
    await tester.pumpAndSettle();
  }
}
```

## 📊 Test Coverage

### Current Coverage

| Component | Coverage | Status |
|-----------|----------|--------|
| Formatters | 95% | ✅ Excellent |
| Repositories | 85% | ✅ Good |
| Widgets | 75% | ✅ Good |
| Screens | 70% | ⚠️ Needs Improvement |
| Models | 90% | ✅ Excellent |

### Coverage Goals

- **Core Utilities**: 95%+ (Formatters, validators, etc.)
- **Business Logic**: 90%+ (Repositories, services)
- **UI Components**: 80%+ (Widgets, screens)
- **Models**: 95%+ (Domain models, DTOs)

### Coverage Exclusions

Some code is intentionally excluded from coverage:
- **Generated Code**: Freezed, JSON serialization
- **Platform Code**: Platform-specific implementations
- **Error Boundaries**: Exception handling code
- **Debug Code**: Development-only code

## 🐛 Debugging Tests

### Common Test Issues

#### 1. Flaky Tests
**Problem**: Tests that pass sometimes and fail other times
**Solutions**:
- Use `tester.pumpAndSettle()` for async operations
- Add proper waits for animations
- Mock time-dependent operations

#### 2. Widget Not Found
**Problem**: `find.byType()` or `find.text()` returns nothing
**Solutions**:
- Check if widget is actually rendered
- Use `tester.pump()` to trigger rebuilds
- Verify widget tree structure

#### 3. Provider Not Found
**Problem**: Riverpod provider not available in test
**Solutions**:
- Wrap widget in `ProviderScope`
- Override providers with test implementations
- Use `ProviderContainer` for manual testing

#### 4. Golden Test Failures
**Problem**: Golden tests fail due to minor visual changes
**Solutions**:
- Update golden files: `flutter test --update-goldens`
- Check for theme or locale differences
- Verify device pixel ratio settings

### Debug Commands

#### Debug Specific Test
```bash
flutter test test/formatters_test.dart --verbose
```

#### Debug with Breakpoints
```bash
flutter test --start-paused
```

#### Debug Widget Tests
```bash
flutter test --enable-software-rendering
```

## 🔄 Continuous Integration

### GitHub Actions Test Workflow

The CI pipeline automatically runs tests on every commit:

```yaml
- name: Run tests
  run: flutter test

- name: Run tests with coverage
  run: flutter test --coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    file: coverage/lcov.info
```

### Pre-commit Hooks

Install pre-commit hooks to run tests before commits:

```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Run manually
pre-commit run --all-files
```

### Test Environment

#### Local Development
- **Flutter Version**: 3.24.5
- **Dart Version**: 3.8.1
- **Platform**: macOS/Linux/Windows

#### CI Environment
- **Runner**: Ubuntu 22.04
- **Flutter**: 3.24.5
- **Dependencies**: Cached for faster builds

## 📋 Test Checklist

### Before Writing Tests
- [ ] Understand the component being tested
- [ ] Identify test scenarios and edge cases
- [ ] Plan test data and mocks
- [ ] Consider performance implications

### While Writing Tests
- [ ] Follow naming conventions
- [ ] Use descriptive test names
- [ ] Test both success and failure cases
- [ ] Mock external dependencies
- [ ] Keep tests independent

### After Writing Tests
- [ ] Run tests locally
- [ ] Check test coverage
- [ ] Update documentation if needed
- [ ] Create golden files if applicable
- [ ] Review test quality

### Test Quality Checklist
- [ ] Tests are readable and maintainable
- [ ] Tests cover all important scenarios
- [ ] Tests are fast and reliable
- [ ] Tests don't have side effects
- [ ] Tests provide clear error messages

## 🎯 Best Practices

### Test Organization
1. **Group Related Tests**: Use `group()` to organize related tests
2. **Descriptive Names**: Use clear, descriptive test names
3. **Arrange-Act-Assert**: Follow AAA pattern in test structure
4. **One Assertion Per Test**: Keep tests focused and simple

### Test Data Management
1. **Use Factories**: Create test data factories for consistency
2. **Minimal Test Data**: Use only necessary data for each test
3. **Realistic Data**: Use realistic test data that matches production
4. **Clean Up**: Properly clean up test data after tests

### Performance Considerations
1. **Fast Execution**: Keep tests fast for quick feedback
2. **Efficient Mocks**: Use efficient mocking strategies
3. **Parallel Execution**: Design tests to run in parallel
4. **Resource Management**: Properly dispose of resources

### Maintenance
1. **Regular Updates**: Keep tests updated with code changes
2. **Refactoring**: Refactor tests when code changes
3. **Documentation**: Document complex test scenarios
4. **Review Process**: Include tests in code review process

## 📚 Additional Resources

### Flutter Testing Documentation
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Testing Tools
- [Mockito](https://pub.dev/packages/mockito) - Mocking framework
- [Test Coverage](https://pub.dev/packages/test_coverage) - Coverage reporting
- [Golden Toolkit](https://pub.dev/packages/golden_toolkit) - Golden test utilities

### Testing Patterns
- [Testing Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)
- [AAA Pattern](https://medium.com/@pjbgf/title-testing-code-ocd-and-the-aaa-pattern-df453975ab80)
- [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)

---

This testing guide provides comprehensive information for maintaining and improving the test suite. For specific questions or issues, please refer to the troubleshooting section or create an issue on GitHub.
