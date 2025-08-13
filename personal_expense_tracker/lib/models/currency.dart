class Currency {
  final String code;
  final String symbol;
  final String name;
  final double exchangeRate; // Relative to USD

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.exchangeRate,
  });

  static const List<Currency> availableCurrencies = [
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar', exchangeRate: 1.0),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee', exchangeRate: 83.0),
    Currency(code: 'EUR', symbol: '€', name: 'Euro', exchangeRate: 0.92),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound', exchangeRate: 0.79),
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', exchangeRate: 150.0),
    Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', exchangeRate: 1.35),
    Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', exchangeRate: 1.52),
    Currency(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc', exchangeRate: 0.88),
  ];

  static Currency getDefault() => availableCurrencies.first;

  static Currency? fromCode(String code) {
    try {
      return availableCurrencies.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }

  String formatAmount(double amount) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  double convertFromUSD(double usdAmount) {
    return usdAmount * exchangeRate;
  }

  double convertToUSD(double amount) {
    return amount / exchangeRate;
  }
} 
