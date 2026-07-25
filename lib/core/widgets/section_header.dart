import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SectionHeader
// ─────────────────────────────────────────────────────────────────────────────

/// A lightweight section-divider widget used to label groups of content.
///
/// Renders [title] with [AppTextStyles.sectionHeading] and optionally a
/// trailing [action] link (e.g., "See all").
///
/// All colours derive from the ambient [ColorScheme]; no hardcoded values.
///
/// ```dart
/// SectionHeader(
///   title: 'Emergency Contacts',
///   actionLabel: 'Manage',
///   onAction: () => ...,
/// )
/// ```
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding,
  });

  /// Section heading text.
  final String title;

  /// Optional trailing action label (e.g. "See all", "Edit").
  final String? actionLabel;

  /// Callback for [actionLabel].
  final VoidCallback? onAction;

  /// Outer padding — defaults to horizontal screen padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.sectionHeading.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: cs.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: AppTextStyles.labelMedium.copyWith(color: cs.primary),
              ),
            ),
        ],
      ),
    );
  }
}
