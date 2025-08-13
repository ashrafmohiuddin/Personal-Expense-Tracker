import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:personal_expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:personal_expense_tracker/design/app_theme.dart';

void main() {
  group('TransactionListItem Golden Tests', () {
    testWidgets('Income transaction item renders correctly', (WidgetTester tester) async {
      final transaction = Transaction(
        id: '1',
        type: TransactionType.income,
        amount: 50000.0,
        category: 'Salary',
        merchant: 'Company Inc.',
        date: DateTime(2024, 1, 15),
        note: 'Monthly salary payment',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: TransactionListItem(
              transaction: transaction,
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TransactionListItem),
        matchesGoldenFile('transaction_list_item_income.png'),
      );
    });

    testWidgets('Expense transaction item renders correctly', (WidgetTester tester) async {
      final transaction = Transaction(
        id: '2',
        type: TransactionType.expense,
        amount: 1200.0,
        category: 'Food & Dining',
        merchant: 'Grocery Store',
        date: DateTime(2024, 1, 15),
        note: 'Weekly groceries',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: TransactionListItem(
              transaction: transaction,
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TransactionListItem),
        matchesGoldenFile('transaction_list_item_expense.png'),
      );
    });
  });
}
