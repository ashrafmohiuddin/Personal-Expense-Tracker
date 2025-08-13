import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';
import '../../domain/models/transaction.dart';
import '../../data/repositories/transaction_repository.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/filter_bottom_sheet.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen>
    with AutomaticKeepAliveClientMixin {
  TransactionType? _selectedFilter;
  String _searchQuery = '';
  DateTimeRange? _dateRange;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final transactionsAsync = ref.watch(
      transactionRepositoryProvider.select((repo) {
        if (_selectedFilter != null) {
          return repo.watchTransactionsByType(_selectedFilter!);
        }
        return repo.watchAllTransactions();
      }),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Transactions'),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterBottomSheet,
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacing16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppTokens.spacing16),
                
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTokens.radius),
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.3),
                const SizedBox(height: AppTokens.spacing16),

                // Filter Segments
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTokens.spacing8),
                    child: SegmentedButton<TransactionType?>(
                      segments: const [
                        ButtonSegment(
                          value: null,
                          label: Text('All'),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Income'),
                        ),
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Expense'),
                        ),
                      ],
                      selected: {_selectedFilter},
                      onSelectionChanged: (Set<TransactionType?> selection) {
                        setState(() {
                          _selectedFilter = selection.first;
                        });
                      },
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.3),
                const SizedBox(height: AppTokens.spacing16),
              ]),
            ),
          ),
          
          // Transactions List
          transactionsAsync.when(
            data: (transactions) {
              final filteredTransactions = transactions.where((transaction) {
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  return transaction.category.toLowerCase().contains(query) ||
                         (transaction.merchant?.toLowerCase().contains(query) ?? false) ||
                         (transaction.note?.toLowerCase().contains(query) ?? false);
                }
                return true;
              }).toList();

              if (filteredTransactions.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No transactions found'),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final transaction = filteredTransactions[index];
                    return TransactionListItem(
                      transaction: transaction,
                      onEdit: () => context.go('/edit/${transaction.id}'),
                      onDelete: () => _deleteTransaction(transaction),
                    ).animate().fadeIn().slideX(begin: 0.3);
                  },
                  childCount: filteredTransactions.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterBottomSheet(
        dateRange: _dateRange,
        onDateRangeChanged: (range) {
          setState(() {
            _dateRange = range;
          });
        },
      ),
    );
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      final repository = ref.read(transactionRepositoryProvider.notifier);
      await repository.deleteTransaction(transaction.id!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await repository.addTransaction(transaction);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting transaction: $e')),
        );
      }
    }
  }
}
