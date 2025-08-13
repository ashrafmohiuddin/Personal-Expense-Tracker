import 'package:flutter/material.dart';
import '../../../../design/tokens.dart';
import '../../../../core/seed.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    this.dateRange,
    required this.onDateRangeChanged,
  });

  final DateTimeRange? dateRange;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.dateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.spacing16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.spacing24),

          // Date Range Section
          Text(
            'Date Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTokens.spacing12),
          Wrap(
            spacing: AppTokens.spacing8,
            children: [
              _buildDateChip('This Week', _getThisWeek()),
              _buildDateChip('This Month', _getThisMonth()),
              _buildDateChip('Last Month', _getLastMonth()),
              _buildDateChip('Custom', null, isCustom: true),
            ],
          ),
          const SizedBox(height: AppTokens.spacing24),

          // Category Section
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTokens.spacing12),
          Wrap(
            spacing: AppTokens.spacing8,
            children: [
              _buildCategoryChip('All', null),
              ...SeedData.defaultCategories.map(
                (category) => _buildCategoryChip(category, category),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.spacing24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                widget.onDateRangeChanged(_selectedDateRange);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(String label, DateTimeRange? range, {bool isCustom = false}) {
    final isSelected = _selectedDateRange == range;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (isCustom) {
          _selectCustomDateRange();
        } else {
          setState(() {
            _selectedDateRange = selected ? range : null;
          });
        }
      },
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
    );
  }

  Future<void> _selectCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  DateTimeRange _getThisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 6));
    return DateTimeRange(start: start, end: end);
  }

  DateTimeRange _getThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return DateTimeRange(start: start, end: end);
  }

  DateTimeRange _getLastMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, 1);
    final end = DateTime(now.year, now.month, 0);
    return DateTimeRange(start: start, end: end);
  }
}
