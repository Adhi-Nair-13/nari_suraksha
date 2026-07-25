/// App-wide compile-time constant values.
///
/// Centralise all magic strings and numbers here so they can be updated
/// in a single place and are easily discoverable.
abstract final class AppConstants {
  // ── App Identity ────────────────────────────────────────────────────────────

  /// The human-readable application name shown in the title bar.
  static const String appName = 'Nari Suraksha';

  // ── Emergency Dial Numbers ──────────────────────────────────────────────────

  /// National police emergency number (India).
  static const String policeNumber = '100';

  /// Pan-India single emergency number.
  static const String emergencyNumber = '112';

  // ── Default Seed Contacts ───────────────────────────────────────────────────

  /// Display name for the first pre-seeded guardian.
  static const String defaultContact1Name = 'Mom';

  /// Phone number for the first pre-seeded guardian.
  static const String defaultContact1Phone = '+91 98765 43210';

  /// Display name for the second pre-seeded guardian.
  static const String defaultContact2Name = 'Dad';

  /// Phone number for the second pre-seeded guardian.
  static const String defaultContact2Phone = '+91 87654 32109';
}
