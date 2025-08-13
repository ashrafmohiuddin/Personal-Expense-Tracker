import 'package:flutter/material.dart';
import 'tokens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.leadingIcon,
    this.onTap,
    this.padding = const EdgeInsets.all(AppTokens.spacing16),
    this.margin,
    this.elevation = AppTokens.elevationLow,
    this.radius = AppTokens.radius,
  });

  final Widget child;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(
        padding: padding,
        child: leadingIcon != null
            ? Row(
                children: [
                  Icon(
                    leadingIcon,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppTokens.spacing12),
                  Expanded(child: child),
                ],
              )
            : child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      );
    }

    return card;
  }
}
