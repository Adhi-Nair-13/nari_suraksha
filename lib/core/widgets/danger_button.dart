import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DangerButton
// ─────────────────────────────────────────────────────────────────────────────

/// A high-emphasis filled button for destructive or emergency actions (SOS).
///
/// Uses `colorScheme.error` / `colorScheme.onError` so it automatically
/// adapts between the softened error tone on dark mode and the vivid tone
/// on light mode, without any hardcoded colour values.
///
/// For maximum legibility the label is always uppercase and semibold.
///
/// ```dart
/// DangerButton(
///   label: 'Activate SOS',
///   onPressed: _triggerSos,
///   icon: Icons.emergency_rounded,
/// )
/// ```
class DangerButton extends StatelessWidget {
  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.minHeight = 56.0,
    this.isPulsing = false,
  });

  /// Button label text (rendered uppercase).
  final String label;

  /// Tap callback; set to `null` to disable.
  final VoidCallback? onPressed;

  /// Optional leading icon — defaults to a shield-warning icon.
  final IconData? icon;

  /// When `true` shows a loading spinner instead of the label.
  final bool isLoading;

  /// When `true` the button stretches to its parent width.
  final bool isFullWidth;

  /// Minimum touch-target height (default 56 dp — larger for SOS actions).
  final double minHeight;

  /// When `true` wraps the button in a subtle pulsing animation to convey urgency.
  final bool isPulsing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final Widget label_ = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: cs.onError,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon ?? Icons.emergency_rounded, size: 22),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: AppTextStyles.buttonLabel.copyWith(
                  color: cs.onError,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          );

    final ButtonStyle style = FilledButton.styleFrom(
      backgroundColor: cs.error,
      foregroundColor: cs.onError,
      disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
      disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
      minimumSize: Size(isFullWidth ? double.infinity : 0, minHeight),
      shape: const StadiumBorder(),
      elevation: 2,
      shadowColor: cs.error.withValues(alpha: 0.4),
    );

    final Widget button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: label_,
    );

    if (!isPulsing) return button;

    return _PulsingWrapper(child: button);
  }
}

// ── Private helper ───────────────────────────────────────────────────────────

/// Applies a repeating scale + opacity pulse to convey urgency.
class _PulsingWrapper extends StatefulWidget {
  const _PulsingWrapper({required this.child});
  final Widget child;

  @override
  State<_PulsingWrapper> createState() => _PulsingWrapperState();
}

class _PulsingWrapperState extends State<_PulsingWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _scale,
        child: widget.child,
      );
}
