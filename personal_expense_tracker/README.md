# Personal Expense Tracker

A modern Flutter app for tracking personal expenses and income with beautiful Material 3 design, real-time data, and comprehensive reporting.

## 🏗️ Architecture

This app follows a clean architecture pattern with feature-based modules:

```
lib/
├── core/                    # Core utilities and services
│   ├── formatters.dart     # Currency and date formatting
│   ├── navigation/         # App routing with go_router
│   ├── seed.dart          # Initial data seeding
│   └── services/          # Database service
├── design/                 # Design system
│   ├── app_card.dart      # Reusable card component
│   ├── app_theme.dart     # Material 3 theme configuration
│   └── tokens.dart        # Design tokens (spacing, colors, etc.)
└── features/              # Feature modules
    ├── assets/            # Assets and income management
    ├── home/              # Dashboard and overview
    ├── reports/           # Analytics and charts
    ├── settings/          # App preferences
    └── transactions/      # Transaction management
        ├── data/          # Data layer (repositories, models)
        ├── domain/        # Business logic (models, use cases)
        └── presentation/  # UI layer (screens, widgets)
```

## 🛠️ Tech Stack

- **Flutter** (stable) with Material 3
- **go_router** for navigation
- **Riverpod** (hooks_riverpod) for state management
- **freezed** + **json_serializable** for models
- **Isar** for local database with async CRUD and indexes
- **intl** for internationalization
- **flutter_animate** for smooth animations
- **very_good_analysis** for code quality

## 🚀 Getting Started

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code:**
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 📊 Features

### Home Screen
- Hero card showing net balance
- Quick overview cards (Weekly/Monthly) with delta indicators
- Assets summary with total assets and monthly income
- Tap to navigate to detailed reports

### Add Transaction
- Toggle between Income/Expense
- Amount input with validation
- Date picker with system integration
- Category picker with predefined options
- Optional merchant and notes
- Form validation with disabled state

### Transactions List
- List items with category icons and color coding
- Swipe actions (Edit/Delete) with fixed width
- Segmented filter (All/Income/Expense)
- Search functionality
- Date range and category filtering

### Reports
- Sticky header with period selector
- Income, Expenses, and Net Savings totals
- Donut chart for expenses by category
- Bar chart for income vs expenses
- Legend with values and percentages

### Assets & Income
- Total assets and monthly income display
- Recurring income section
- All assets list with swipe actions
- Add asset bottom sheet with form validation

## 🎨 Design System

### Colors
- Seeded color scheme with Material 3
- Light and dark theme support
- Semantic colors (green for income, red for expenses)

### Typography
- DisplayLarge: 28/700
- TitleLarge: 20/700
- TitleMedium: 16/600
- BodyLarge: 14/400
- LabelSmall: 12/500

### Spacing
- 4, 8, 12, 16, 24px spacing tokens
- 16px border radius
- 1px elevation for cards

### Animations
- Fast: 150ms, Medium: 240ms
- Ease-in-out cubic curves
- Respects reduced motion settings

## 📱 Adding New Categories

To add a new transaction category:

1. **Update the seed data** in `lib/core/seed.dart`:
   ```dart
   static const List<String> defaultCategories = [
     'Food & Dining',
     'Transportation',
     'Shopping',
     'Entertainment',
     'Healthcare',
     'Utilities',
     'Housing',
     'Education',
     'Travel',
     'Salary',
     'Freelance',
     'Investment',
     'Gifts',
     'Your New Category',  // Add here
     'Other',
   ];
   ```

2. **Add category icon** in `lib/features/transactions/presentation/widgets/transaction_list_item.dart`:
   ```dart
   IconData _getCategoryIcon(String category) {
     switch (category.toLowerCase()) {
       // ... existing cases
       case 'your new category':
         return Icons.your_icon;
       default:
         return Icons.category;
     }
   }
   ```

## 💾 Adding New Transactions

Transactions are automatically added through the UI, but you can also add them programmatically:

```dart
final transaction = Transaction(
  type: TransactionType.expense,
  amount: 100.0,
  category: 'Food & Dining',
  merchant: 'Restaurant',
  date: DateTime.now(),
  note: 'Lunch',
);

final repository = ref.read(transactionRepositoryProvider.notifier);
await repository.addTransaction(transaction);
```

## 🔧 Database Schema

### Transaction
- `id`: String (auto-generated)
- `type`: TransactionType (income/expense)
- `amount`: double
- `category`: String (indexed)
- `merchant`: String? (optional)
- `tripId`: String? (optional)
- `date`: DateTime (indexed)
- `note`: String? (optional)

### Asset
- `id`: String (auto-generated)
- `name`: String
- `amount`: double
- `type`: AssetType (salary/investment/savings/other)
- `isRecurring`: bool
- `description`: String? (optional)

## 🧪 Testing

The app includes:
- Unit tests for formatters and repositories
- Golden tests for UI components
- Widget tests for screens

Run tests with:
```bash
flutter test
```

## 📦 Building

### Development
```bash
flutter build apk --debug
```

### Production
```bash
flutter build apk --release
```

## 🤝 Contributing

1. Follow the existing code style
2. Add tests for new features
3. Update documentation as needed
4. Use conventional commits

## 📄 License

This project is licensed under the MIT License.
