import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTextStyles
// ─────────────────────────────────────────────────────────────────────────────

/// Poppins-based typographic scale for Nari Suraksha.
///
/// Follows the Material 3 type system naming convention so styles map
/// directly to [TextTheme] slots.  Each getter returns a fresh [TextStyle];
/// use [TextStyle.copyWith] to override individual properties at the call-site.
///
/// The class also exposes semantic aliases (e.g. [screenTitle], [caption])
/// that screens should prefer over raw M3 slot names.
abstract final class AppTextStyles {
  // ── Internal factory ──────────────────────────────────────────────────────────

  static TextStyle _p({
    required double size,
    required FontWeight weight,
    double? letterSpacing,
    double? height,
    Color color = AppColors.textPrimary, // high-contrast default for all text
  }) =>
      GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
        color: color,
      );

  // ── Display ──────────────────────────────────────────────────────────────────

  /// 57 sp — used for hero / splash numerals.
  static TextStyle get displayLarge =>
      _p(size: 57, weight: FontWeight.w700, letterSpacing: -0.25, height: 1.12);

  /// 45 sp
  static TextStyle get displayMedium =>
      _p(size: 45, weight: FontWeight.w700, letterSpacing: 0, height: 1.16);

  /// 36 sp
  static TextStyle get displaySmall =>
      _p(size: 36, weight: FontWeight.w700, letterSpacing: 0, height: 1.22);

  // ── Headline ─────────────────────────────────────────────────────────────────

  /// 32 sp — primary screen heading.
  static TextStyle get headlineLarge =>
      _p(size: 32, weight: FontWeight.w700, letterSpacing: 0, height: 1.25);

  /// 28 sp — section heading.
  static TextStyle get headlineMedium =>
      _p(size: 28, weight: FontWeight.w700, letterSpacing: 0, height: 1.29);

  /// 24 sp — sub-heading.
  static TextStyle get headlineSmall =>
      _p(size: 24, weight: FontWeight.w700, letterSpacing: 0, height: 1.33);

  // ── Title ────────────────────────────────────────────────────────────────────

  /// 22 sp — AppBar / dialog title.
  static TextStyle get titleLarge =>
      _p(size: 22, weight: FontWeight.w700, letterSpacing: 0, height: 1.27);

  /// 16 sp — card / list tile title.
  static TextStyle get titleMedium =>
      _p(size: 16, weight: FontWeight.w700, letterSpacing: 0.10, height: 1.50);

  /// 14 sp — secondary title / tab label.
  static TextStyle get titleSmall =>
      _p(size: 14, weight: FontWeight.w600, letterSpacing: 0.10, height: 1.43);

  // ── Body ─────────────────────────────────────────────────────────────────────

  /// 16 sp — primary readable paragraph text.
  static TextStyle get bodyLarge =>
      _p(size: 16, weight: FontWeight.w400, letterSpacing: 0.50, height: 1.50,
         color: AppColors.onSurface);

  /// 14 sp — default body / list subtitle.
  static TextStyle get bodyMedium =>
      _p(size: 14, weight: FontWeight.w400, letterSpacing: 0.25, height: 1.50,
         color: AppColors.onSurface);

  /// 12 sp — secondary / helper text.
  static TextStyle get bodySmall =>
      _p(size: 12, weight: FontWeight.w400, letterSpacing: 0.40, height: 1.50,
         color: AppColors.textSecondary);

  // ── Label ────────────────────────────────────────────────────────────────────

  /// 14 sp SemiBold — button labels, prominent tags.
  static TextStyle get labelLarge =>
      _p(size: 14, weight: FontWeight.w600, letterSpacing: 0.10, height: 1.43);

  /// 12 sp Medium — chip labels, secondary tags.
  static TextStyle get labelMedium =>
      _p(size: 12, weight: FontWeight.w500, letterSpacing: 0.50, height: 1.33,
         color: AppColors.textSecondary);

  /// 11 sp Medium — navigation bar labels, micro-copy.
  static TextStyle get labelSmall =>
      _p(size: 11, weight: FontWeight.w500, letterSpacing: 0.50, height: 1.45,
         color: AppColors.textSecondary);

  // ─────────────────────────────────────────────────────────────────────────────
  // Semantic aliases — prefer these in screens
  // ─────────────────────────────────────────────────────────────────────────────

  /// Main heading on a content screen.
  static TextStyle get screenTitle => headlineMedium;

  /// Second-level section heading inside a screen.
  static TextStyle get sectionHeading => headlineSmall;

  /// Card header / prominent label.
  static TextStyle get cardHeading => titleLarge;

  /// Standard paragraph / list content.
  static TextStyle get body => bodyMedium;

  /// Muted helper / caption text below inputs or images.
  static TextStyle get caption =>
      bodySmall.copyWith(color: AppColors.onSurfaceVariant);

  /// Error or validation message text.
  static TextStyle get errorText =>
      bodySmall.copyWith(color: AppColors.error);

  /// All-caps button / CTA label.
  static TextStyle get buttonLabel =>
      labelLarge.copyWith(letterSpacing: 0.8);

  /// AppBar centred title.
  static TextStyle get appBarTitle =>
      titleLarge.copyWith(fontSize: 18);

  /// Input field label (unfocused state).
  static TextStyle get inputLabel =>
      bodyMedium.copyWith(color: AppColors.onSurfaceVariant);

  /// Input field hint text.
  static TextStyle get inputHint =>
      bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
      );

  /// Snackbar / toast body text.
  static TextStyle get snackbarText =>
      bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500);

  /// Navigation bar destination label.
  static TextStyle get navLabel => labelSmall;

  // ─────────────────────────────────────────────────────────────────────────────
  // TextTheme builder
  // ─────────────────────────────────────────────────────────────────────────────

  /// Returns a [TextTheme] with all slots set to Poppins, tinted by
  /// [onSurface] / [onSurfaceVariant] from the given [colorScheme].
  ///
  /// Intended for use in [ThemeData.textTheme] / [ThemeData.primaryTextTheme].
  static TextTheme buildTextTheme(ColorScheme colorScheme) {
    final Color fg = colorScheme.onSurface;
    final Color fgMuted = colorScheme.onSurfaceVariant;

    return GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge:  displayLarge.copyWith(color: fg),
      displayMedium: displayMedium.copyWith(color: fg),
      displaySmall:  displaySmall.copyWith(color: fg),
      headlineLarge:  headlineLarge.copyWith(color: fg),
      headlineMedium: headlineMedium.copyWith(color: fg),
      headlineSmall:  headlineSmall.copyWith(color: fg),
      titleLarge:  titleLarge.copyWith(color: fg),
      titleMedium: titleMedium.copyWith(color: fg),
      titleSmall:  titleSmall.copyWith(color: fg),
      bodyLarge:  bodyLarge.copyWith(color: fg),
      bodyMedium: bodyMedium.copyWith(color: fg),
      bodySmall:  bodySmall.copyWith(color: fgMuted),
      labelLarge:  labelLarge.copyWith(color: fg),
      labelMedium: labelMedium.copyWith(color: fgMuted),
      labelSmall:  labelSmall.copyWith(color: fgMuted),
    );
  }
}
