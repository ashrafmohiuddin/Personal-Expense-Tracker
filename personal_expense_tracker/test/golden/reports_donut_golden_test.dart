import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:personal_expense_tracker/features/reports/presentation/widgets/expense_donut_chart.dart';
import 'package:personal_expense_tracker/design/app_theme.dart';

void main() {
  group('ExpenseDonutChart Golden Tests', () {
    testWidgets('Donut chart renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ExpenseDonutChart(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ExpenseDonutChart),
        matchesGoldenFile('expense_donut_chart.png'),
      );
    });

    testWidgets('Donut chart with dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: ExpenseDonutChart(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ExpenseDonutChart),
        matchesGoldenFile('expense_donut_chart_dark.png'),
      );
    });
  });
}
