import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ConfirmationDialog
// ─────────────────────────────────────────────────────────────────────────────

/// A Material 3 [AlertDialog] pre-wired for confirmation flows.
///
/// Returns `true` when the user confirms, `false` / `null` when they
/// cancel or dismiss.  All colour roles are sourced from the ambient
/// [ColorScheme].
///
/// Use [ConfirmationDialog.show] for a one-liner call:
/// ```dart
/// final confirmed = await ConfirmationDialog.show(
///   context: context,
///   title: 'Delete contact?',
///   message: 'This guardian will be removed from your safety circle.',
///   confirmLabel: 'Delete',
///   isDangerous: true,
/// );
/// if (confirmed == true) _deleteContact();
/// ```
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDangerous = false,
    this.icon,
  });

  /// Dialog title.
  final String title;

  /// Body message.
  final String message;

  /// Confirm button label.
  final String confirmLabel;

  /// Cancel button label.
  final String cancelLabel;

  /// When `true` the confirm button uses `colorScheme.error`.
  final bool isDangerous;

  /// Optional icon at the top of the dialog.
  final IconData? icon;

  // ── Static convenience ──────────────────────────────────────────────────────

  /// Shows the dialog and returns `true` (confirmed), `false` (cancelled),
  /// or `null` (dismissed via back/barrier).
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDangerous: isDangerous,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final Color confirmFg =
        isDangerous ? cs.onError : cs.onPrimary;
    final Color confirmBg =
        isDangerous ? cs.error : cs.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      // ── Optional icon ────────────────────────────────────────────────────────
      icon: icon != null
          ? Icon(
              icon,
              size: 36,
              color: isDangerous ? cs.error : cs.primary,
            )
          : null,
      // ── Title ────────────────────────────────────────────────────────────────
      title: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurfaceVariant),
        textAlign: TextAlign.center,
      ),
      // ── Actions ──────────────────────────────────────────────────────────────
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        // Cancel
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.onSurface,
            side: BorderSide(color: cs.outline),
            shape: const StadiumBorder(),
            minimumSize: const Size(120, 44),
          ),
          child: Text(
            cancelLabel,
            style: AppTextStyles.buttonLabel.copyWith(color: cs.onSurface),
          ),
        ),
        // Confirm
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: confirmBg,
            foregroundColor: confirmFg,
            shape: const StadiumBorder(),
            minimumSize: const Size(120, 44),
          ),
          child: Text(
            confirmLabel,
            style: AppTextStyles.buttonLabel.copyWith(color: confirmFg),
          ),
        ),
      ],
    );
  }
}
