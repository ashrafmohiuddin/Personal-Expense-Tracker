import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../design/app_card.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../../assets/data/repositories/asset_repository.dart';
import '../../presentation/widgets/hero_card.dart';
import '../../presentation/widgets/quick_overview_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netBalance = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchNetBalance()));
    final weeklyIncome = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchWeeklyIncome()));
    final weeklyExpenses = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchWeeklyExpenses()));
    final monthlyIncome = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchMonthlyIncome()));
    final monthlyExpenses = ref.watch(transactionRepositoryProvider
        .select((repo) => repo.watchMonthlyExpenses()));
    final totalAssets = ref.watch(assetRepositoryProvider
        .select((repo) => repo.watchTotalAssets()));
    final monthlyRecurringIncome = ref.watch(assetRepositoryProvider
        .select((repo) => repo.watchMonthlyIncome()));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Personal Finance'),
            floating: true,
            snap: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hero Card
                netBalance.when(
                  data: (balance) => HeroCard(
                    title: 'Today',
                    subtitle: 'Net Balance',
                    amount: balance,
                    onTap: () => context.go('/reports'),
                  ).animate().fadeIn().slideY(begin: 0.3),
                  loading: () => const HeroCard(
                    title: 'Today',
                    subtitle: 'Net Balance',
                    amount: 0,
                  ),
                  error: (_, __) => const HeroCard(
                    title: 'Today',
                    subtitle: 'Net Balance',
                    amount: 0,
                  ),
                ),
                const SizedBox(height: AppTokens.spacing24),

                // Quick Overview Cards
                Row(
                  children: [
                    Expanded(
                      child: weeklyIncome.when(
                        data: (income) => weeklyExpenses.when(
                          data: (expenses) => QuickOverviewCard(
                            title: 'Weekly',
                            income: income,
                            expenses: expenses,
                            onTap: () => context.go('/reports?period=week'),
                          ),
                          loading: () => const QuickOverviewCard(
                            title: 'Weekly',
                            income: 0,
                            expenses: 0,
                          ),
                          error: (_, __) => const QuickOverviewCard(
                            title: 'Weekly',
                            income: 0,
                            expenses: 0,
                          ),
                        ),
                        loading: () => const QuickOverviewCard(
                          title: 'Weekly',
                          income: 0,
                          expenses: 0,
                        ),
                        error: (_, __) => const QuickOverviewCard(
                          title: 'Weekly',
                          income: 0,
                          expenses: 0,
                        ),
                      ).animate().fadeIn().slideX(begin: -0.3),
                    ),
                    const SizedBox(width: AppTokens.spacing12),
                    Expanded(
                      child: monthlyIncome.when(
                        data: (income) => monthlyExpenses.when(
                          data: (expenses) => QuickOverviewCard(
                            title: 'Monthly',
                            income: income,
                            expenses: expenses,
                            onTap: () => context.go('/reports?period=month'),
                          ),
                          loading: () => const QuickOverviewCard(
                            title: 'Monthly',
                            income: 0,
                            expenses: 0,
                          ),
                          error: (_, __) => const QuickOverviewCard(
                            title: 'Monthly',
                            income: 0,
                            expenses: 0,
                          ),
                        ),
                        loading: () => const QuickOverviewCard(
                          title: 'Monthly',
                          income: 0,
                          expenses: 0,
                        ),
                        error: (_, __) => const QuickOverviewCard(
                          title: 'Monthly',
                          income: 0,
                          expenses: 0,
                        ),
                      ).animate().fadeIn().slideX(begin: 0.3),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.spacing24),

                // Assets Summary
                AppCard(
                  leadingIcon: Icons.account_balance_wallet,
                  onTap: () => context.go('/assets'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assets & Income',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppTokens.spacing12),
                      Row(
                        children: [
                          Expanded(
                            child: totalAssets.when(
                              data: (assets) => _buildSummaryItem(
                                context,
                                'Total Assets',
                                Formatters.formatCurrency(assets),
                                Icons.account_balance,
                              ),
                              loading: () => _buildSummaryItem(
                                context,
                                'Total Assets',
                                'Loading...',
                                Icons.account_balance,
                              ),
                              error: (_, __) => _buildSummaryItem(
                                context,
                                'Total Assets',
                                'Error',
                                Icons.account_balance,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTokens.spacing16),
                          Expanded(
                            child: monthlyRecurringIncome.when(
                              data: (income) => _buildSummaryItem(
                                context,
                                'Monthly Income',
                                Formatters.formatCurrency(income),
                                Icons.trending_up,
                                color: Colors.green,
                              ),
                              loading: () => _buildSummaryItem(
                                context,
                                'Monthly Income',
                                'Loading...',
                                Icons.trending_up,
                              ),
                              error: (_, __) => _buildSummaryItem(
                                context,
                                'Monthly Income',
                                'Error',
                                Icons.trending_up,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.3),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppTokens.spacing4),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTokens.spacing4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
