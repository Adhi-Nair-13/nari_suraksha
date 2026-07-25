import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FeatureCard
// ─────────────────────────────────────────────────────────────────────────────

/// A tappable content card showcasing a single feature or navigable section.
///
/// Layout (left-to-right):
///  • Rounded icon container (`colorScheme.primaryContainer`)
///  • [title] + [subtitle] text column
///  • Optional trailing chevron or custom widget
///
/// Responds to theme changes: surface colour, border, and text colours all
/// derive from the ambient [ColorScheme] with zero hardcoded values.
///
/// ```dart
/// FeatureCard(
///   icon: Icons.shield_rounded,
///   title: 'SOS Shield',
///   subtitle: 'Activate one-tap emergency alert',
///   onTap: () => Navigator.pushNamed(context, AppRoutes.home),
/// )
/// ```
class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.iconBackgroundColor,
    this.showChevron = true,
    this.padding,
  });

  /// Icon rendered inside the coloured container.
  final IconData icon;

  /// Primary card heading.
  final String title;

  /// Secondary description text below [title].
  final String? subtitle;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Override the default trailing chevron with a custom widget.
  final Widget? trailing;

  /// Icon tint — defaults to `colorScheme.primary`.
  final Color? iconColor;

  /// Icon container background — defaults to `colorScheme.primaryContainer`.
  final Color? iconBackgroundColor;

  /// Whether to show the default trailing chevron icon.
  final bool showChevron;

  /// Inner padding override.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Color tintColor = iconColor ?? cs.primary;
    final Color containerColor = iconBackgroundColor ?? cs.primaryContainer;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: cs.outlineVariant),
      ),
      color: cs.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: padding ??
              const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              // ── Icon container ─────────────────────────────────────────────
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: tintColor, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),

              // ── Text column ────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // ── Trailing ───────────────────────────────────────────────────
              if (trailing != null)
                trailing!
              else if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  color: cs.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
