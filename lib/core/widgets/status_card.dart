import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StatusCard
// ─────────────────────────────────────────────────────────────────────────────

/// A compact status / summary card with a left-side accent stripe.
///
/// Intended for displaying operational states (e.g. "Location Active",
/// "SOS Armed", "Battery Low") using semantic colour roles.
///
/// [StatusVariant] controls the colour accent:
/// - [StatusVariant.success] → `colorScheme.secondary`
/// - [StatusVariant.warning] → `AppColors.warning`
/// - [StatusVariant.error]   → `colorScheme.error`
/// - [StatusVariant.info]    → `colorScheme.primary`
/// - [StatusVariant.neutral] → `colorScheme.onSurfaceVariant`
///
/// ```dart
/// StatusCard(
///   title: 'Location Sharing',
///   message: 'Your location is being shared with 2 guardians.',
///   variant: StatusVariant.success,
///   icon: Icons.location_on_rounded,
/// )
/// ```
enum StatusVariant { success, warning, error, info, neutral }

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.title,
    required this.message,
    this.variant = StatusVariant.info,
    this.icon,
    this.onTap,
    this.actionLabel,
    this.onAction,
  });

  /// Bold heading line.
  final String title;

  /// Descriptive body text.
  final String message;

  /// Accent variant controlling the stripe and icon colour.
  final StatusVariant variant;

  /// Optional icon replacing the default variant icon.
  final IconData? icon;

  /// Tap callback for the whole card.
  final VoidCallback? onTap;

  /// Optional CTA label rendered as a [TextButton] on the right.
  final String? actionLabel;

  /// Callback for [actionLabel].
  final VoidCallback? onAction;

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Color _accentColor(ColorScheme cs) => switch (variant) {
        StatusVariant.success => cs.secondary,
        StatusVariant.warning => AppColors.warning,
        StatusVariant.error   => cs.error,
        StatusVariant.info    => cs.primary,
        StatusVariant.neutral => cs.onSurfaceVariant,
      };

  Color _containerColor(ColorScheme cs) => switch (variant) {
        StatusVariant.success => cs.secondaryContainer,
        StatusVariant.warning => AppColors.warning.withValues(alpha: 0.12),
        StatusVariant.error   => cs.errorContainer,
        StatusVariant.info    => cs.primaryContainer,
        StatusVariant.neutral => cs.surfaceContainerHighest,
      };


  IconData get _defaultIcon => switch (variant) {
        StatusVariant.success => Icons.check_circle_rounded,
        StatusVariant.warning => Icons.warning_amber_rounded,
        StatusVariant.error   => Icons.error_rounded,
        StatusVariant.info    => Icons.info_rounded,
        StatusVariant.neutral => Icons.radio_button_unchecked_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final Color accent      = _accentColor(cs);
    final Color container   = _containerColor(cs);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        decoration: BoxDecoration(
          color: container,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border(
            left: BorderSide(color: accent, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Accent icon ─────────────────────────────────────────────────
            Icon(icon ?? _defaultIcon, color: accent, size: 22),
            const SizedBox(width: AppSpacing.sm),

            // ── Text ────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // ── Optional action ─────────────────────────────────────────────
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.labelMedium.copyWith(color: accent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
