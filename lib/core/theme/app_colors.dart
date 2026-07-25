import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppColors  —  Warm, Premium, Trustworthy
// ─────────────────────────────────────────────────────────────────────────────

/// Brand and semantic colour design tokens for Nari Suraksha.
///
/// Redesigned palette: Warm Safety Gold primary, Soft Teal secondary,
/// Lavender accent. Conveys safety, calm, and premium quality.
///
/// All values are compile-time [const] — zero runtime cost.
abstract final class AppColors {
  // ── Primary — Warm Safety Gold #FFC83D ──────────────────────────────────────
  static const Color primary              = Color(0xFFFFC83D);
  static const Color primaryLight         = Color(0xFFFFD76B);
  static const Color primaryDark          = Color(0xFFE5A800);
  static const Color onPrimary            = Color(0xFF202124); // dark on gold
  static const Color primaryContainer     = Color(0xFFFFF3C4); // soft gold tint
  static const Color onPrimaryContainer   = Color(0xFF5C3D00);
  static const Color inversePrimary       = Color(0xFFFFD76B);

  // ── Secondary — Soft Teal #5EC7B7 ───────────────────────────────────────────
  static const Color secondary            = Color(0xFF5EC7B7);
  static const Color secondaryLight       = Color(0xFF84D7CB);
  static const Color secondaryDark        = Color(0xFF3AADA0);
  static const Color onSecondary          = Color(0xFFFFFFFF);
  static const Color secondaryContainer   = Color(0xFFCCF5F0); // very soft teal
  static const Color onSecondaryContainer = Color(0xFF003D38);

  // ── Tertiary — Lavender #8B80F9 ─────────────────────────────────────────────
  static const Color tertiary             = Color(0xFF8B80F9);
  static const Color onTertiary           = Color(0xFFFFFFFF);
  static const Color tertiaryContainer    = Color(0xFFE5E0FF); // soft lavender
  static const Color onTertiaryContainer  = Color(0xFF2B0094);

  // ── Semantic: Error / Danger #E53935 ────────────────────────────────────────
  static const Color error                = Color(0xFFE53935);
  static const Color onError              = Color(0xFFFFFFFF);
  static const Color errorContainer       = Color(0xFFFFDAD6);
  static const Color onErrorContainer     = Color(0xFF7F0017);

  // ── Semantic: Status ─────────────────────────────────────────────────────────
  static const Color success              = Color(0xFF45C486);
  static const Color warning              = Color(0xFFF59E0B);
  static const Color info                 = Color(0xFF5EC7B7); // teal for info

  // ── Light — Surface & Background ─────────────────────────────────────────────
  static const Color background           = Color(0xFFFFFDF8); // warm cream
  static const Color onBackground         = Color(0xFF202124);
  static const Color surface              = Color(0xFFFFFFFF);
  static const Color onSurface            = Color(0xFF202124);
  static const Color surfaceVariant       = Color(0xFFF5F3EE); // warm tinted
  static const Color onSurfaceVariant     = Color(0xFF6B7280);

  // ── Semantic text colours ─────────────────────────────────────────────────────
  /// High-contrast heading colour — WCAG AA compliant on cream/white surfaces.
  static const Color textPrimary   = Color(0xFF1F2937);
  /// Muted body / caption colour for secondary information.
  static const Color textSecondary = Color(0xFF6B7280);

  // ── Light — Surface containers (M3 elevation layers) ─────────────────────────
  static const Color surfaceContainerLowest  = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow     = Color(0xFFFFFDF8); // warm cream
  static const Color surfaceContainer        = Color(0xFFF5F3EE);
  static const Color surfaceContainerHigh    = Color(0xFFEDEBE4);
  static const Color surfaceContainerHighest = Color(0xFFE5E3DC);

  // ── Light — Outline ───────────────────────────────────────────────────────────
  static const Color outline              = Color(0xFFD9D4C7); // warm outline
  static const Color outlineVariant       = Color(0xFFEBE9E2);

  // ── Light — Inverse ───────────────────────────────────────────────────────────
  static const Color inverseSurface       = Color(0xFF37352F);
  static const Color onInverseSurface     = Color(0xFFF5F3EE);

  // ── Dark — Surface & Background ───────────────────────────────────────────────
  static const Color darkBackground      = Color(0xFF1A1814);
  static const Color darkOnBackground    = Color(0xFFF5F3EE);
  static const Color darkSurface         = Color(0xFF27241F);
  static const Color darkOnSurface       = Color(0xFFF5F3EE);
  static const Color darkSurfaceVariant  = Color(0xFF3D3A34);
  static const Color darkOnSurfaceVariant = Color(0xFFBFBAB0);

  // ── Dark — Surface containers ─────────────────────────────────────────────────
  static const Color darkSurfaceContainerLowest  = Color(0xFF1A1814);
  static const Color darkSurfaceContainerLow     = Color(0xFF27241F);
  static const Color darkSurfaceContainer        = Color(0xFF3D3A34);
  static const Color darkSurfaceContainerHigh    = Color(0xFF524F48);
  static const Color darkSurfaceContainerHighest = Color(0xFF67635B);

  // ── Dark — Outline ────────────────────────────────────────────────────────────
  static const Color darkOutline         = Color(0xFF524F48);
  static const Color darkOutlineVariant  = Color(0xFF3D3A34);

  // ── Dark — Containers ─────────────────────────────────────────────────────────
  static const Color darkPrimaryContainer      = Color(0xFF5C3D00);
  static const Color darkOnPrimaryContainer    = Color(0xFFFFF3C4);
  static const Color darkSecondaryContainer    = Color(0xFF003D38);
  static const Color darkOnSecondaryContainer  = Color(0xFFCCF5F0);
  static const Color darkTertiaryContainer     = Color(0xFF2B0094);
  static const Color darkOnTertiaryContainer   = Color(0xFFE5E0FF);
  static const Color darkErrorContainer        = Color(0xFF7F0017);
  static const Color darkOnErrorContainer      = Color(0xFFFFDAD6);

  // ── Dark — Inverse ────────────────────────────────────────────────────────────
  static const Color darkInverseSurface    = Color(0xFFF5F3EE);
  static const Color darkOnInverseSurface  = Color(0xFF1A1814);

  // ── Shared ────────────────────────────────────────────────────────────────────
  static const Color shadow               = Color(0xFF000000);
  static const Color scrim                = Color(0xFF000000);
  static const Color transparent          = Color(0x00000000);

  // ── Pastel quick-action palette ───────────────────────────────────────────────
  /// Each quick-action card has a dedicated pastel background + icon colour.
  static const Color pastYellow           = Color(0xFFFFF3C4);
  static const Color pastYellowIcon       = Color(0xFFE5A800);
  static const Color pastBlue             = Color(0xFFDBEAFE);
  static const Color pastBlueIcon         = Color(0xFF1D4ED8);
  static const Color pastPurple           = Color(0xFFEDE9FE);
  static const Color pastPurpleIcon       = Color(0xFF7C3AED);
  static const Color pastGreen            = Color(0xFFD1FAE5);
  static const Color pastGreenIcon        = Color(0xFF059669);
  static const Color pastPeach            = Color(0xFFFFE4CC);
  static const Color pastPeachIcon        = Color(0xFFEA580C);
  static const Color pastMint             = Color(0xFFCCFBF1);
  static const Color pastMintIcon         = Color(0xFF0F766E);
  static const Color pastLavender         = Color(0xFFE0E7FF);
  static const Color pastLavenderIcon     = Color(0xFF4F46E5);
  static const Color pastCyan             = Color(0xFFCFFAFE);
  static const Color pastCyanIcon         = Color(0xFF0891B2);
}

// ─────────────────────────────────────────────────────────────────────────────
// AppSpacing
// ─────────────────────────────────────────────────────────────────────────────

/// Standardised spacing scale (4 pt grid).
abstract final class AppSpacing {
  static const double xxs =  2.0;
  static const double xs  =  4.0;
  static const double sm  =  8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
  static const double x3l = 64.0;

  /// Tight inner padding for compact elements (chips, badges).
  static const double compactPadding = xs;

  /// Standard card / section inner padding.
  static const double cardPadding = md;

  /// Screen-level horizontal margin.
  static const double screenPadding = md;

  /// Space between related items in a list.
  static const double itemSpacing = sm;

  /// Space between unrelated sections.
  static const double sectionSpacing = xl;
}

// ─────────────────────────────────────────────────────────────────────────────
// AppRadius  —  Softer, more premium corners
// ─────────────────────────────────────────────────────────────────────────────

/// Standardised border-radius scale. Increased for premium, softer feel.
abstract final class AppRadius {
  static const double xs   =  4.0;
  static const double sm   =  8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xxl  = 28.0; // increased from 24 → 28
  static const double full = 100.0;

  /// Default button corner radius.
  static const double button = xl;   // stadium-like for premium feel

  /// Card corner radius — softer at 20.
  static const double card = xl;     // increased from 16 → 20

  /// Input field corner radius.
  static const double input = lg;    // increased from 12 → 16

  /// Bottom sheet / dialog top radius.
  static const double sheet = xxl;

  /// Chip / pill-shaped elements.
  static const double chip = full;
}
