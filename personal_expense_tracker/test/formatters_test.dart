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

      test('formats large numbers correctly', () {
        expect(Formatters.formatCurrency(1000000), '₹1,000,000.00');
      });
    });

    group('formatDate', () {
      test('formats date correctly', () {
        final date = DateTime(2024, 1, 15);
        expect(Formatters.formatDate(date), 'Jan 15, 2024');
      });

      test('formats different months correctly', () {
        final date = DateTime(2024, 12, 25);
        expect(Formatters.formatDate(date), 'Dec 25, 2024');
      });
    });

    group('storageDate', () {
      test('formats date for storage correctly', () {
        final date = DateTime(2024, 1, 15);
        expect(Formatters.storageDate(date), '2024-01-15');
      });

      test('formats date with single digits correctly', () {
        final date = DateTime(2024, 5, 5);
        expect(Formatters.storageDate(date), '2024-05-05');
      });
    });

    group('parseStorageDate', () {
      test('parses storage date correctly', () {
        final date = Formatters.parseStorageDate('2024-01-15');
        expect(date, DateTime(2024, 1, 15));
      });

      test('parses date with single digits correctly', () {
        final date = Formatters.parseStorageDate('2024-05-05');
        expect(date, DateTime(2024, 5, 5));
      });
    });

    group('formatNumber', () {
      test('formats number with grouping separators', () {
        expect(Formatters.formatNumber(1234.56), '1,234.56');
      });

      test('formats zero correctly', () {
        expect(Formatters.formatNumber(0), '0.00');
      });

      test('formats large numbers correctly', () {
        expect(Formatters.formatNumber(1000000), '1,000,000.00');
      });
    });

    group('formatPercentage', () {
      test('formats percentage correctly', () {
        expect(Formatters.formatPercentage(0.1234), '12.3%');
      });

      test('formats zero percentage correctly', () {
        expect(Formatters.formatPercentage(0), '0.0%');
      });

      test('formats 100% correctly', () {
        expect(Formatters.formatPercentage(1), '100.0%');
      });
    });
  });
}
