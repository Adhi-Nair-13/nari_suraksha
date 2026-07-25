import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';
import 'package:nari_suraksha/core/widgets/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfilePage
// ─────────────────────────────────────────────────────────────────────────────

/// Premium user profile screen.
///
/// UI only — no backend. Sections:
///  1. Gradient hero   — large avatar, name, email, edit button
///  2. Safety Score    — animated circular gauge (UI only)
///  3. Medical Info    — blood group, allergies, conditions
///  4. Emergency Contacts summary  — 2 contacts preview
///  5. App Settings    — notifications, location, language
///  6. Privacy & Security — biometrics, data, permissions
///  7. About App       — version, rate, share, licenses
///  8. Logout button
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  // Entry animation
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  // Safety score gauge animation
  late final AnimationController _scoreCtrl;
  late final Animation<double> _scoreAnim;

  // Toggle states (UI only)
  bool _notificationsOn = true;
  bool _locationOn = true;
  bool _biometricOn = false;

  static const _userName = 'Priya Sharma';
  static const _userEmail = 'priya.sharma@example.com';
  static const _userPhone = '+91 98765 43210';

  // Safety score out of 100
  static const double _safetyScore = 82;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entryFade =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    _scoreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scoreAnim = Tween<double>(begin: 0, end: _safetyScore / 100).animate(
      CurvedAnimation(parent: _scoreCtrl, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        _entryCtrl.forward();
        _scoreCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _scoreCtrl.dispose();
    super.dispose();
  }

  // ── Logout confirmation ────────────────────────────────────────────────────

  Future<void> _confirmLogout() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Sign Out?',
      message:
          'You will be signed out of Nari Suraksha. Emergency features will be disabled.',
      confirmLabel: 'Sign Out',
      cancelLabel: 'Stay',
      isDangerous: true,
      icon: Icons.logout_rounded,
    );
    if (confirmed == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _entryFade,
        child: SlideTransition(
          position: _entrySlide,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Hero header ────────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildHero(cs)),

              // ── Safety score ───────────────────────────────────────────────
              _section(
                child: _SafetyScoreCard(
                  scoreAnim: _scoreAnim,
                  score: _safetyScore,
                  cs: cs,
                ),
              ),

              // ── Medical information ────────────────────────────────────────
              _sectionLabel('Medical Information', cs),
              _section(child: _MedicalInfoCard(cs: cs)),

              // ── Emergency contacts summary ─────────────────────────────────
              _sectionLabel('Emergency Contacts', cs),
              _section(child: _ContactsSummaryCard(cs: cs)),

              // ── App Settings ───────────────────────────────────────────────
              _sectionLabel('App Settings', cs),
              _section(
                child: _SettingsGroup(
                  cs: cs,
                  items: [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primaryContainer,
                      title: 'Notifications',
                      subtitle: 'Alert and reminder preferences',
                      trailing: Switch(
                        value: _notificationsOn,
                        onChanged: (v) =>
                            setState(() => _notificationsOn = v),
                        activeThumbColor: cs.onPrimary,
                        activeTrackColor: cs.primary,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.location_on_outlined,
                      iconColor: const Color(0xFF16A34A),
                      iconBg: const Color(0xFFDCFCE7),
                      title: 'Location Sharing',
                      subtitle: 'Share location during emergencies',
                      trailing: Switch(
                        value: _locationOn,
                        onChanged: (v) =>
                            setState(() => _locationOn = v),
                        activeThumbColor: cs.onPrimary,
                        activeTrackColor: cs.primary,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.language_rounded,
                      iconColor: const Color(0xFF7C3AED),
                      iconBg: const Color(0xFFEDE9FE),
                      title: 'Language',
                      subtitle: 'English (India)',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      iconColor: const Color(0xFF0E7490),
                      iconBg: const Color(0xFFCFFAFE),
                      title: 'Appearance',
                      subtitle: 'Light mode',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ),

              // ── Privacy & Security ─────────────────────────────────────────
              _sectionLabel('Privacy & Security', cs),
              _section(
                child: _SettingsGroup(
                  cs: cs,
                  items: [
                    _SettingsTile(
                      icon: Icons.fingerprint_rounded,
                      iconColor: const Color(0xFF9D174D),
                      iconBg: const Color(0xFFFCE7F3),
                      title: 'Biometric Lock',
                      subtitle: 'Fingerprint / Face ID',
                      trailing: Switch(
                        value: _biometricOn,
                        onChanged: (v) =>
                            setState(() => _biometricOn = v),
                        activeThumbColor: cs.onPrimary,
                        activeTrackColor: cs.primary,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primaryContainer,
                      title: 'Change Password',
                      subtitle: 'Last changed 30 days ago',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFF16A34A),
                      iconBg: const Color(0xFFDCFCE7),
                      title: 'Privacy Settings',
                      subtitle: 'Manage data & permissions',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.delete_outline_rounded,
                      iconColor: AppColors.error,
                      iconBg: AppColors.errorContainer,
                      title: 'Delete Account',
                      subtitle: 'Permanently remove your data',
                      titleColor: AppColors.error,
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ),

              // ── About App ──────────────────────────────────────────────────
              _sectionLabel('About', cs),
              _section(
                child: _SettingsGroup(
                  cs: cs,
                  items: [
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primaryContainer,
                      title: 'App Version',
                      subtitle: 'Nari Suraksha v1.0.0',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.star_outline_rounded,
                      iconColor: const Color(0xFF92400E),
                      iconBg: const Color(0xFFFEF3C7),
                      title: 'Rate the App',
                      subtitle: 'Share your feedback',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.share_outlined,
                      iconColor: const Color(0xFF7C3AED),
                      iconBg: const Color(0xFFEDE9FE),
                      title: 'Share App',
                      subtitle: 'Spread safety awareness',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      iconColor: cs.onSurfaceVariant,
                      iconBg: cs.surfaceContainerHighest,
                      title: 'Licenses & Terms',
                      subtitle: 'Open source licenses',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ),

              // ── Logout button ──────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.lg, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: DangerButton(
                    label: 'Sign Out',
                    icon: Icons.logout_rounded,
                    onPressed: _confirmLogout,
                  ),
                ),
              ),

              // ── Version footer ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.only(
                    top: AppSpacing.lg, bottom: AppSpacing.xxl),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Nari Suraksha · Built with ♥ for safety',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Wraps [child] in a horizontal-padded sliver with top spacing.
  Widget _section({required Widget child}) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
        sliver: SliverToBoxAdapter(child: child),
      );

  /// Section label sliver.
  Widget _sectionLabel(String title, ColorScheme cs) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
        sliver: SliverToBoxAdapter(
          child: SectionHeader(title: title, padding: EdgeInsets.zero),
        ),
      );

  // ── Hero section ──────────────────────────────────────────────────────────

  Widget _buildHero(ColorScheme cs) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.xl),
          child: Column(
            children: [
              // Avatar + edit badge
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  // Outer glow ring
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.onPrimary.withValues(alpha: 0.30),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          AppColors.onPrimary.withValues(alpha: 0.18),
                      child: Text(
                        'PS',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 34,
                        ),
                      ),
                    ),
                  ),
                  // Edit button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: cs.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Name
              Text(
                _userName,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              // Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined,
                      size: 14,
                      color: AppColors.onPrimary.withValues(alpha: 0.90)),
                  const SizedBox(width: 5),
                  Text(
                    _userEmail,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.80),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Phone
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_outlined,
                      size: 14,
                      color: AppColors.onPrimary.withValues(alpha: 0.90)),
                  const SizedBox(width: 5),
                  Text(
                    _userPhone,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.80),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Edit profile chip
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: AppColors.onPrimary.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_rounded,
                          size: 14, color: AppColors.onPrimary),
                      const SizedBox(width: 6),
                      Text(
                        'Edit Profile',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SafetyScoreCard
// ─────────────────────────────────────────────────────────────────────────────

class _SafetyScoreCard extends StatelessWidget {
  const _SafetyScoreCard({
    required this.scoreAnim,
    required this.score,
    required this.cs,
  });

  final Animation<double> scoreAnim;
  final double score;
  final ColorScheme cs;

  static const _green = Color(0xFF16A34A);
  static const _greenBg = Color(0xFFDCFCE7);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _greenBg,
            _greenBg.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: _green.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          // Circular gauge
          SizedBox(
            width: 90,
            height: 90,
            child: AnimatedBuilder(
              animation: scoreAnim,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: scoreAnim.value,
                    strokeWidth: 8,
                    backgroundColor:
                        _green.withValues(alpha: 0.15),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(_green),
                    strokeCap: StrokeCap.round,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(scoreAnim.value * 100).round()}',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: _green,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      Text(
                        '/100',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _green.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: _green, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Safety Score',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: _green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Your profile is well configured. Add more emergency contacts to improve your score.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF166534),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Stat chips
                const Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _ScoreChip(label: '4 Contacts', icon: Icons.people_rounded),
                    _ScoreChip(label: 'SOS Ready', icon: Icons.check_circle_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  static const _green = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: _green),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: _green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MedicalInfoCard
// ─────────────────────────────────────────────────────────────────────────────

class _MedicalInfoCard extends StatelessWidget {
  const _MedicalInfoCard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.local_hospital_rounded,
                      color: Color(0xFFDC2626), size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Medical Information',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: cs.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Edit',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: cs.primary),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: cs.outlineVariant),

          // Info rows
          _MedicalRow(
              icon: Icons.water_drop_rounded,
              iconColor: const Color(0xFFDC2626),
              label: 'Blood Group',
              value: 'B+',
              cs: cs),
          _MedicalRow(
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.warning,
              label: 'Allergies',
              value: 'Penicillin, Pollen',
              cs: cs),
          _MedicalRow(
              icon: Icons.medical_information_rounded,
              iconColor: cs.primary,
              label: 'Conditions',
              value: 'None reported',
              cs: cs),
          _MedicalRow(
              icon: Icons.medication_rounded,
              iconColor: const Color(0xFF7C3AED),
              label: 'Medications',
              value: 'None reported',
              cs: cs,
              isLast: true),
        ],
      ),
    );
  }
}

class _MedicalRow extends StatelessWidget {
  const _MedicalRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.cs,
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final ColorScheme cs;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: cs.outlineVariant),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ContactsSummaryCard
// ─────────────────────────────────────────────────────────────────────────────

class _ContactsSummaryCard extends StatelessWidget {
  const _ContactsSummaryCard({required this.cs});

  final ColorScheme cs;

  static const _contacts = <({
    String initials,
    String name,
    String relation,
    Color bg,
    Color fg,
  })>[
    (
      initials: 'AS',
      name: 'Ananya Sharma',
      relation: 'Mother',
      bg: Color(0xFFDBEAFE),
      fg: Color(0xFF1D4ED8),
    ),
    (
      initials: 'VS',
      name: 'Vikram Sharma',
      relation: 'Father',
      bg: Color(0xFFDCFCE7),
      fg: Color(0xFF16A34A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(Icons.contacts_rounded,
                      color: cs.primary, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Contacts',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '4 contacts configured',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: cs.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Manage',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: cs.primary),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: cs.outlineVariant),

          // Contact previews
          ..._contacts.map((c) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: c.bg,
                          child: Text(
                            c.initials,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: c.fg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                c.relation,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.phone_rounded,
                              color: cs.primary, size: 16),
                        ),
                      ],
                    ),
                  ),
                  if (c != _contacts.last)
                    Divider(height: 1, color: cs.outlineVariant),
                ],
              )),

          // "+ 2 more" footer
          Divider(height: 1, color: cs.outlineVariant),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '+ 2 more contacts',
              style: AppTextStyles.labelMedium
                  .copyWith(color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SettingsGroup  —  a card containing a list of _SettingsTile
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.items, required this.cs});

  final List<_SettingsTile> items;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: items
            .asMap()
            .entries
            .expand((e) => [
                  e.value,
                  if (!e.value.isLast)
                    Divider(height: 1, color: cs.outlineVariant),
                ])
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SettingsTile
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(
              bottom: Radius.circular(AppRadius.card))
          : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 12),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: titleColor ?? cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            // Trailing
            trailing ??
                Icon(Icons.chevron_right_rounded,
                    color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
