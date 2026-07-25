import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CustomAppBar
// ─────────────────────────────────────────────────────────────────────────────

/// A pre-styled [AppBar] that implements [PreferredSizeWidget] so it can
/// be used directly in [Scaffold.appBar].
///
/// Follows the Material 3 spec:
/// - Transparent / surface background.
/// - Title uses [AppTextStyles.appBarTitle].
/// - Auto-detects whether to show a back-button via [Navigator.canPop].
/// - Supports optional leading widget, action list, and bottom widget.
///
/// ```dart
/// Scaffold(
///   appBar: CustomAppBar(
///     title: 'Profile',
///     actions: [
///       IconButton(icon: const Icon(Icons.edit_outlined), onPressed: ...),
///     ],
///   ),
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showBackButton = true,
    this.onBackPressed,
    this.titleWidget,
  });

  /// AppBar title string — ignored when [titleWidget] is provided.
  final String title;

  /// Custom leading widget — overrides the auto back-button.
  final Widget? leading;

  /// Action icons/buttons on the right.
  final List<Widget>? actions;

  /// Widget rendered below the title row (e.g. a [TabBar]).
  final PreferredSizeWidget? bottom;

  final bool centerTitle;

  /// Override the default surface background.
  final Color? backgroundColor;

  /// Override icon / text foreground colour.
  final Color? foregroundColor;

  final double elevation;

  /// Set to `false` to hide the back button even when the stack can pop.
  final bool showBackButton;

  /// Custom back-button handler; defaults to [Navigator.pop].
  final VoidCallback? onBackPressed;

  /// Replaces the text [title] with an arbitrary widget (e.g. a logo).
  final Widget? titleWidget;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool canPop = Navigator.of(context).canPop();

    Widget? leadingWidget = leading;
    if (leadingWidget == null && canPop && showBackButton) {
      leadingWidget = IconButton(
        tooltip: 'Back',
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return AppBar(
      title: titleWidget ??
          Text(
            title,
            style: AppTextStyles.appBarTitle.copyWith(
              color: foregroundColor ?? cs.onSurface,
            ),
          ),
      centerTitle: centerTitle,
      leading: leadingWidget,
      automaticallyImplyLeading: false,
      actions: actions,
      bottom: bottom,
      backgroundColor: backgroundColor ?? cs.surface,
      foregroundColor: foregroundColor ?? cs.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: elevation,
    );
  }
}
