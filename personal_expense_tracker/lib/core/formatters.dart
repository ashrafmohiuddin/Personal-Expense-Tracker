import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final DateFormat _dateFormatter = DateFormat.yMMMd('en_US');
  static final DateFormat _storageDateFormatter = DateFormat('yyyy-MM-dd');

  /// Formats a number as currency with ₹ symbol and 2 decimal places
  static String formatCurrency(num amount) {
    return _currencyFormatter.format(amount);
  }

  /// Formats a DateTime using locale-specific format (e.g., "Jan 15, 2024")
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Formats a DateTime for storage as yyyy-MM-dd
  static String storageDate(DateTime date) {
    return _storageDateFormatter.format(date);
  }

  /// Parses a storage date string back to DateTime
  static DateTime parseStorageDate(String dateString) {
    return _storageDateFormatter.parse(dateString);
  }

  /// Formats a number with grouping separators (e.g., "1,234.56")
  static String formatNumber(num value) {
    return NumberFormat('#,##0.00').format(value);
  }

  /// Formats a percentage with 1 decimal place
  static String formatPercentage(double value) {
    return NumberFormat.decimalPercentPattern(decimalDigits: 1).format(value);
  }
}
