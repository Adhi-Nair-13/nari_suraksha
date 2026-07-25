import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CircularAvatarWidget
// ─────────────────────────────────────────────────────────────────────────────

/// A circular avatar with graceful fallback behaviour:
///   1. Displays [imageUrl] if provided and loadable.
///   2. Falls back to initials derived from [name].
///   3. Falls back to a generic person icon.
///
/// Supports an optional [badge] (e.g. an online-indicator dot) overlaid
/// at the bottom-right corner.
///
/// ```dart
/// // Network image
/// CircularAvatarWidget(
///   name: 'Priya Sharma',
///   imageUrl: 'https://...',
///   radius: 28,
/// )
///
/// // Initials fallback
/// CircularAvatarWidget(name: 'Priya Sharma', radius: 24)
///
/// // With online badge
/// CircularAvatarWidget(
///   name: 'Mom',
///   radius: 24,
///   badge: CircleAvatar(radius: 6, backgroundColor: AppColors.success),
/// )
/// ```
class CircularAvatarWidget extends StatelessWidget {
  const CircularAvatarWidget({
    super.key,
    this.name,
    this.imageUrl,
    this.radius = 24.0,
    this.badge,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
  });

  /// Used to derive initials when [imageUrl] is absent.
  final String? name;

  /// Network image URL.
  final String? imageUrl;

  /// Avatar radius (default 24 dp).
  final double radius;

  /// Small widget overlaid at the bottom-right corner (e.g., status dot).
  final Widget? badge;

  /// Avatar background colour — defaults to `colorScheme.primaryContainer`.
  final Color? backgroundColor;

  /// Initials / icon colour — defaults to `colorScheme.onPrimaryContainer`.
  final Color? foregroundColor;

  /// Optional tap callback.
  final VoidCallback? onTap;

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _initials() {
    if (name == null || name!.trim().isEmpty) return '';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Color bg = backgroundColor ?? cs.primaryContainer;
    final Color fg = foregroundColor ?? cs.onPrimaryContainer;

    final String initials = _initials();

    Widget avatar;

    if (imageUrl != null) {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    } else if (initials.isNotEmpty) {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Text(
          initials,
          style: AppTextStyles.titleMedium.copyWith(
            color: fg,
            fontSize: radius * 0.65,
          ),
        ),
      );
    } else {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Icon(
          Icons.person_rounded,
          color: AppColors.primary,
          size: radius,
        ),
      );
    }

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    if (badge == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: badge!,
        ),
      ],
    );
  }
}
