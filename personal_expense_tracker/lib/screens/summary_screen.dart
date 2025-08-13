import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import '../theme/app_theme.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String selectedPeriod = 'This Month';
  final List<String> periods = ['This Week', 'This Month', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Financial Summary',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final now = DateTime.now();
          DateTime startDate, endDate;

          switch (selectedPeriod) {
            case 'This Week':
              startDate = Formatters.getWeekStart(now);
              endDate = Formatters.getWeekEnd(now);
              break;
            case 'This Year':
              startDate = DateTime(now.year, 1, 1);
              endDate = DateTime(now.year, 12, 31);
              break;
            default: // This Month
              startDate = Formatters.getMonthStart(now);
              endDate = Formatters.getMonthEnd(now);
          }

          final expenses = provider.getTotalExpenses(startDate, endDate);
          final income = provider.getTotalIncome(startDate, endDate);
          final netSavings = income - expenses;
          final expensesByCategory = provider.getExpensesByCategory(startDate, endDate);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selector
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Period',
                          style: AppTheme.subheadingStyle(context),
                        ),
                        const SizedBox(height: AppTheme.paddingSmall),
                        DropdownButtonFormField<String>(
                          value: selectedPeriod,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: periods.map((period) {
                            return DropdownMenuItem(
                              value: period,
                              child: Text(period),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPeriod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Income',
                        Formatters.formatCurrency(income),
                        Icons.trending_up,
                        AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: AppTheme.paddingSmall),
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Expenses',
                        Formatters.formatCurrency(expenses),
                        Icons.trending_down,
                        AppTheme.primaryOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Net Savings Card
                _buildSummaryCard(
                  'Net Savings',
                  Formatters.formatCurrency(netSavings),
                  netSavings >= 0 ? Icons.savings : Icons.warning,
                  netSavings >= 0 ? AppTheme.primaryGreen : AppTheme.red,
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Expenses by Category Chart
                if (expensesByCategory.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                                                      Text(
                              'Expenses by Category',
                              style: AppTheme.subheadingStyle(context),
                            ),
                          const SizedBox(height: AppTheme.paddingMedium),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: _buildPieChartSections(expensesByCategory),
                                centerSpaceRadius: 40,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.paddingMedium),
                          _buildCategoryLegend(expensesByCategory),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                ],

                // Income vs Expenses Bar Chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                                  Text(
                            'Income vs Expenses',
                            style: AppTheme.subheadingStyle(context),
                          ),
                        const SizedBox(height: AppTheme.paddingMedium),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: (income > expenses ? income : expenses) * 1.2,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text('Income');
                                        case 1:
                                          return const Text('Expenses');
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        Formatters.formatCurrency(value),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: income,
                                      color: AppTheme.primaryGreen,
                                      width: 40,
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: expenses,
                                      color: AppTheme.primaryOrange,
                                      width: 40,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: AppTheme.paddingSmall),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.paddingSmall),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> expensesByCategory) {
    final colors = [
      AppTheme.primaryGreen,
      AppTheme.primaryOrange,
      AppTheme.primarySand,
      AppTheme.blue,
      AppTheme.red,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];

    final total = expensesByCategory.values.fold(0.0, (sum, amount) => sum + amount);
    final sections = <PieChartSectionData>[];

    int colorIndex = 0;
    expensesByCategory.forEach((category, amount) {
      final percentage = total > 0 ? (amount / total) * 100 : 0;
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.white,
          ),
        ),
      );
      colorIndex++;
    });

    return sections;
  }

  Widget _buildCategoryLegend(Map<String, double> expensesByCategory) {
    final colors = [
      AppTheme.primaryGreen,
      AppTheme.primaryOrange,
      AppTheme.primarySand,
      AppTheme.blue,
      AppTheme.red,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];

    return Column(
      children: expensesByCategory.entries.map((entry) {
        final index = expensesByCategory.keys.toList().indexOf(entry.key);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppTheme.paddingSmall),
              Expanded(
                child: Text(
                  entry.key,
                  style: AppTheme.bodyStyle(context),
                ),
              ),
              Text(
                Formatters.formatCurrency(entry.value),
                style: AppTheme.bodyStyle(context),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
} 