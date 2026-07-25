import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SecondaryButton
// ─────────────────────────────────────────────────────────────────────────────

/// An outlined Material 3 button for secondary / alternate actions.
///
/// Uses `colorScheme.primary` for the border and label so it pairs with
/// [PrimaryButton] in the same screen without hardcoded colours.
///
/// ```dart
/// SecondaryButton(
///   label: 'Learn More',
///   onPressed: () => ...,
/// )
/// ```
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
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
              color: cs.primary,
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

    final ButtonStyle style = OutlinedButton.styleFrom(
      foregroundColor: cs.primary,
      side: BorderSide(color: cs.primary, width: 1.5),
      disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
      minimumSize: Size(isFullWidth ? double.infinity : 0, minHeight),
      shape: const StadiumBorder(),
    );

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: child,
    );
  }
}
