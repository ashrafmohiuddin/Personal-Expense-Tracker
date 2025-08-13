import 'package:flutter/material.dart';
import '../../../../design/app_card.dart';
import '../../../../design/tokens.dart';
import '../../../../core/formatters.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final double amount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final color = isPositive ? Colors.green : Colors.red;

    return AppCard(
      onTap: onTap,
      elevation: AppTokens.elevationMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: color,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: AppTokens.spacing12),
          Text(
            Formatters.formatCurrency(amount.abs()),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (amount < 0)
            Text(
              'Negative balance',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                  ),
            ),
        ],
      ),
    );
  }
}
