class AppConstants {
  // Expense categories
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Utilities',
    'Housing',
    'Education',
    'Travel',
    'Personal Care',
    'Gifts',
    'Other',
  ];

  // Income categories
  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Gift',
    'Other',
  ];

  // Trip categories (for grouping expenses)
  static const List<String> tripCategories = [
    'No Trip',
    'Business Trip',
    'Vacation',
    'Weekend Getaway',
    'Day Trip',
  ];

  // Date formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';

  // Currency format
  static const String currencySymbol = '\$';
  static const int decimalPlaces = 2;

  // Chart colors for different categories
  static const List<int> chartColors = [
    0xFF7FB069, // Green
    0xFFFFB347, // Orange
    0xFFE6D5AC, // Sand
    0xFF6B8E23, // Dark Green
    0xFFFF8C42, // Dark Orange
    0xFFD4A574, // Light Brown
    0xFF90EE90, // Light Green
    0xFFFFD700, // Gold
    0xFF98FB98, // Pale Green
    0xFFFFA07A, // Light Salmon
    0xFF32CD32, // Lime Green
    0xFFFF6347, // Tomato
  ];

  // App settings
  static const String appName = 'Personal Expense Tracker';
  static const String appVersion = '1.0.0';
  
  // Database settings
  static const String databaseName = 'expense_tracker.db';
  static const int databaseVersion = 1;
} 