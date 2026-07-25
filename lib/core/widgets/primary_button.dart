import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PrimaryButton
// ─────────────────────────────────────────────────────────────────────────────

/// A full-width, filled Material 3 call-to-action button.
///
/// Adapts its colour roles from the ambient [Theme], so it renders correctly
/// in both light and dark modes without any hardcoded colours.
///
/// ```dart
/// PrimaryButton(
///   label: 'Get Started',
///   onPressed: () => ...,
///   icon: Icons.arrow_forward_rounded,
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.minHeight = 52.0,
  });

  /// Button label text.
  final String label;

  /// Tap callback; set to `null` to disable.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// When `true` a [CircularProgressIndicator] replaces the label.
  final bool isLoading;

  /// When `true` the button stretches to its parent width.
  final bool isFullWidth;

  /// Minimum touch-target height (default 52 dp).
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final Widget child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: cs.onPrimary,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(label, style: AppTextStyles.buttonLabel),
                ],
              )
            : Text(label, style: AppTextStyles.buttonLabel);

    final ButtonStyle style = FilledButton.styleFrom(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
      disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
      minimumSize: Size(isFullWidth ? double.infinity : 0, minHeight),
      shape: const StadiumBorder(),
      elevation: 0,
    );

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: child,
    );
  }
}
