import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EmptyStateWidget
// ─────────────────────────────────────────────────────────────────────────────

/// Displayed when a list or screen has no content to show.
///
/// Layout (top → bottom, centred):
///   1. Large illustrative [icon]
///   2. [title] — bold heading
///   3. [message] — muted description
///   4. Optional [actionLabel] CTA button
///
/// All colours adapt to the ambient theme via [ColorScheme].
///
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.contacts_outlined,
///   title: 'No emergency contacts',
///   message: 'Add guardians so they can be alerted in an emergency.',
///   actionLabel: 'Add Contact',
///   onAction: () => ...,
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80.0,
  });

  /// Illustrative icon.
  final IconData icon;

  /// Primary heading.
  final String title;

  /// Optional description below [title].
  final String? message;

  /// Label for the optional call-to-action button.
  final String? actionLabel;

  /// CTA callback.
  final VoidCallback? onAction;

  /// Size of the [icon] (default 80 dp).
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Illustrative icon ────────────────────────────────────────────
            Container(
              width: iconSize + 24,
              height: iconSize + 24,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: cs.primary.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Title ────────────────────────────────────────────────────────
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            // ── Message ──────────────────────────────────────────────────────
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // ── CTA ──────────────────────────────────────────────────────────
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: const StadiumBorder(),
                  minimumSize: const Size(160, 48),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.buttonLabel,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
