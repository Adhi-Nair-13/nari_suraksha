import 'package:flutter/material.dart';

/// A reusable quick-action tile displayed on the SOS screen action panel.
///
/// Shows a coloured [CircleAvatar] icon with a short text [label] below it.
/// Extracted from the private `_buildQuickActionItem` helper in [SosScreen].
class QuickActionItem extends StatelessWidget {
  /// The icon to display inside the circle avatar.
  final IconData icon;

  /// Short descriptive label shown below the avatar.
  final String label;

  /// Tint colour applied to both the icon and the avatar background.
  final Color color;

  /// Callback triggered when the tile is tapped.
  final VoidCallback onTap;

  const QuickActionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
