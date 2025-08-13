import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppAnimations {
  // Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = AppTheme.animationNormal,
    Curve curve = AppTheme.animationCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide in from bottom animation
  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = AppTheme.animationNormal,
    Curve curve = AppTheme.animationCurve,
    double offset = 50.0,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: Offset(0, offset), end: Offset.zero),
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Scale in animation
  static Widget scaleIn({
    required Widget child,
    Duration duration = AppTheme.animationNormal,
    Curve curve = AppTheme.animationCurve,
    double beginScale = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: beginScale, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Staggered list animation
  static Widget staggeredList({
    required List<Widget> children,
    Duration duration = AppTheme.animationNormal,
    Curve curve = AppTheme.animationCurve,
    double staggerDelay = 100.0,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: duration.inMilliseconds + (index * staggerDelay).round()),
          curve: curve,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  // Card hover animation
  static Widget cardHover({
    required Widget child,
    Duration duration = AppTheme.animationFast,
    Curve curve = AppTheme.animationCurveFast,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  // Pulse animation for loading states
  static Widget pulse({
    required Widget child,
    Duration duration = AppTheme.animationSlow,
    Curve curve = AppTheme.animationCurveSlow,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.8, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Bounce animation for success states
  static Widget bounce({
    required Widget child,
    Duration duration = AppTheme.animationNormal,
    Curve curve = AppTheme.animationCurveSlow,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (0.2 * (1 - value)),
          child: child,
        );
      },
      child: child,
    );
  }
}

// Custom page route with consistent animations
class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({
    required Widget child,
    super.settings,
    Duration duration = AppTheme.animationNormal,
    Curve curve = AppTheme.animationCurve,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = AppTheme.animationCurve;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}
