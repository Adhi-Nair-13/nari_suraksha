import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTheme
// ─────────────────────────────────────────────────────────────────────────────

/// Production-ready Material 3 theme for Nari Suraksha.
///
/// Usage in [MaterialApp]:
/// ```dart
/// MaterialApp(
///   theme:     AppTheme.light,
///   darkTheme: AppTheme.dark,
///   ...
/// )
/// ```
///
/// Structure:
///   1. [ColorScheme] constants — light & dark
///   2. [_buildTheme] — single builder used by both [light] and [dark]
///   3. Individual sub-theme builders (AppBar, Card, Buttons, Input, etc.)
abstract final class AppTheme {
  // ─────────────────────────────────────────────────────────────────────────
  // 1. ColorScheme definitions
  // ─────────────────────────────────────────────────────────────────────────

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary — Warm Safety Gold
    primary:            AppColors.primary,
    onPrimary:          AppColors.onPrimary,
    primaryContainer:   AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,

    // Secondary — Soft Teal
    secondary:            AppColors.secondary,
    onSecondary:          AppColors.onSecondary,
    secondaryContainer:   AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,

    // Tertiary — Lavender
    tertiary:            AppColors.tertiary,
    onTertiary:          AppColors.onTertiary,
    tertiaryContainer:   AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,

    // Error
    error:            AppColors.error,
    onError:          AppColors.onError,
    errorContainer:   AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,

    // Surface — warm cream
    surface:            AppColors.surface,
    onSurface:          AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    onSurfaceVariant:   AppColors.onSurfaceVariant,
    surfaceTint:        AppColors.primary,

    // Outline
    outline:        AppColors.outline,
    outlineVariant: AppColors.outlineVariant,

    // Inverse
    inverseSurface:   AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
    inversePrimary:   AppColors.inversePrimary,

    // Shared
    shadow: AppColors.shadow,
    scrim:  AppColors.scrim,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary — warm gold, lighter for legibility
    primary:            AppColors.primaryLight,
    onPrimary:          AppColors.onPrimary,
    primaryContainer:   AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,

    // Secondary — teal
    secondary:            AppColors.secondaryLight,
    onSecondary:          AppColors.onSecondary,
    secondaryContainer:   AppColors.darkSecondaryContainer,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,

    // Tertiary
    tertiary:            Color(0xFFA099FF),
    onTertiary:          Color(0xFF2B0094),
    tertiaryContainer:   AppColors.darkTertiaryContainer,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,

    // Error
    error:            Color(0xFFFF8A80),
    onError:          Color(0xFF7F0017),
    errorContainer:   AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,

    // Surface — warm dark
    surface:            AppColors.darkSurface,
    onSurface:          AppColors.darkOnSurface,
    surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
    onSurfaceVariant:   AppColors.darkOnSurfaceVariant,
    surfaceTint:        AppColors.primaryLight,

    // Outline
    outline:        AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,

    // Inverse
    inverseSurface:   AppColors.darkInverseSurface,
    onInverseSurface: AppColors.darkOnInverseSurface,
    inversePrimary:   AppColors.primary,

    // Shared
    shadow: AppColors.shadow,
    scrim:  AppColors.scrim,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // 2. Public theme getters
  // ─────────────────────────────────────────────────────────────────────────

  /// Light [ThemeData] wired with [AppColors], [AppTextStyles], and
  /// full Material 3 component sub-themes.
  static ThemeData get light => _buildTheme(_lightScheme);

  /// Dark [ThemeData] — mirrors [light] with dark-appropriate colour roles.
  static ThemeData get dark  => _buildTheme(_darkScheme);

  // ─────────────────────────────────────────────────────────────────────────
  // 3. Master builder
  // ─────────────────────────────────────────────────────────────────────────

  static ThemeData _buildTheme(ColorScheme cs) {
    final bool isLight = cs.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme:  cs,
      textTheme:    AppTextStyles.buildTextTheme(cs),

      scaffoldBackgroundColor:
          isLight ? AppColors.background : AppColors.darkBackground,

      // ── AppBar ──────────────────────────────────────────────────────────────
      appBarTheme: _appBarTheme(cs, isLight),

      // ── Card ────────────────────────────────────────────────────────────────
      cardTheme: _cardTheme(cs, isLight),

      // ── Buttons ─────────────────────────────────────────────────────────────
      elevatedButtonTheme:  _elevatedButtonTheme(cs),
      outlinedButtonTheme:  _outlinedButtonTheme(cs),
      textButtonTheme:      _textButtonTheme(cs),
      filledButtonTheme:    _filledButtonTheme(cs),
      iconButtonTheme:      _iconButtonTheme(cs),

      // ── FAB ─────────────────────────────────────────────────────────────────
      floatingActionButtonTheme: _fabTheme(cs),

      // ── Input ───────────────────────────────────────────────────────────────
      inputDecorationTheme: _inputDecorationTheme(cs, isLight),

      // ── SnackBar ────────────────────────────────────────────────────────────
      snackBarTheme: _snackBarTheme(cs),

      // ── Navigation Bar ──────────────────────────────────────────────────────
      navigationBarTheme: _navigationBarTheme(cs, isLight),

      // ── Chips ───────────────────────────────────────────────────────────────
      chipTheme: _chipTheme(cs, isLight),

      // ── Dialog ──────────────────────────────────────────────────────────────
      dialogTheme: _dialogTheme(cs, isLight),

      // ── Bottom Sheet ────────────────────────────────────────────────────────
      bottomSheetTheme: _bottomSheetTheme(cs, isLight),

      // ── Divider ─────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color:     isLight ? AppColors.outlineVariant : AppColors.darkOutlineVariant,
        thickness: 1,
        space:     1,
      ),

      // ── ListTile ────────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        titleTextStyle:
            AppTextStyles.bodyLarge.copyWith(color: cs.onSurface),
        subtitleTextStyle:
            AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
        iconColor:  cs.onSurfaceVariant,
        tileColor:  Colors.transparent,
        shape:      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      // ── Switch ──────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (s) => s.contains(WidgetState.selected) ? cs.onPrimary : cs.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (s) => s.contains(WidgetState.selected) ? cs.primary : cs.surfaceContainerHighest,
        ),
      ),

      // ── Progress indicator ──────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color:              cs.primary,
        linearTrackColor:   cs.primaryContainer,
        circularTrackColor: cs.primaryContainer,
        linearMinHeight:    4,
      ),

      // ── Popup menu ──────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color:         isLight ? AppColors.surface : AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation:     3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle:
            AppTextStyles.bodyMedium.copyWith(color: cs.onSurface),
        labelTextStyle: WidgetStateProperty.all(
          AppTextStyles.bodyMedium.copyWith(color: cs.onSurface),
        ),
      ),

      // ── Tooltip ─────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color:        cs.inverseSurface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle:
            AppTextStyles.bodySmall.copyWith(color: cs.onInverseSurface),
        padding:  const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical:   AppSpacing.xs,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Sub-theme builders
  // ─────────────────────────────────────────────────────────────────────────

  // ── AppBar ───────────────────────────────────────────────────────────────────
  static AppBarTheme _appBarTheme(ColorScheme cs, bool isLight) {
    return AppBarTheme(
      elevation:                  0,
      scrolledUnderElevation:     1,
      centerTitle:                true,
      backgroundColor:
          isLight ? AppColors.surface : AppColors.darkSurface,
      foregroundColor:            cs.onSurface,
      surfaceTintColor:           Colors.transparent,
      shadowColor:
          AppColors.shadow.withValues(alpha: 0.06),
      titleTextStyle:
          AppTextStyles.appBarTitle.copyWith(color: cs.onSurface),
      iconTheme:        IconThemeData(color: cs.onSurface, size: 24),
      actionsIconTheme: IconThemeData(color: cs.onSurface, size: 24),
      systemOverlayStyle: isLight
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor:            Colors.transparent,
              systemNavigationBarColor:  AppColors.surface,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor:            Colors.transparent,
              systemNavigationBarColor:  AppColors.darkSurface,
            ),
    );
  }

  // ── Card ─────────────────────────────────────────────────────────────────────
  static CardThemeData _cardTheme(ColorScheme cs, bool isLight) {
    return CardThemeData(
      elevation:        0,
      color:            isLight ? AppColors.surface : AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor:      AppColors.shadow.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(
          color: isLight ? AppColors.outlineVariant : AppColors.darkOutlineVariant,
          width: 1,
        ),
      ),
      margin:      const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      clipBehavior: Clip.antiAlias,
    );
  }

  // ── ElevatedButton ───────────────────────────────────────────────────────────
  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme cs) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation:          0,
        backgroundColor:    cs.primary,
        foregroundColor:    cs.onPrimary,
        disabledBackgroundColor:
            cs.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor:
            cs.onSurface.withValues(alpha: 0.38),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.sm + AppSpacing.xs, // 12 dp
        ),
        minimumSize:  const Size(64, 48),
        textStyle:    AppTextStyles.buttonLabel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ).copyWith(
        // Pressed-state elevation ripple
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (s) => s.contains(WidgetState.pressed)
              ? cs.onPrimary.withValues(alpha: 0.12)
              : null,
        ),
      ),
    );
  }

  // ── OutlinedButton ────────────────────────────────────────────────────────────
  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme cs) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation:   0,
        foregroundColor: cs.primary,
        disabledForegroundColor:
            cs.onSurface.withValues(alpha: 0.38),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.sm + AppSpacing.xs,
        ),
        minimumSize: const Size(64, 48),
        textStyle:   AppTextStyles.buttonLabel,
        side: BorderSide(color: cs.outline, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ).copyWith(
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          (s) => s.contains(WidgetState.focused)
              ? BorderSide(color: cs.primary, width: 2)
              : s.contains(WidgetState.pressed)
                  ? BorderSide(color: cs.primary, width: 2)
                  : s.contains(WidgetState.disabled)
                      ? BorderSide(
                          color: cs.onSurface.withValues(alpha: 0.12),
                          width: 1,
                        )
                      : BorderSide(color: cs.outline, width: 1.5),
        ),
      ),
    );
  }

  // ── TextButton ────────────────────────────────────────────────────────────────
  static TextButtonThemeData _textButtonTheme(ColorScheme cs) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: cs.primary,
        disabledForegroundColor:
            cs.onSurface.withValues(alpha: 0.38),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical:   AppSpacing.sm,
        ),
        minimumSize: const Size(64, 40),
        textStyle:   AppTextStyles.buttonLabel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    );
  }

  // ── FilledButton ─────────────────────────────────────────────────────────────
  static FilledButtonThemeData _filledButtonTheme(ColorScheme cs) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor:  cs.primary,
        foregroundColor:  cs.onPrimary,
        disabledBackgroundColor:
            cs.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor:
            cs.onSurface.withValues(alpha: 0.38),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.sm + AppSpacing.xs,
        ),
        minimumSize: const Size(64, 48),
        textStyle:   AppTextStyles.buttonLabel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    );
  }

  // ── IconButton ────────────────────────────────────────────────────────────────
  static IconButtonThemeData _iconButtonTheme(ColorScheme cs) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: cs.onSurfaceVariant,
        highlightColor:  cs.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        minimumSize: const Size(40, 40),
      ),
    );
  }

  // ── FAB ──────────────────────────────────────────────────────────────────────
  static FloatingActionButtonThemeData _fabTheme(ColorScheme cs) {
    return FloatingActionButtonThemeData(
      elevation:          3,
      focusElevation:     4,
      hoverElevation:     4,
      highlightElevation: 6,
      backgroundColor:    cs.primary,
      foregroundColor:    cs.onPrimary,
      extendedTextStyle:  AppTextStyles.buttonLabel.copyWith(color: cs.onPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
    );
  }

  // ── InputDecorationTheme ─────────────────────────────────────────────────────
  static InputDecorationTheme _inputDecorationTheme(
      ColorScheme cs, bool isLight) {
    final Color fill = isLight
        ? AppColors.surfaceVariant
        : AppColors.darkSurfaceVariant.withValues(alpha: 0.6);

    final OutlineInputBorder baseInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide:   BorderSide.none,
    );

    return InputDecorationTheme(
      filled:          true,
      fillColor:       fill,
      contentPadding:  const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical:   AppSpacing.sm + AppSpacing.xs, // 12 dp
      ),
      // Text styles
      hintStyle:    AppTextStyles.inputHint,
      labelStyle:   AppTextStyles.inputLabel,
      floatingLabelStyle:
          AppTextStyles.labelMedium.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
      errorStyle:   AppTextStyles.errorText,
      helperStyle:  AppTextStyles.caption,
      // Icon colours — dynamic to reflect focus state
      prefixIconColor: WidgetStateColor.resolveWith(
        (s) => s.contains(WidgetState.focused) ? cs.primary : cs.onSurfaceVariant,
      ),
      suffixIconColor: WidgetStateColor.resolveWith(
        (s) => s.contains(WidgetState.focused) ? cs.primary : cs.onSurfaceVariant,
      ),
      // Borders
      border:       baseInputBorder,
      enabledBorder: baseInputBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide:   BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide:   BorderSide(color: cs.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide:   BorderSide(color: cs.error, width: 2),
      ),
      disabledBorder: baseInputBorder,
    );
  }

  // ── SnackBar ─────────────────────────────────────────────────────────────────
  /// Follows the M3 pattern: uses [ColorScheme.inverseSurface] as background
  /// and [ColorScheme.inversePrimary] for action text, giving strong contrast
  /// regardless of the active brightness.
  static SnackBarThemeData _snackBarTheme(ColorScheme cs) {
    return SnackBarThemeData(
      behavior:         SnackBarBehavior.floating,
      backgroundColor:  cs.inverseSurface,
      contentTextStyle:
          AppTextStyles.bodyMedium.copyWith(
            color:      cs.onInverseSurface,
            fontWeight: FontWeight.w500,
          ),
      actionTextColor:  cs.inversePrimary,
      disabledActionTextColor:
          cs.onInverseSurface.withValues(alpha: 0.38),
      elevation:    6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical:   AppSpacing.sm,
      ),
    );
  }

  // ── NavigationBar ─────────────────────────────────────────────────────────────
  static NavigationBarThemeData _navigationBarTheme(
      ColorScheme cs, bool isLight) {
    return NavigationBarThemeData(
      elevation:        0,
      height:           72,
      backgroundColor:
          isLight ? AppColors.surface : AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor:      AppColors.shadow.withValues(alpha: 0.06),
      indicatorColor:   cs.primaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
        (s) => IconThemeData(
          size:  24,
          color: s.contains(WidgetState.selected)
              ? cs.onPrimaryContainer
              : cs.onSurfaceVariant,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (s) => AppTextStyles.labelSmall.copyWith(
          color: s.contains(WidgetState.selected)
              ? cs.primary
              : cs.onSurfaceVariant,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w500,
        ),
      ),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  // ── Chip ─────────────────────────────────────────────────────────────────────
  static ChipThemeData _chipTheme(ColorScheme cs, bool isLight) {
    return ChipThemeData(
      backgroundColor:
          isLight ? AppColors.surfaceVariant : AppColors.darkSurfaceVariant,
      selectedColor:    cs.primaryContainer,
      disabledColor:    cs.onSurface.withValues(alpha: 0.12),
      deleteIconColor:  cs.onSurfaceVariant,
      labelStyle:
          AppTextStyles.labelMedium.copyWith(color: cs.onSurface),
      secondaryLabelStyle:
          AppTextStyles.labelMedium.copyWith(color: cs.onPrimaryContainer),
      side: BorderSide(color: cs.outlineVariant, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xs, // 12 dp
        vertical:   AppSpacing.xs,
      ),
      elevation:         0,
      pressElevation:    0,
      showCheckmark:     true,
      checkmarkColor:    cs.onPrimaryContainer,
    );
  }

  // ── Dialog ────────────────────────────────────────────────────────────────────
  static DialogThemeData _dialogTheme(ColorScheme cs, bool isLight) {
    return DialogThemeData(
      elevation:        3,
      backgroundColor:
          isLight ? AppColors.surface : AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle:
          AppTextStyles.titleLarge.copyWith(color: cs.onSurface),
      contentTextStyle:
          AppTextStyles.bodyMedium.copyWith(color: cs.onSurfaceVariant),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.lg,
      ),
    );
  }

  // ── BottomSheet ───────────────────────────────────────────────────────────────
  static BottomSheetThemeData _bottomSheetTheme(
      ColorScheme cs, bool isLight) {
    return BottomSheetThemeData(
      elevation:          0,
      modalElevation:     0,
      backgroundColor:
          isLight ? AppColors.surface : AppColors.darkSurface,
      surfaceTintColor:   Colors.transparent,
      modalBackgroundColor:
          isLight ? AppColors.surface : AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      showDragHandle: true,
      dragHandleColor:
          isLight ? AppColors.outlineVariant : AppColors.darkOutline,
      dragHandleSize: const Size(32, 4),
      clipBehavior:   Clip.antiAlias,
    );
  }
}
