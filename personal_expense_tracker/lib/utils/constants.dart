import 'package:shared_preferences/shared_preferences.dart';

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

  // Currency settings
  static const String _currencyCodeKey = 'selected_currency_code';
  static const String _themeModeKey = 'theme_mode';
  static String _cachedCurrencyCode = 'USD';
  static String _cachedThemeMode = 'system';
  
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedCurrencyCode = prefs.getString(_currencyCodeKey) ?? 'USD';
      _cachedThemeMode = prefs.getString(_themeModeKey) ?? 'system';
    } catch (_) {
      _cachedCurrencyCode = 'USD';
      _cachedThemeMode = 'system';
    }
  }

  static String getCurrencyCodeSync() {
    return _cachedCurrencyCode;
  }

  static Future<String?> getCurrencyCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedCurrencyCode = prefs.getString(_currencyCodeKey) ?? 'USD';
      return _cachedCurrencyCode;
    } catch (e) {
      print('Error getting currency code: $e');
      _cachedCurrencyCode = 'USD';
      return _cachedCurrencyCode;
    }
  }

  static Future<void> setCurrencyCode(String currencyCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyCodeKey, currencyCode);
      _cachedCurrencyCode = currencyCode;
      print('Currency saved: $currencyCode');
    } catch (e) {
      print('Error saving currency code: $e');
    }
  }

  // Theme settings
  static String getThemeModeSync() {
    return _cachedThemeMode;
  }

  static Future<String?> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedThemeMode = prefs.getString(_themeModeKey) ?? 'system';
      return _cachedThemeMode;
    } catch (e) {
      print('Error getting theme mode: $e');
      _cachedThemeMode = 'system';
      return _cachedThemeMode;
    }
  }

  static Future<void> setThemeMode(String themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, themeMode);
      _cachedThemeMode = themeMode;
      print('Theme mode saved: $themeMode');
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }
} 