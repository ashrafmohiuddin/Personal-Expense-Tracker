# API Reference - Personal Expense Tracker

This document provides comprehensive API documentation for all functions, classes, and methods in the Personal Expense Tracker application.

## 📚 Table of Contents

- [Core Utilities](#core-utilities)
- [Design System](#design-system)
- [Database Layer](#database-layer)
- [State Management](#state-management)
- [Navigation](#navigation)
- [Models](#models)
- [Repositories](#repositories)
- [Screens](#screens)
- [Widgets](#widgets)

## 🔧 Core Utilities

### Formatters Class

**Location**: `lib/core/formatters.dart`

A utility class for formatting currency, dates, numbers, and percentages.

#### Static Methods

##### `formatCurrency(num amount)`
Formats a number as currency with ₹ symbol and 2 decimal places.

**Parameters**:
- `amount` (num): The amount to format

**Returns**: `String` - Formatted currency string

**Example**:
```dart
String formatted = Formatters.formatCurrency(1234.56);
// Returns: "₹1,234.56"
```

##### `formatDate(DateTime date)`
Formats a DateTime using locale-specific format.

**Parameters**:
- `date` (DateTime): The date to format

**Returns**: `String` - Formatted date string

**Example**:
```dart
String formatted = Formatters.formatDate(DateTime(2024, 1, 15));
// Returns: "Jan 15, 2024"
```

##### `storageDate(DateTime date)`
Formats a DateTime for storage as yyyy-MM-dd.

**Parameters**:
- `date` (DateTime): The date to format

**Returns**: `String` - Storage format date string

**Example**:
```dart
String formatted = Formatters.storageDate(DateTime(2024, 1, 15));
// Returns: "2024-01-15"
```

##### `parseStorageDate(String dateString)`
Parses a storage date string back to DateTime.

**Parameters**:
- `dateString` (String): The date string to parse

**Returns**: `DateTime` - Parsed DateTime object

**Example**:
```dart
DateTime date = Formatters.parseStorageDate("2024-01-15");
// Returns: DateTime(2024, 1, 15)
```

##### `formatNumber(num value)`
Formats a number with grouping separators.

**Parameters**:
- `value` (num): The number to format

**Returns**: `String` - Formatted number string

**Example**:
```dart
String formatted = Formatters.formatNumber(1234.56);
// Returns: "1,234.56"
```

##### `formatPercentage(double value)`
Formats a percentage with 1 decimal place.

**Parameters**:
- `value` (double): The percentage value (0.0 to 1.0)

**Returns**: `String` - Formatted percentage string

**Example**:
```dart
String formatted = Formatters.formatPercentage(0.1234);
// Returns: "12.3%"
```

## 🎨 Design System

### AppTokens Class

**Location**: `lib/design/tokens.dart`

Design tokens for consistent spacing, durations, curves, radius, and elevation.

#### Static Constants

##### Spacing
```dart
static const double spacing4 = 4.0;
static const double spacing8 = 8.0;
static const double spacing12 = 12.0;
static const double spacing16 = 16.0;
static const double spacing24 = 24.0;
```

##### Duration
```dart
static const Duration durationFast = Duration(milliseconds: 150);
static const Duration durationMedium = Duration(milliseconds: 240);
```

##### Curves
```dart
static const Curve curveEaseInOutCubic = Curves.easeInOutCubic;
```

##### Radius
```dart
static const double radius = 16.0;
```

##### Elevation
```dart
static const double elevationLow = 1.0;
static const double elevationMedium = 2.0;
static const double elevationHigh = 4.0;
```

### AppTheme Class

**Location**: `lib/design/app_theme.dart`

Theme configuration for light and dark modes using Material 3.

#### Static Getters

##### `lightTheme`
Returns the light theme configuration.

**Returns**: `ThemeData` - Light theme configuration

**Example**:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  home: MyApp(),
)
```

##### `darkTheme`
Returns the dark theme configuration.

**Returns**: `ThemeData` - Dark theme configuration

**Example**:
```dart
MaterialApp(
  theme: AppTheme.darkTheme,
  home: MyApp(),
)
```

#### Private Methods

##### `_buildTextTheme(ColorScheme colorScheme)`
Builds the text theme for the application.

**Parameters**:
- `colorScheme` (ColorScheme): The color scheme to use

**Returns**: `TextTheme` - Configured text theme

### AppCard Widget

**Location**: `lib/design/app_card.dart`

A reusable card widget with standard styling and optional leading icon.

#### Constructor
```dart
const AppCard({
  super.key,
  required this.child,
  this.leadingIcon,
  this.onTap,
  this.padding = const EdgeInsets.all(AppTokens.spacing16),
  this.margin,
  this.elevation = AppTokens.elevationLow,
  this.radius = AppTokens.radius,
});
```

#### Properties
- `child` (Widget): The content of the card
- `leadingIcon` (IconData?): Optional leading icon
- `onTap` (VoidCallback?): Optional tap callback
- `padding` (EdgeInsetsGeometry): Card padding
- `margin` (EdgeInsetsGeometry?): Card margin
- `elevation` (double): Card elevation
- `radius` (double): Card corner radius

#### Example
```dart
AppCard(
  leadingIcon: Icons.account_balance,
  onTap: () => print('Card tapped'),
  child: Text('Card content'),
)
```

## 🗄️ Database Layer

### DatabaseService Class

**Location**: `lib/core/services/database_service.dart`

Manages the Isar database instance and initialization.

#### Static Methods

##### `initialize()`
Initializes the Isar database instance.

**Returns**: `Future<void>`

**Example**:
```dart
await DatabaseService.initialize();
```

##### `close()`
Closes the Isar database instance.

**Returns**: `Future<void>`

**Example**:
```dart
await DatabaseService.close();
```

#### Static Getters

##### `instance`
Gets the Isar database instance.

**Returns**: `Isar` - Database instance

**Throws**: `StateError` if database not initialized

**Example**:
```dart
final isar = DatabaseService.instance;
```

### TransactionIsar Class

**Location**: `lib/features/transactions/data/models/transaction_isar.dart`

Isar database model for Transaction entities.

#### Properties
```dart
Id id = Isar.autoIncrement;
@enumerated late TransactionType type;
late double amount;
@Index() late String category;
String? merchant;
String? tripId;
@Index() late DateTime date;
String? note;
```

#### Methods

##### `fromDomain(Transaction transaction)`
Creates a TransactionIsar from a domain Transaction.

**Parameters**:
- `transaction` (Transaction): Domain transaction

**Example**:
```dart
final transactionIsar = TransactionIsar.fromDomain(transaction);
```

##### `toDomain()`
Converts TransactionIsar to domain Transaction.

**Returns**: `Transaction` - Domain transaction

**Example**:
```dart
final transaction = transactionIsar.toDomain();
```

### AssetIsar Class

**Location**: `lib/features/assets/data/models/asset_isar.dart`

Isar database model for Asset entities.

#### Properties
```dart
Id id = Isar.autoIncrement;
late String name;
late double amount;
@enumerated late AssetType type;
late bool isRecurring;
String? description;
```

#### Methods

##### `fromDomain(Asset asset)`
Creates an AssetIsar from a domain Asset.

**Parameters**:
- `asset` (Asset): Domain asset

**Example**:
```dart
final assetIsar = AssetIsar.fromDomain(asset);
```

##### `toDomain()`
Converts AssetIsar to domain Asset.

**Returns**: `Asset` - Domain asset

**Example**:
```dart
final asset = assetIsar.toDomain();
```

## 🏗️ State Management

### TransactionRepository Class

**Location**: `lib/features/transactions/data/repositories/transaction_repository.dart`

Repository for managing Transaction entities with Riverpod.

#### Methods

##### `addTransaction(Transaction transaction)`
Adds a new transaction to the database.

**Parameters**:
- `transaction` (Transaction): Transaction to add

**Returns**: `Future<void>`

**Example**:
```dart
await repository.addTransaction(transaction);
```

##### `updateTransaction(Transaction transaction)`
Updates an existing transaction.

**Parameters**:
- `transaction` (Transaction): Transaction to update

**Returns**: `Future<void>`

**Example**:
```dart
await repository.updateTransaction(transaction);
```

##### `deleteTransaction(String id)`
Deletes a transaction by ID.

**Parameters**:
- `id` (String): Transaction ID to delete

**Returns**: `Future<void>`

**Example**:
```dart
await repository.deleteTransaction('123');
```

##### `getTransaction(String id)`
Gets a transaction by ID.

**Parameters**:
- `id` (String): Transaction ID

**Returns**: `Future<Transaction?>` - Transaction or null if not found

**Example**:
```dart
final transaction = await repository.getTransaction('123');
```

##### `watchAllTransactions()`
Watches all transactions as a stream.

**Returns**: `Stream<List<Transaction>>` - Stream of all transactions

**Example**:
```dart
final transactionsStream = repository.watchAllTransactions();
```

##### `watchTransactionsByType(TransactionType type)`
Watches transactions filtered by type.

**Parameters**:
- `type` (TransactionType): Type to filter by

**Returns**: `Stream<List<Transaction>>` - Stream of filtered transactions

**Example**:
```dart
final incomeStream = repository.watchTransactionsByType(TransactionType.income);
```

##### `watchTotalIncome()`
Watches total income as a stream.

**Returns**: `Stream<double>` - Stream of total income

**Example**:
```dart
final totalIncomeStream = repository.watchTotalIncome();
```

##### `watchTotalExpenses()`
Watches total expenses as a stream.

**Returns**: `Stream<double>` - Stream of total expenses

**Example**:
```dart
final totalExpensesStream = repository.watchTotalExpenses();
```

##### `watchNetBalance()`
Watches net balance (income - expenses) as a stream.

**Returns**: `Stream<double>` - Stream of net balance

**Example**:
```dart
final netBalanceStream = repository.watchNetBalance();
```

### AssetRepository Class

**Location**: `lib/features/assets/data/repositories/asset_repository.dart`

Repository for managing Asset entities with Riverpod.

#### Methods

##### `addAsset(Asset asset)`
Adds a new asset to the database.

**Parameters**:
- `asset` (Asset): Asset to add

**Returns**: `Future<void>`

**Example**:
```dart
await repository.addAsset(asset);
```

##### `updateAsset(Asset asset)`
Updates an existing asset.

**Parameters**:
- `asset` (Asset): Asset to update

**Returns**: `Future<void>`

**Example**:
```dart
await repository.updateAsset(asset);
```

##### `deleteAsset(String id)`
Deletes an asset by ID.

**Parameters**:
- `id` (String): Asset ID to delete

**Returns**: `Future<void>`

**Example**:
```dart
await repository.deleteAsset('123');
```

##### `getAsset(String id)`
Gets an asset by ID.

**Parameters**:
- `id` (String): Asset ID

**Returns**: `Future<Asset?>` - Asset or null if not found

**Example**:
```dart
final asset = await repository.getAsset('123');
```

##### `watchAllAssets()`
Watches all assets as a stream.

**Returns**: `Stream<List<Asset>>` - Stream of all assets

**Example**:
```dart
final assetsStream = repository.watchAllAssets();
```

##### `watchRecurringAssets()`
Watches recurring assets as a stream.

**Returns**: `Stream<List<Asset>>` - Stream of recurring assets

**Example**:
```dart
final recurringAssetsStream = repository.watchRecurringAssets();
```

##### `watchTotalAssets()`
Watches total assets value as a stream.

**Returns**: `Stream<double>` - Stream of total assets value

**Example**:
```dart
final totalAssetsStream = repository.watchTotalAssets();
```

##### `watchMonthlyIncome()`
Watches monthly income from recurring assets as a stream.

**Returns**: `Stream<double>` - Stream of monthly income

**Example**:
```dart
final monthlyIncomeStream = repository.watchMonthlyIncome();
```

## 🧭 Navigation

### AppRouter

**Location**: `lib/core/navigation/app_router.dart`

Navigation configuration using go_router.

#### Routes

##### `/home`
Home screen with dashboard and overview.

**Screen**: `HomeScreen`

##### `/add`
Add transaction screen.

**Screen**: `AddTransactionScreen`

##### `/transactions`
Transactions list screen.

**Screen**: `TransactionsScreen`

##### `/reports`
Reports and analytics screen.

**Screen**: `ReportsScreen`

##### `/assets`
Assets management screen.

**Screen**: `AssetsScreen`

##### `/settings`
App settings screen.

**Screen**: `SettingsScreen`

##### `/edit/:id`
Edit transaction screen with dynamic ID parameter.

**Screen**: `EditTransactionScreen`

**Parameters**:
- `id` (String): Transaction ID to edit

#### Example Usage
```dart
// Navigate to home
context.go('/home');

// Navigate to add transaction
context.go('/add');

// Navigate to edit transaction
context.go('/edit/123');
```

### ScaffoldWithBottomNavigation Widget

**Location**: `lib/core/navigation/app_router.dart`

Scaffold with bottom navigation bar for main app screens.

#### Constructor
```dart
const ScaffoldWithBottomNavigation({
  super.key,
  required this.child,
});
```

#### Properties
- `child` (Widget): The content to display

## 📊 Models

### Transaction Class

**Location**: `lib/features/transactions/domain/models/transaction.dart`

Domain model for financial transactions.

#### Constructor
```dart
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
```

#### Properties
- `id` (String?): Unique identifier
- `type` (TransactionType): Transaction type (income/expense)
- `amount` (double): Transaction amount
- `category` (String): Transaction category
- `merchant` (String?): Optional merchant name
- `tripId` (String?): Optional trip identifier
- `date` (DateTime): Transaction date
- `note` (String?): Optional notes

#### Methods

##### `copyWith({...})`
Creates a copy with modified fields.

**Returns**: `Transaction` - New transaction instance

**Example**:
```dart
final updatedTransaction = transaction.copyWith(
  amount: 150.0,
  note: 'Updated note',
);
```

##### `toJson()`
Converts to JSON map.

**Returns**: `Map<String, dynamic>` - JSON representation

##### `fromJson(Map<String, dynamic> json)`
Creates from JSON map.

**Parameters**:
- `json` (Map<String, dynamic>): JSON data

**Returns**: `Transaction` - Transaction instance

### TransactionType Enum

**Location**: `lib/features/transactions/domain/models/transaction.dart`

Enumeration for transaction types.

#### Values
```dart
enum TransactionType {
  @JsonValue('income') income,
  @JsonValue('expense') expense,
}
```

#### Extension Methods

##### `isIncome`
Returns true if transaction type is income.

**Returns**: `bool`

##### `isExpense`
Returns true if transaction type is expense.

**Returns**: `bool`

### Asset Class

**Location**: `lib/features/assets/domain/models/asset.dart`

Domain model for financial assets.

#### Constructor
```dart
const factory Asset({
  String? id,
  required String name,
  required double amount,
  required AssetType type,
  required bool isRecurring,
  String? description,
}) = _Asset;
```

#### Properties
- `id` (String?): Unique identifier
- `name` (String): Asset name
- `amount` (double): Asset value
- `type` (AssetType): Asset type
- `isRecurring` (bool): Whether asset provides recurring income
- `description` (String?): Optional description

#### Methods

##### `copyWith({...})`
Creates a copy with modified fields.

**Returns**: `Asset` - New asset instance

**Example**:
```dart
final updatedAsset = asset.copyWith(
  amount: 2000.0,
  description: 'Updated description',
);
```

##### `toJson()`
Converts to JSON map.

**Returns**: `Map<String, dynamic>` - JSON representation

##### `fromJson(Map<String, dynamic> json)`
Creates from JSON map.

**Parameters**:
- `json` (Map<String, dynamic>): JSON data

**Returns**: `Asset` - Asset instance

### AssetType Enum

**Location**: `lib/features/assets/domain/models/asset.dart`

Enumeration for asset types.

#### Values
```dart
enum AssetType {
  @JsonValue('salary') salary,
  @JsonValue('investment') investment,
  @JsonValue('savings') savings,
  @JsonValue('other') other,
}
```

#### Extension Properties

##### `displayName`
Returns the display name for the asset type.

**Returns**: `String`

**Example**:
```dart
String name = AssetType.salary.displayName; // "Salary"
```

## 🖥️ Screens

### HomeScreen

**Location**: `lib/features/home/presentation/screens/home_screen.dart`

Main dashboard screen showing financial overview.

#### Widget Type
`ConsumerStatefulWidget`

#### Key Features
- Hero card with net balance
- Quick overview cards (weekly/monthly)
- Assets summary
- Navigation to detailed reports

#### Example Usage
```dart
const HomeScreen()
```

### AddTransactionScreen

**Location**: `lib/features/transactions/presentation/screens/add_transaction_screen.dart`

Screen for adding new transactions.

#### Widget Type
`ConsumerStatefulWidget`

#### Key Features
- Transaction type toggle (income/expense)
- Amount input with validation
- Date picker
- Category picker
- Optional merchant and notes
- Form validation

#### Example Usage
```dart
const AddTransactionScreen()
```

### TransactionsScreen

**Location**: `lib/features/transactions/presentation/screens/transactions_screen.dart`

Screen for viewing and managing transactions.

#### Widget Type
`ConsumerStatefulWidget`

#### Key Features
- Transaction list with swipe actions
- Search functionality
- Filtering by type
- Advanced filtering options
- Undo functionality

#### Example Usage
```dart
const TransactionsScreen()
```

### ReportsScreen

**Location**: `lib/features/reports/presentation/screens/reports_screen.dart`

Screen for financial analytics and reports.

#### Widget Type
`ConsumerStatefulWidget`

#### Key Features
- Period selector
- Financial summary cards
- Expense donut chart
- Income vs expenses bar chart
- Interactive legends

#### Example Usage
```dart
const ReportsScreen()
```

### AssetsScreen

**Location**: `lib/features/assets/presentation/screens/assets_screen.dart`

Screen for managing assets and income sources.

#### Widget Type
`ConsumerStatefulWidget`

#### Key Features
- Assets overview
- Recurring income section
- All assets list
- Add asset functionality
- Swipe actions for management

#### Example Usage
```dart
const AssetsScreen()
```

### SettingsScreen

**Location**: `lib/features/settings/presentation/screens/settings_screen.dart`

Screen for app preferences and configuration.

#### Widget Type
`ConsumerStatefulWidget`

#### Key Features
- Theme toggle
- Reduced motion settings
- Currency selection
- Data management options
- About section

#### Example Usage
```dart
const SettingsScreen()
```

### EditTransactionScreen

**Location**: `lib/features/transactions/presentation/screens/edit_transaction_screen.dart`

Screen for editing existing transactions.

#### Widget Type
`ConsumerStatefulWidget`

#### Constructor
```dart
const EditTransactionScreen({
  super.key,
  required this.transactionId,
});
```

#### Properties
- `transactionId` (String): ID of transaction to edit

#### Key Features
- Pre-populated form with existing data
- Same validation as add screen
- Update functionality
- Loading state management

#### Example Usage
```dart
EditTransactionScreen(transactionId: '123')
```

## 🧩 Widgets

### HeroCard Widget

**Location**: `lib/features/home/presentation/widgets/hero_card.dart`

Card widget for displaying hero information with title, subtitle, and amount.

#### Constructor
```dart
const HeroCard({
  super.key,
  required this.title,
  required this.subtitle,
  required this.amount,
  this.icon,
  this.onTap,
});
```

#### Properties
- `title` (String): Card title
- `subtitle` (String): Card subtitle
- `amount` (String): Formatted amount
- `icon` (IconData?): Optional icon
- `onTap` (VoidCallback?): Optional tap callback

#### Example Usage
```dart
HeroCard(
  title: 'Net Balance',
  subtitle: 'Today',
  amount: '₹50,000',
  icon: Icons.account_balance,
  onTap: () => print('Card tapped'),
)
```

### QuickOverviewCard Widget

**Location**: `lib/features/home/presentation/widgets/quick_overview_card.dart`

Card widget for displaying quick financial overview with period, net delta, and breakdown.

#### Constructor
```dart
const QuickOverviewCard({
  super.key,
  required this.period,
  required this.netDelta,
  required this.income,
  required this.expenses,
});
```

#### Properties
- `period` (String): Period title (e.g., "Weekly", "Monthly")
- `netDelta` (double): Net amount (income - expenses)
- `income` (double): Total income
- `expenses` (double): Total expenses

#### Example Usage
```dart
QuickOverviewCard(
  period: 'Weekly',
  netDelta: 5000.0,
  income: 15000.0,
  expenses: 10000.0,
)
```

### TransactionListItem Widget

**Location**: `lib/features/transactions/presentation/widgets/transaction_list_item.dart`

List item widget for displaying transaction information with swipe actions.

#### Constructor
```dart
const TransactionListItem({
  super.key,
  required this.transaction,
  required this.onEdit,
  required this.onDelete,
});
```

#### Properties
- `transaction` (Transaction): Transaction to display
- `onEdit` (VoidCallback): Edit callback
- `onDelete` (VoidCallback): Delete callback

#### Key Features
- Color-coded display (green for income, red for expenses)
- Category icons
- Swipe actions (edit/delete)
- Transaction details (amount, category, date, merchant, notes)

#### Example Usage
```dart
TransactionListItem(
  transaction: transaction,
  onEdit: () => print('Edit transaction'),
  onDelete: () => print('Delete transaction'),
)
```

### CategoryPicker Widget

**Location**: `lib/features/transactions/presentation/widgets/category_picker.dart`

Bottom sheet widget for selecting transaction categories.

#### Constructor
```dart
const CategoryPicker({super.key});
```

#### Key Features
- Grid layout of available categories
- Tap to select functionality
- Close button
- Responsive design

#### Example Usage
```dart
showModalBottomSheet<String>(
  context: context,
  builder: (context) => const CategoryPicker(),
)
```

### FilterBottomSheet Widget

**Location**: `lib/features/transactions/presentation/widgets/filter_bottom_sheet.dart`

Bottom sheet widget for advanced transaction filtering.

#### Constructor
```dart
const FilterBottomSheet({
  super.key,
  this.dateRange,
  required this.onDateRangeChanged,
});
```

#### Properties
- `dateRange` (DateTimeRange?): Current date range filter
- `onDateRangeChanged` (ValueChanged<DateTimeRange?>): Date range change callback

#### Key Features
- Date range selection (this week, this month, last month, custom)
- Category filtering
- Apply filters functionality
- Custom date range picker

#### Example Usage
```dart
FilterBottomSheet(
  dateRange: selectedDateRange,
  onDateRangeChanged: (range) => setState(() => selectedDateRange = range),
)
```

### ExpenseDonutChart Widget

**Location**: `lib/features/reports/presentation/widgets/expense_donut_chart.dart`

Chart widget for displaying expenses by category in a donut chart format.

#### Constructor
```dart
const ExpenseDonutChart({super.key});
```

#### Key Features
- Interactive donut chart
- Color-coded categories
- Detailed legend with amounts and percentages
- Responsive design
- Empty state handling

#### Example Usage
```dart
const ExpenseDonutChart()
```

### IncomeExpenseBarChart Widget

**Location**: `lib/features/reports/presentation/widgets/income_expense_bar_chart.dart`

Chart widget for comparing income vs expenses in a bar chart format.

#### Constructor
```dart
const IncomeExpenseBarChart({super.key});
```

#### Key Features
- Side-by-side bar comparison
- Automatic scaling
- Color-coded bars (green for income, red for expenses)
- Legend for identification
- Responsive design

#### Example Usage
```dart
const IncomeExpenseBarChart()
```

### AssetListItem Widget

**Location**: `lib/features/assets/presentation/widgets/asset_list_item.dart`

List item widget for displaying asset information with swipe actions.

#### Constructor
```dart
const AssetListItem({
  super.key,
  required this.asset,
  required this.onEdit,
  required this.onDelete,
});
```

#### Properties
- `asset` (Asset): Asset to display
- `onEdit` (VoidCallback): Edit callback
- `onDelete` (VoidCallback): Delete callback

#### Key Features
- Asset type icons and colors
- Recurring badge for recurring assets
- Swipe actions (edit/delete)
- Asset details (name, amount, type, description)

#### Example Usage
```dart
AssetListItem(
  asset: asset,
  onEdit: () => print('Edit asset'),
  onDelete: () => print('Delete asset'),
)
```

### AddAssetBottomSheet Widget

**Location**: `lib/features/assets/presentation/widgets/add_asset_bottom_sheet.dart`

Bottom sheet widget for adding new assets.

#### Constructor
```dart
const AddAssetBottomSheet({super.key});
```

#### Key Features
- Asset name input
- Amount input with validation
- Asset type dropdown
- Recurring checkbox
- Optional description
- Form validation
- Save functionality

#### Example Usage
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => const AddAssetBottomSheet(),
)
```

## 🔄 Providers

### Repository Providers

#### transactionRepositoryProvider
**Type**: `Provider<TransactionRepository>`

Provides access to the transaction repository.

**Example Usage**:
```dart
final repository = ref.read(transactionRepositoryProvider);
```

#### assetRepositoryProvider
**Type**: `Provider<AssetRepository>`

Provides access to the asset repository.

**Example Usage**:
```dart
final repository = ref.read(assetRepositoryProvider);
```

### Router Provider

#### routerProvider
**Type**: `Provider<GoRouter>`

Provides access to the app router.

**Example Usage**:
```dart
final router = ref.read(routerProvider);
```

## 📝 Usage Examples

### Adding a Transaction
```dart
// Get repository
final repository = ref.read(transactionRepositoryProvider.notifier);

// Create transaction
final transaction = Transaction(
  type: TransactionType.expense,
  amount: 100.0,
  category: 'Food & Dining',
  merchant: 'Grocery Store',
  date: DateTime.now(),
  note: 'Weekly groceries',
);

// Add to database
await repository.addTransaction(transaction);
```

### Watching Transactions
```dart
// Watch all transactions
final transactionsAsync = ref.watch(
  transactionRepositoryProvider.select((repo) => repo.watchAllTransactions()),
);

// Use in widget
transactionsAsync.when(
  data: (transactions) => TransactionList(transactions: transactions),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### Navigation
```dart
// Navigate to add transaction
context.go('/add');

// Navigate to edit transaction
context.go('/edit/123');

// Navigate to reports
context.go('/reports');
```

### Formatting
```dart
// Format currency
String formatted = Formatters.formatCurrency(1234.56);

// Format date
String date = Formatters.formatDate(DateTime.now());

// Format percentage
String percentage = Formatters.formatPercentage(0.25);
```

---

This API reference provides comprehensive documentation for all public APIs in the Personal Expense Tracker application. For additional information about specific implementations or usage patterns, please refer to the source code or create an issue on GitHub.
