import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BottomActionSheet
// ─────────────────────────────────────────────────────────────────────────────

/// A Material 3 modal bottom sheet with a title, optional subtitle, and a
/// vertical list of labelled action items.
///
/// Call [BottomActionSheet.show] for a convenient one-liner:
/// ```dart
/// await BottomActionSheet.show(
///   context: context,
///   title: 'Contact Options',
///   actions: [
///     SheetAction(
///       icon: Icons.call_rounded,
///       label: 'Call',
///       onTap: () => _call(contact),
///     ),
///     SheetAction(
///       icon: Icons.delete_outline_rounded,
///       label: 'Remove',
///       onTap: () => _remove(contact),
///       isDangerous: true,
///     ),
///   ],
/// );
/// ```

// ── SheetAction ──────────────────────────────────────────────────────────────

/// A single action item inside [BottomActionSheet].
class SheetAction {
  const SheetAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDangerous = false,
    this.subtitle,
  });

  /// Action label.
  final String label;

  /// Tap callback.
  final VoidCallback onTap;

  /// Optional leading icon.
  final IconData? icon;

  /// Renders label and icon in `colorScheme.error` when `true`.
  final bool isDangerous;

  /// Optional description below [label].
  final String? subtitle;
}

// ── BottomActionSheet ────────────────────────────────────────────────────────

class BottomActionSheet extends StatelessWidget {
  const BottomActionSheet({
    super.key,
    required this.actions,
    this.title,
    this.subtitle,
    this.showDragHandle = true,
    this.showCancelButton = true,
    this.cancelLabel = 'Cancel',
  });

  /// List of action items.
  final List<SheetAction> actions;

  /// Optional sheet title.
  final String? title;

  /// Optional subtitle below [title].
  final String? subtitle;

  /// Show the M3 drag handle at the top.
  final bool showDragHandle;

  /// Show a cancel button at the bottom.
  final bool showCancelButton;

  /// Label for the cancel button.
  final String cancelLabel;

  // ── Static convenience ──────────────────────────────────────────────────────

  /// Shows the bottom sheet and returns when dismissed.
  static Future<void> show({
    required BuildContext context,
    required List<SheetAction> actions,
    String? title,
    String? subtitle,
    bool showCancelButton = true,
    String cancelLabel = 'Cancel',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (_) => BottomActionSheet(
        actions: actions,
        title: title,
        subtitle: subtitle,
        showDragHandle: false, // showModalBottomSheet handles the handle
        showCancelButton: showCancelButton,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ────────────────────────────────────────────────────
          if (showDragHandle)
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),

          // ── Title row ──────────────────────────────────────────────────────
          if (title != null) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
            Divider(
              height: AppSpacing.lg,
              color: cs.outlineVariant,
            ),
          ] else
            const SizedBox(height: AppSpacing.sm),

          // ── Action items ───────────────────────────────────────────────────
          ...actions.map((action) {
            final Color fg =
                action.isDangerous ? cs.error : cs.onSurface;

            return ListTile(
              leading: action.icon != null
                  ? Icon(action.icon, color: fg)
                  : null,
              title: Text(
                action.label,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: action.subtitle != null
                  ? Text(
                      action.subtitle!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: cs.onSurfaceVariant),
                    )
                  : null,
              onTap: () {
                Navigator.of(context).pop();
                action.onTap();
              },
            );
          }),

          // ── Cancel button ──────────────────────────────────────────────────
          if (showCancelButton) ...[
            const Divider(height: 1),
            ListTile(
              title: Text(
                cancelLabel,
                style: AppTextStyles.bodyLarge
                    .copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
