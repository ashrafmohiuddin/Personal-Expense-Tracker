import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';
import '../utils/animations.dart';
import '../models/transaction.dart';
import 'summary_screen.dart';
import 'assets_screen.dart';
import 'transactions_screen.dart';
import 'add_expense_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _onTitleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!).inSeconds > 3) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    _lastTapTime = now;

    if (_tapCount >= 5) {
      _tapCount = 0;
      _showHiddenMenu();
    }
  }

  void _showHiddenMenu() {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final now = DateTime.now();
          final weekStart = Formatters.getWeekStart(now);
          final weekEnd = Formatters.getWeekEnd(now);
          final monthStart = Formatters.getMonthStart(now);
          final monthEnd = Formatters.getMonthEnd(now);

          final weeklyExpenses = provider.getTotalExpenses(weekStart, weekEnd);
          final monthlyExpenses = provider.getTotalExpenses(monthStart, monthEnd);
          final weeklyIncome = provider.getTotalIncome(weekStart, weekEnd);
          final monthlyIncome = provider.getTotalIncome(monthStart, monthEnd);
          final recentTransactions = provider.recentTransactions;
          final totalAssets = provider.totalAssetsValue;
          final recurringIncome = provider.recurringMonthlyIncome;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: GestureDetector(
                    onTap: _onTitleTap,
                    child: Text(
                      'Personal Finance',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).colorScheme.surface,
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.analytics, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      Navigator.pushNamed(context, '/summary');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.account_balance_wallet, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      Navigator.pushNamed(context, '/assets');
                    },
                  ),
                ],
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Welcome Card
                    _buildWelcomeCard(context),
                    const SizedBox(height: 20),

                    // Quick Stats Cards
                    _buildQuickStatsCards(
                      context,
                      weeklyExpenses,
                      monthlyExpenses,
                      weeklyIncome,
                      monthlyIncome,
                    ),
                    const SizedBox(height: 20),

                    // Assets Overview Card
                    _buildAssetsOverviewCard(context, totalAssets, recurringIncome),
                    const SizedBox(height: 20),

                    // Recent Transactions Section
                    _buildRecentTransactionsSection(context, recentTransactions),
                    const SizedBox(height: 20),

                    // Quick Actions Card
                    _buildQuickActionsCard(context),
                    const SizedBox(height: 20),

                    // Category Breakdown Card
                    _buildCategoryBreakdownCard(context, provider, monthStart, monthEnd),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Track your finances with ease',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Today',
                    Formatters.formatDate(DateTime.now()),
                    Icons.today,
                    AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Balance',
                    'Positive',
                    Icons.trending_up,
                    AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsCards(
    BuildContext context,
    double weeklyExpenses,
    double monthlyExpenses,
    double weeklyIncome,
    double monthlyIncome,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.deepBlack,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SummaryScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
                  ),
                  child: _buildStatCard(
                    context,
                    'Weekly',
                    weeklyExpenses,
                    weeklyIncome,
                    AppTheme.primaryGreen,
                    Icons.calendar_today,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SummaryScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.2)),
                  ),
                  child: _buildStatCard(
                    context,
                    'Monthly',
                    monthlyExpenses,
                    monthlyIncome,
                    AppTheme.primaryOrange,
                    Icons.calendar_month,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssetsOverviewCard(BuildContext context, double totalAssets, double recurringIncome) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AssetsScreen()),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primarySand.withOpacity(0.3),
                AppTheme.primaryOrange.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: AppTheme.primaryOrange, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Assets Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, color: AppTheme.mediumGray, size: 16),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  _buildAssetStat(
                    context,
                    'Total Assets',
                    Formatters.formatCurrency(totalAssets),
                    AppTheme.primaryGreen,
                  ),
                  const SizedBox(height: 12),
                  _buildAssetStat(
                    context,
                    'Monthly Income',
                    Formatters.formatCurrency(recurringIncome),
                    AppTheme.primaryOrange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context, List<Transaction> recentTransactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.deepBlack,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionsScreen()),
                );
              },
              icon: Icon(Icons.arrow_forward, size: 16),
              label: const Text('View All'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (recentTransactions.isEmpty)
          _buildEmptyState(context)
        else
          ...recentTransactions.take(5).map((transaction) => 
            _buildTransactionCard(context, transaction)
          ),
      ],
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryGreen.withOpacity(0.1),
              AppTheme.primarySand.withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Add Expense',
                    Icons.add,
                    AppTheme.primaryOrange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'View Reports',
                    Icons.analytics,
                    AppTheme.primaryGreen,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SummaryScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdownCard(BuildContext context, ExpenseProvider provider, DateTime start, DateTime end) {
    final expensesByCategory = provider.getExpensesByCategory(start, end);
    final topCategories = expensesByCategory.entries.take(3).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryOrange.withOpacity(0.1),
              AppTheme.primarySand.withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Spending Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 16),
            if (topCategories.isEmpty)
              Text(
                'No spending data available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              )
            else
              ...topCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final color = AppConstants.chartColors[index % AppConstants.chartColors.length];
                return _buildCategoryItem(
                  context,
                  category.key,
                  category.value,
                  Color(color),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.deepBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String period,
    double expenses,
    double income,
    Color color,
    IconData icon,
  ) {
    final net = income - expenses;
    final isPositive = net >= 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  period,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              Formatters.formatCurrency(expenses),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Expenses',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppTheme.primaryGreen : AppTheme.primaryOrange,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  Formatters.formatCurrency(net.abs()),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isPositive ? AppTheme.primaryGreen : AppTheme.primaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetStat(BuildContext context, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction transaction) {
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? AppTheme.primaryOrange : AppTheme.primaryGreen;
    final icon = isExpense ? Icons.remove : Icons.add;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.white,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  if (transaction.trip != null) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primarySand.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        transaction.trip!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primarySand,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isExpense ? '-' : '+'}${Formatters.formatCurrency(transaction.amount)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatRelativeDate(transaction.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppTheme.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category, double amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.deepBlack,
              ),
            ),
          ),
          Text(
            Formatters.formatCurrency(amount),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.white,
        ),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: AppTheme.mediumGray,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first expense or income to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Transaction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 