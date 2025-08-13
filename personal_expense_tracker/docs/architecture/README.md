# Architecture Overview

This document provides a comprehensive overview of the Personal Expense Tracker application architecture, including design patterns, architectural decisions, and system organization.

## 🏗️ Architectural Pattern

The application follows a **Clean Architecture** pattern with **Feature-Based Module Organization**, combining the best practices from both approaches to create a scalable and maintainable codebase.

### Why Clean Architecture?

- **Separation of Concerns**: Clear boundaries between different layers
- **Testability**: Easy to unit test each layer independently
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new features without breaking existing code
- **Independence**: Business logic is independent of external frameworks

### Why Feature-Based Modules?

- **Cohesion**: Related code is grouped together
- **Parallel Development**: Multiple developers can work on different features
- **Clear Ownership**: Each feature has clear boundaries
- **Reduced Dependencies**: Features are loosely coupled
- **Easier Navigation**: Developers can quickly find related code

## 📁 Project Structure

```
lib/
├── core/                           # Shared utilities and services
│   ├── formatters.dart            # Currency and date formatting
│   ├── navigation/                # App routing configuration
│   │   └── app_router.dart        # Main router setup
│   ├── seed.dart                  # Initial data seeding
│   └── services/                  # Core services
│       └── database_service.dart  # Database initialization
├── design/                        # Design system
│   ├── app_card.dart             # Reusable card component
│   ├── app_theme.dart            # Theme configuration
│   └── tokens.dart               # Design tokens
└── features/                      # Feature modules
    ├── assets/                    # Assets management feature
    │   ├── data/                 # Data layer
    │   │   ├── models/           # Database models
    │   │   └── repositories/     # Data access layer
    │   ├── domain/               # Business logic layer
    │   │   └── models/           # Domain models
    │   └── presentation/         # UI layer
    │       ├── screens/          # Feature screens
    │       └── widgets/          # Feature-specific widgets
    ├── home/                      # Dashboard feature
    ├── reports/                   # Analytics feature
    ├── settings/                  # App settings feature
    └── transactions/              # Transaction management feature
```

## 🎯 Layer Architecture

### 1. Presentation Layer (UI)
**Location**: `lib/features/*/presentation/`

**Responsibilities**:
- User interface components
- User interaction handling
- State presentation
- Navigation coordination

**Components**:
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components
- **Controllers**: Form and interaction logic

**Key Files**:
```dart
// Example: Transaction List Screen
class TransactionsScreen extends ConsumerStatefulWidget {
  // UI logic and state management
}

// Example: Transaction List Item Widget
class TransactionListItem extends StatelessWidget {
  // Reusable list item component
}
```

### 2. Domain Layer (Business Logic)
**Location**: `lib/features/*/domain/`

**Responsibilities**:
- Business rules and logic
- Domain models and entities
- Use cases and business operations
- Validation rules

**Components**:
- **Models**: Domain entities with business logic
- **Use Cases**: Business operations and workflows
- **Validators**: Business rule validation

**Key Files**:
```dart
// Example: Transaction Domain Model
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    String? id,
    required TransactionType type,
    required double amount,
    required String category,
    String? merchant,
    String? tripId,
    required DateTime date,
    String? note,
  }) = _Transaction;
}
```

### 3. Data Layer (Data Access)
**Location**: `lib/features/*/data/`

**Responsibilities**:
- Data persistence and retrieval
- External API communication
- Data transformation
- Caching strategies

**Components**:
- **Repositories**: Data access abstraction
- **Data Sources**: Local and remote data sources
- **Models**: Data transfer objects (DTOs)
- **Mappers**: Data transformation logic

**Key Files**:
```dart
// Example: Transaction Repository
@riverpod
class TransactionRepository extends _$TransactionRepository {
  // Data access methods
  Future<void> addTransaction(Transaction transaction);
  Stream<List<Transaction>> watchAllTransactions();
  Stream<double> watchTotalIncome();
}
```

## 🔄 Data Flow Architecture

### Unidirectional Data Flow

The application follows a unidirectional data flow pattern:

```
UI Action → State Management → Business Logic → Data Layer → Database
     ↑                                                           |
     └─────────────────── State Update ←────────────────────────┘
```

### State Management Flow

1. **User Action**: User interacts with UI
2. **State Update**: Riverpod provider updates state
3. **Business Logic**: Domain layer processes the action
4. **Data Persistence**: Repository saves to database
5. **UI Update**: Stream updates trigger UI rebuild

### Example Flow: Adding a Transaction

```dart
// 1. User Action (UI)
FilledButton(
  onPressed: _saveTransaction, // User taps save
  child: Text('Save Transaction'),
)

// 2. State Update (Presentation)
Future<void> _saveTransaction() async {
  final repository = ref.read(transactionRepositoryProvider.notifier);
  await repository.addTransaction(transaction); // Update state
}

// 3. Business Logic (Domain)
// Transaction model validates data

// 4. Data Persistence (Data)
await _isar.writeTxn(() async {
  await _isar.transactionIsars.put(transactionIsar); // Save to DB
});

// 5. UI Update (Stream)
Stream<List<Transaction>> watchAllTransactions() {
  return _isar.transactionIsars
      .where()
      .watch(fireImmediately: true) // Auto-update UI
      .map((list) => list.map((e) => e.toDomain()).toList());
}
```

## 🗄️ Database Architecture

### Isar Database Design

**Why Isar?**
- **Performance**: Extremely fast NoSQL database
- **Type Safety**: Strongly typed operations
- **Real-time**: Live queries and reactive updates
- **Cross-platform**: Works on all Flutter platforms

### Database Schema

#### Transaction Collection
```dart
@collection
class TransactionIsar {
  Id id = Isar.autoIncrement;
  
  @enumerated
  late TransactionType type;
  
  late double amount;
  
  @Index() // For efficient category filtering
  late String category;
  
  String? merchant;
  String? tripId;
  
  @Index() // For efficient date filtering
  late DateTime date;
  
  String? note;
}
```

#### Asset Collection
```dart
@collection
class AssetIsar {
  Id id = Isar.autoIncrement;
  
  late String name;
  late double amount;
  
  @enumerated
  late AssetType type;
  
  late bool isRecurring;
  String? description;
}
```

### Indexing Strategy

- **Category Index**: For filtering transactions by category
- **Date Index**: For date range queries and sorting
- **Type Index**: For income/expense filtering
- **Recurring Index**: For recurring asset queries

## 🧭 Navigation Architecture

### go_router Configuration

**Why go_router?**
- **Declarative**: Clear route definitions
- **Type Safety**: Compile-time route checking
- **Deep Linking**: URL-based navigation
- **Nested Routing**: Complex navigation hierarchies

### Route Structure

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute( // Bottom navigation wrapper
        builder: (context, state, child) {
          return ScaffoldWithBottomNavigation(child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/transactions', builder: (context, state) => const TransactionsScreen()),
          GoRoute(path: '/reports', builder: (context, state) => const ReportsScreen()),
          GoRoute(path: '/assets', builder: (context, state) => const AssetsScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
      GoRoute(path: '/add', builder: (context, state) => const AddTransactionScreen()),
      GoRoute(path: '/edit/:id', builder: (context, state) => EditTransactionScreen(transactionId: state.pathParameters['id']!)),
    ],
  );
});
```

## 🏗️ State Management Architecture

### Riverpod Implementation

**Why Riverpod?**
- **Type Safety**: Compile-time dependency checking
- **Performance**: Efficient rebuilds with granular updates
- **Testing**: Easy mocking and testing
- **DevTools**: Excellent debugging tools

### Provider Hierarchy

```
AppProvider (Root)
├── RouterProvider
├── DatabaseProvider
├── TransactionRepositoryProvider
├── AssetRepositoryProvider
└── Feature-specific Providers
    ├── TransactionListProvider
    ├── TransactionFilterProvider
    ├── ReportDataProvider
    └── SettingsProvider
```

### Provider Types Used

1. **Provider**: Simple value providers
2. **StateProvider**: Simple state management
3. **StateNotifierProvider**: Complex state management
4. **FutureProvider**: Async data providers
5. **StreamProvider**: Real-time data providers

### Example Provider Implementation

```dart
// Repository Provider
@riverpod
class TransactionRepository extends _$TransactionRepository {
  late final Isar _isar;

  @override
  Future<void> build() async {
    _isar = DatabaseService.instance;
  }

  // CRUD Operations
  Future<void> addTransaction(Transaction transaction) async {
    final transactionIsar = TransactionIsar.fromDomain(transaction);
    await _isar.writeTxn(() async {
      await _isar.transactionIsars.put(transactionIsar);
    });
  }

  // Stream Operations
  Stream<List<Transaction>> watchAllTransactions() {
    return _isar.transactionIsars
        .where()
        .sortByDate()
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }
}
```

## 🎨 Design System Architecture

### Design Token System

**Why Design Tokens?**
- **Consistency**: Standardized design values
- **Maintainability**: Centralized design configuration
- **Scalability**: Easy to update design system
- **Accessibility**: Built-in accessibility considerations

### Token Categories

```dart
class AppTokens {
  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;

  // Duration
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 240);

  // Curves
  static const Curve curveEaseInOutCubic = Curves.easeInOutCubic;

  // Radius
  static const double radius = 16.0;

  // Elevation
  static const double elevationLow = 1.0;
  static const double elevationMedium = 2.0;
  static const double elevationHigh = 4.0;
}
```

### Theme Architecture

```dart
class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
        ),
      ),
    );
  }
}
```

## 🔧 Dependency Injection Architecture

### Riverpod as DI Container

Riverpod serves as our dependency injection container, providing:

- **Automatic DI**: Providers automatically inject dependencies
- **Lazy Loading**: Dependencies are created only when needed
- **Singleton Management**: Automatic singleton lifecycle
- **Testing Support**: Easy dependency mocking

### Dependency Graph

```
DatabaseService
├── TransactionRepository
│   └── TransactionScreen
│       ├── TransactionListProvider
│       └── TransactionFilterProvider
├── AssetRepository
│   └── AssetScreen
│       └── AssetListProvider
└── SettingsRepository
    └── SettingsScreen
        └── SettingsProvider
```

## 🧪 Testing Architecture

### Testing Strategy

1. **Unit Tests**: Test individual functions and classes
2. **Widget Tests**: Test UI components in isolation
3. **Golden Tests**: Visual regression testing
4. **Integration Tests**: Test feature workflows

### Test Organization

```
test/
├── formatters_test.dart           # Unit tests for utilities
├── widget_test.dart              # Main app widget test
├── golden/                       # Visual regression tests
│   ├── home_screen_golden_test.dart
│   ├── transaction_list_item_golden_test.dart
│   └── reports_donut_golden_test.dart
└── repositories/                 # Repository tests
    ├── transaction_repository_test.dart
    └── asset_repository_test.dart
```

## 📊 Performance Architecture

### Performance Optimizations

1. **Lazy Loading**: Load data only when needed
2. **Caching**: Cache frequently accessed data
3. **Indexing**: Database indexes for fast queries
4. **Stream Optimization**: Efficient stream management
5. **Memory Management**: Proper resource disposal

### Memory Management

```dart
// Proper disposal in widgets
@override
void dispose() {
  _amountController.dispose();
  _merchantController.dispose();
  _noteController.dispose();
  super.dispose();
}

// Automatic disposal with Riverpod
@riverpod
class TransactionRepository extends _$TransactionRepository {
  // Automatic disposal when provider is disposed
}
```

## 🔒 Security Architecture

### Data Security

1. **Local Storage**: Sensitive data stored locally only
2. **Input Validation**: All user inputs validated
3. **SQL Injection Prevention**: Type-safe database queries
4. **Memory Security**: Proper data disposal

### Privacy Considerations

- No data sent to external servers
- All data stored locally on device
- Optional data export for user control
- Clear data deletion options

## 🚀 Scalability Architecture

### Horizontal Scalability

- **Feature Modules**: Independent feature development
- **Repository Pattern**: Easy to swap data sources
- **Provider Abstraction**: Easy to add new state management
- **Plugin Architecture**: Easy to add new functionality

### Vertical Scalability

- **Efficient Queries**: Optimized database queries
- **Stream Management**: Efficient real-time updates
- **Memory Optimization**: Proper resource management
- **Performance Monitoring**: Built-in performance tracking

## 🔄 Migration Strategy

### Version Migration

1. **Database Migration**: Isar handles schema changes
2. **Model Migration**: Freezed handles model changes
3. **State Migration**: Riverpod handles state changes
4. **UI Migration**: Gradual UI updates

### Breaking Changes

- **Semantic Versioning**: Clear version numbering
- **Migration Guides**: Step-by-step migration instructions
- **Backward Compatibility**: Maintain compatibility when possible
- **Testing**: Comprehensive migration testing

## 📈 Monitoring & Analytics

### Performance Monitoring

- **Build Performance**: Monitor build times
- **Runtime Performance**: Monitor app performance
- **Memory Usage**: Track memory consumption
- **Database Performance**: Monitor query performance

### Error Tracking

- **Error Logging**: Comprehensive error logging
- **Crash Reporting**: Automatic crash reporting
- **User Feedback**: User-reported issues
- **Performance Metrics**: Key performance indicators

## 🎯 Future Architecture Considerations

### Planned Improvements

1. **Offline Support**: Enhanced offline capabilities
2. **Cloud Sync**: Optional cloud synchronization
3. **Advanced Analytics**: More detailed financial insights
4. **Multi-currency**: Support for multiple currencies
5. **Budget Planning**: Advanced budget management

### Technology Evolution

- **Flutter 4.0**: Prepare for Flutter 4.0 features
- **Riverpod 3.0**: Monitor Riverpod 3.0 updates
- **Isar 4.0**: Watch for Isar 4.0 improvements
- **Material 4**: Future design system updates

---

This architecture provides a solid foundation for a scalable, maintainable, and performant personal finance application while maintaining flexibility for future enhancements and improvements.
