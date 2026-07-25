import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LoadingWidget
// ─────────────────────────────────────────────────────────────────────────────

/// A full-area loading indicator with an optional message.
///
/// Renders a centred [CircularProgressIndicator] (M3 style) and an optional
/// [message] below it.  Colour derives from `colorScheme.primary`.
///
/// Use [LoadingWidget.overlay] to place it above existing content with a
/// semi-transparent scrim.
///
/// ```dart
/// // Inline
/// if (isLoading) const LoadingWidget()
///
/// // Overlay on a Stack
/// if (isLoading) LoadingWidget.overlay()
/// ```
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message,
    this.size = 40.0,
    this.strokeWidth = 3.5,
  });

  /// Optional message displayed below the spinner.
  final String? message;

  /// Diameter of the indicator (default 40 dp).
  final double size;

  /// Stroke thickness (default 3.5).
  final double strokeWidth;

  /// Returns a [LoadingWidget] wrapped in a full-area translucent overlay.
  ///
  /// Drop this into a [Stack] as the topmost child.
  static Widget overlay({String? message}) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.45),
      child: LoadingWidget(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              color: cs.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
