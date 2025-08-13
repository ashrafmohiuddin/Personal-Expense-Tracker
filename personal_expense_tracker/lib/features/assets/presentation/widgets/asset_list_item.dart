import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';
import '../../domain/models/asset.dart';

class AssetListItem extends StatelessWidget {
  const AssetListItem({
    super.key,
    required this.asset,
    required this.onEdit,
    required this.onDelete,
  });

  final Asset asset;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTokens.spacing8),
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppTokens.spacing16),
            leading: CircleAvatar(
              backgroundColor: _getAssetTypeColor(asset.type).withOpacity(0.1),
              child: Icon(
                _getAssetTypeIcon(asset.type),
                color: _getAssetTypeColor(asset.type),
                size: 20,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    asset.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (asset.isRecurring)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTokens.spacing8,
                      vertical: AppTokens.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Recurring',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      Formatters.formatCurrency(asset.amount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: AppTokens.spacing8),
                    Text(
                      asset.type.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                if (asset.description != null) ...[
                  const SizedBox(height: AppTokens.spacing4),
                  Text(
                    asset.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAssetTypeColor(AssetType type) {
    switch (type) {
      case AssetType.salary:
        return Colors.green;
      case AssetType.investment:
        return Colors.blue;
      case AssetType.savings:
        return Colors.orange;
      case AssetType.other:
        return Colors.grey;
    }
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.salary:
        return Icons.work;
      case AssetType.investment:
        return Icons.trending_up;
      case AssetType.savings:
        return Icons.account_balance;
      case AssetType.other:
        return Icons.category;
    }
  }
}
