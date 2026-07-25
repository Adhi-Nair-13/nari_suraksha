import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GradientBackground
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps [child] in a full-area gradient container.
///
/// Defaults to a vertical gradient using [AppColors.primary] →
/// [AppColors.primaryDark] so it naturally matches the Nari Suraksha
/// brand.  All parameters are overridable for context-specific use.
///
/// Use [GradientBackground.surface] for a subtle surface-tinted gradient
/// suitable for content screens (uses [ColorScheme] surface tones).
///
/// ```dart
/// // Brand splash gradient
/// GradientBackground(child: SplashContent())
///
/// // Subtle surface gradient
/// GradientBackground.surface(context: context, child: HomeContent())
/// ```
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderRadius,
  });

  /// Named constructor for a subtle surface-toned gradient.
  ///
  /// Reads tones directly from [ColorScheme] — safe for both light and dark.
  factory GradientBackground.surface({
    Key? key,
    required BuildContext context,
    required Widget child,
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
    BorderRadius? borderRadius,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GradientBackground(
      key: key,
      colors: [cs.surface, cs.surfaceContainerHighest],
      begin: begin,
      end: end,
      borderRadius: borderRadius,
      child: child,
    );
  }

  /// Gradient colour stops.  Defaults to `primary → primaryDark`.
  final List<Color>? colors;

  /// Gradient start alignment.
  final Alignment begin;

  /// Gradient end alignment.
  final Alignment end;

  /// Optional border radius for card-like usage.
  final BorderRadius? borderRadius;

  /// Child widget placed on top of the gradient.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = colors ??
        [AppColors.primary, AppColors.primaryDark];

    final Widget container = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
        ),
        borderRadius: borderRadius,
      ),
      child: child,
    );

    return container;
  }
}
