import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../design/app_card.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';
import '../../domain/models/asset.dart';
import '../../data/repositories/asset_repository.dart';
import '../widgets/add_asset_bottom_sheet.dart';
import '../widgets/asset_list_item.dart';

class AssetsScreen extends ConsumerStatefulWidget {
  const AssetsScreen({super.key});

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final totalAssets = ref.watch(assetRepositoryProvider
        .select((repo) => repo.watchTotalAssets()));
    final monthlyIncome = ref.watch(assetRepositoryProvider
        .select((repo) => repo.watchMonthlyIncome()));
    final recurringAssets = ref.watch(assetRepositoryProvider
        .select((repo) => repo.watchRecurringAssets()));
    final allAssets = ref.watch(assetRepositoryProvider
        .select((repo) => repo.watchAllAssets()));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Assets & Income'),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddAssetBottomSheet,
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Totals Row
                Row(
                  children: [
                    Expanded(
                      child: totalAssets.when(
                        data: (assets) => _buildTotalCard(
                          context,
                          'Total Assets',
                          Formatters.formatCurrency(assets),
                          Icons.account_balance,
                        ),
                        loading: () => _buildTotalCard(
                          context,
                          'Total Assets',
                          'Loading...',
                          Icons.account_balance,
                        ),
                        error: (_, __) => _buildTotalCard(
                          context,
                          'Total Assets',
                          'Error',
                          Icons.account_balance,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTokens.spacing16),
                    Expanded(
                      child: monthlyIncome.when(
                        data: (income) => _buildTotalCard(
                          context,
                          'Monthly Income',
                          Formatters.formatCurrency(income),
                          Icons.trending_up,
                          color: Colors.green,
                        ),
                        loading: () => _buildTotalCard(
                          context,
                          'Monthly Income',
                          'Loading...',
                          Icons.trending_up,
                        ),
                        error: (_, __) => _buildTotalCard(
                          context,
                          'Monthly Income',
                          'Error',
                          Icons.trending_up,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: 0.3),
                const SizedBox(height: AppTokens.spacing24),

                // Recurring Income Section
                Text(
                  'Recurring Income',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                recurringAssets.when(
                  data: (assets) => _buildAssetsList(assets, 'No recurring income'),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Error loading assets')),
                ).animate().fadeIn().slideX(begin: 0.3),
                const SizedBox(height: AppTokens.spacing24),

                // All Assets Section
                Text(
                  'All Assets',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().fadeIn().slideX(begin: -0.3),
                const SizedBox(height: AppTokens.spacing16),
                
                allAssets.when(
                  data: (assets) => _buildAssetsList(assets, 'No assets found'),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Error loading assets')),
                ).animate().fadeIn().slideX(begin: 0.3),
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
    String value,
    IconData icon, {
    Color? color,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color ?? Theme.of(context).colorScheme.primary,
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
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(List<Asset> assets, String emptyMessage) {
    if (assets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spacing32),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppTokens.spacing16),
              Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: assets.map((asset) {
        return AssetListItem(
          asset: asset,
          onEdit: () => _editAsset(asset),
          onDelete: () => _deleteAsset(asset),
        );
      }).toList(),
    );
  }

  void _showAddAssetBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddAssetBottomSheet(),
    );
  }

  void _editAsset(Asset asset) {
    // TODO: Implement edit asset functionality
  }

  Future<void> _deleteAsset(Asset asset) async {
    try {
      final repository = ref.read(assetRepositoryProvider.notifier);
      await repository.deleteAsset(asset.id!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Asset deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await repository.addAsset(asset);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting asset: $e')),
        );
      }
    }
  }
}
