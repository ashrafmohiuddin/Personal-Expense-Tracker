import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/asset.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets & Income'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAssetDialog(context),
          ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final assets = provider.assets;
          final totalAssets = provider.totalAssetsValue;
          final recurringIncome = provider.recurringMonthlyIncome;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards - Always stacked to prevent overflow
                _buildSummaryCard(
                  context,
                  'Total Assets',
                  totalAssets,
                  AppTheme.primaryGreen,
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  context,
                  'Monthly Income',
                  recurringIncome,
                  AppTheme.primaryOrange,
                  Icons.trending_up,
                ),
                const SizedBox(height: 24),

                // Assets List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Assets',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => _showAddAssetDialog(context),
                      child: const Text('Add Asset'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (assets.isEmpty)
                  _buildEmptyState(context)
                else
                  ...assets.map((asset) => _buildAssetCard(context, asset, provider)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.deepBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.formatCurrency(amount),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, Asset asset, ExpenseProvider provider) {
    final color = asset.isRecurring ? AppTheme.primaryGreen : AppTheme.primarySand;
    final icon = asset.isRecurring ? Icons.repeat : Icons.account_balance_wallet;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Slidable(
      key: ValueKey('asset_${asset.id ?? asset.name}'),
              endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.35,
          children: [
            SlidableAction(
              onPressed: (_) => _showEditAssetDialog(context, asset),
              backgroundColor: AppTheme.primarySand,
              foregroundColor: AppTheme.deepBlack,
              icon: Icons.edit,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) => _deleteAsset(context, asset, provider),
              backgroundColor: Colors.red.shade400,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      asset.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      asset.type.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (asset.description != null && asset.description!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        asset.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (asset.isRecurring) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Recurring Monthly',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  Formatters.formatCurrency(asset.amount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: AppTheme.mediumGray,
            ),
            const SizedBox(height: 16),
            Text(
              'No assets yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your income sources and assets to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddAssetDialog(context),
              child: const Text('Add Asset'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAssetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AssetDialog();
      },
    );
  }

  void _showEditAssetDialog(BuildContext context, Asset asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AssetDialog(asset: asset);
      },
    );
  }

  void _deleteAsset(BuildContext context, Asset asset, ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Asset'),
          content: Text(
            'Are you sure you want to delete "${asset.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await provider.deleteAsset(asset.id!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Asset deleted successfully'),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error deleting asset'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class AssetDialog extends StatefulWidget {
  final Asset? asset;

  const AssetDialog({super.key, this.asset});

  @override
  State<AssetDialog> createState() => _AssetDialogState();
}

class _AssetDialogState extends State<AssetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  AssetType _selectedType = AssetType.salary;
  bool _isRecurring = false;
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      _nameController.text = widget.asset!.name;
      _amountController.text = widget.asset!.amount.toString();
      _descriptionController.text = widget.asset!.description ?? '';
      _selectedType = widget.asset!.type;
      _isRecurring = widget.asset!.isRecurring;
      _startDate = widget.asset!.startDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _saveAsset() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    final asset = Asset(
      id: widget.asset?.id,
      name: name,
      amount: amount,
      type: _selectedType,
      description: description.isNotEmpty ? description : null,
      startDate: _startDate,
      isRecurring: _isRecurring,
    );

    try {
      if (widget.asset == null) {
        await context.read<ExpenseProvider>().addAsset(asset);
      } else {
        await context.read<ExpenseProvider>().updateAsset(asset);
      }
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Asset ${widget.asset == null ? 'added' : 'updated'} successfully'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${widget.asset == null ? 'adding' : 'updating'} asset'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.asset == null ? 'Add Asset' : 'Edit Asset'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Asset Name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AssetType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Asset Type',
                ),
                items: AssetType.values.map((AssetType type) {
                  return DropdownMenuItem<AssetType>(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (AssetType? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Recurring Monthly'),
                value: _isRecurring,
                onChanged: (bool? value) {
                  setState(() {
                    _isRecurring = value ?? false;
                  });
                },
              ),
              if (_isRecurring) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Date (Optional)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _startDate != null
                          ? Formatters.formatDate(_startDate!)
                          : 'Select date',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAsset,
          child: Text(widget.asset == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
} 