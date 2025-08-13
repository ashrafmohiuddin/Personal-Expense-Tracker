import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../widgets/period_selector.dart';
import '../widgets/expense_donut_chart.dart';
import '../widgets/income_expense_bar_chart.dart';

enum ReportPeriod {
  thisWeek,
  thisMonth,
  custom,
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with AutomaticKeepAliveClientMixin {
  ReportPeriod _selectedPeriod = ReportPeriod.thisMonth;
  DateTimeRange? _customDateRange;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final income = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchTotalIncome()));
    final expenses = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchTotalExpenses()));
    final netBalance = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchNetBalance()));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Reports'),
            floating: true,
            snap: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.spacing16,
                  vertical: AppTokens.spacing8,
                ),
                child: PeriodSelector(
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Totals Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildTotalCard(
                        context,
                        'Income',
                        income,
                        Colors.green,
                        Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: AppTokens.spacing12),
                    Expanded(
                      child: _buildTotalCard(
                        context,
                        'Expenses',
                        expenses,
                        Colors.red,
                        Icons.trending_down,
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: 0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                // Net Savings Card
                _buildTotalCard(
                  context,
                  'Net Savings',
                  netBalance,
                  null,
                  Icons.account_balance_wallet,
                  isLarge: true,
                ).animate().fadeIn().slideY(begin: 0.3),
                const SizedBox(height: AppTokens.spacing24),

                // Charts Section
                Text(
                  'Expenses by Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                const ExpenseDonutChart().animate().fadeIn().slideX(begin: 0.3),
                const SizedBox(height: AppTokens.spacing24),

                Text(
                  'Income vs Expenses',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                const IncomeExpenseBarChart().animate().fadeIn().slideX(begin: 0.3),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(
    BuildContext context,
    String title,
    AsyncValue<double> value,
    Color? color,
    IconData icon, {
    bool isLarge = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color ?? Theme.of(context).colorScheme.primary,
                  size: isLarge ? 24 : 20,
                ),
                const SizedBox(width: AppTokens.spacing8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.spacing8),
            value.when(
              data: (amount) => Text(
                Formatters.formatCurrency(amount.abs()),
                style: (isLarge ? Theme.of(context).textTheme.displayLarge : Theme.of(context).textTheme.titleLarge)?.copyWith(
                  color: color ?? (amount >= 0 ? Colors.green : Colors.red),
                  fontWeight: FontWeight.w700,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(
                'Error',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
