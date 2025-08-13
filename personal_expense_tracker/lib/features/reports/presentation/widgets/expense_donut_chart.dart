import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../../transactions/domain/models/transaction.dart';

class ExpenseDonutChart extends ConsumerWidget {
  const ExpenseDonutChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchAllTransactions()));

    return transactions.when(
      data: (transactionList) {
        final expenses = transactionList
            .where((t) => t.type == TransactionType.expense)
            .toList();

        if (expenses.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(AppTokens.spacing32),
              child: Center(
                child: Text('No expense data available'),
              ),
            ),
          );
        }

        final categoryData = _groupByCategory(expenses);
        final totalExpenses = expenses.fold(0.0, (sum, t) => sum + t.amount);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _buildSections(categoryData, totalExpenses),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: AppTokens.spacing16),
                _buildLegend(categoryData, totalExpenses),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(AppTokens.spacing32),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const Card(
        child: Padding(
          padding: EdgeInsets.all(AppTokens.spacing32),
          child: Center(child: Text('Error loading data')),
        ),
      ),
    );
  }

  Map<String, double> _groupByCategory(List<Transaction> expenses) {
    final Map<String, double> categoryData = {};
    for (final expense in expenses) {
      categoryData[expense.category] = 
          (categoryData[expense.category] ?? 0) + expense.amount;
    }
    return categoryData;
  }

  List<PieChartSectionData> _buildSections(
    Map<String, double> categoryData,
    double total,
  ) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    int colorIndex = 0;
    return categoryData.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> categoryData, double total) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    int colorIndex = 0;
    return Column(
      children: categoryData.entries.map((entry) {
        final percentage = (entry.value / total) * 100;
        final color = colors[colorIndex % colors.length];
        colorIndex++;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTokens.spacing4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppTokens.spacing8),
              Expanded(
                child: Text(
                  entry.key,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                Formatters.formatCurrency(entry.value),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: AppTokens.spacing8),
              Text(
                '(${percentage.toStringAsFixed(1)}%)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
