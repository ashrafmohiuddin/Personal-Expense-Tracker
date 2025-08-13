import 'package:flutter/material.dart';
import '../../../../design/app_card.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';

class QuickOverviewCard extends StatelessWidget {
  const QuickOverviewCard({
    super.key,
    required this.title,
    required this.income,
    required this.expenses,
    this.onTap,
  });

  final String title;
  final double income;
  final double expenses;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final net = income - expenses;
    final isPositive = net >= 0;
    final deltaColor = isPositive ? Colors.green : Colors.red;
    final deltaIcon = isPositive ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  Icon(
                    deltaIcon,
                    color: deltaColor,
                    size: 16,
                  ),
                  Text(
                    Formatters.formatCurrency(net.abs()),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: deltaColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTokens.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildAmountItem(
                  context,
                  'Income',
                  income,
                  Colors.green,
                ),
              ),
              const SizedBox(width: AppTokens.spacing8),
              Expanded(
                child: _buildAmountItem(
                  context,
                  'Expenses',
                  expenses,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppTokens.spacing4),
        Text(
          Formatters.formatCurrency(amount),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
