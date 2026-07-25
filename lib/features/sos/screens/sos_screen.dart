import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';
import 'package:nari_suraksha/core/widgets/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SosScreen
// ─────────────────────────────────────────────────────────────────────────────

/// Premium Emergency SOS screen.
///
/// UI only — no backend calls. Sections:
///  1. Custom top app bar (back button, title, info icon)
///  2. Hero SOS button with continuous pulse rings + 3-second hold preview
///  3. Countdown preview (3 → 2 → 1 design)
///  4. Emergency action cards (Police, Ambulance, Location, SMS)
///  5. Trusted contacts list (3 dummy entries)
///  6. Emergency instructions card
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
  // ── Pulse animation ─────────────────────────────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseScale1;
  late final Animation<double> _pulseOpacity1;
  late final Animation<double> _pulseScale2;
  late final Animation<double> _pulseOpacity2;

  // ── Hold countdown (UI only) ─────────────────────────────────────────────
  late final AnimationController _holdCtrl;
  late final Animation<double> _holdProgress;

  // ── Entry animation ──────────────────────────────────────────────────────
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  // Countdown digit shown during hold
  int _countdownDigit = 3;
  bool _isHolding = false;

  static const _sosRed = Color(0xFFEF4444);
  static const _buttonSize = 150.0;

  static const _emergencyActions = <_EmergencyAction>[
    _EmergencyAction(
      icon: Icons.local_police_rounded,
      label: 'Call Police',
      sublabel: 'Dial 100',
      color: Color(0xFF1D4ED8),
      bgColor: Color(0xFFDBEAFE),
    ),
    _EmergencyAction(
      icon: Icons.local_hospital_rounded,
      label: 'Call Ambulance',
      sublabel: 'Dial 108',
      color: Color(0xFFDC2626),
      bgColor: Color(0xFFFEE2E2),
    ),
    _EmergencyAction(
      icon: Icons.location_on_rounded,
      label: 'Share Live Location',
      sublabel: 'Send to contacts',
      color: Color(0xFF16A34A),
      bgColor: Color(0xFFDCFCE7),
    ),
    _EmergencyAction(
      icon: Icons.sms_rounded,
      label: 'Send Emergency SMS',
      sublabel: 'Alert guardians',
      color: Color(0xFF7C3AED),
      bgColor: Color(0xFFEDE9FE),
    ),
  ];

  static const _trustedContacts = <_TrustedContact>[
    _TrustedContact(name: 'Ananya Sharma', relation: 'Mother', initials: 'AS',
        bgColor: AppColors.pastYellow, fgColor: AppColors.pastYellowIcon),
    _TrustedContact(name: 'Rohan Nair', relation: 'Brother', initials: 'RN',
        bgColor: AppColors.pastGreen, fgColor: AppColors.pastGreenIcon),
    _TrustedContact(name: 'Divya Menon', relation: 'Best Friend', initials: 'DM',
        bgColor: AppColors.pastLavender, fgColor: AppColors.pastLavenderIcon),
  ];

  static const _instructions = <String>[
    'Stay calm and take slow, deep breaths.',
    'Move to a safe, well-lit public place.',
    'Keep your phone visible and charged.',
    'Wait for help — your location is being shared.',
  ];

  @override
  void initState() {
    super.initState();

    // ── Dual pulse rings (offset phase) ───────────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseScale1 = Tween<double>(begin: 1.0, end: 1.65).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOutCubic),
    );
    _pulseOpacity1 = Tween<double>(begin: 0.50, end: 0.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOutCubic),
    );

    // Second ring starts at 50% of the parent cycle
    _pulseScale2 = Tween<double>(begin: 1.0, end: 1.65).animate(
      CurvedAnimation(
        parent: _pulseCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _pulseOpacity2 = Tween<double>(begin: 0.50, end: 0.0).animate(
      CurvedAnimation(
        parent: _pulseCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // ── Hold countdown (3 s) ──────────────────────────────────────────────────
    _holdCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _holdProgress = CurvedAnimation(parent: _holdCtrl, curve: Curves.linear);

    _holdCtrl.addListener(() {
      final digit = 3 - (_holdCtrl.value * 3).floor();
      if (digit != _countdownDigit) setState(() => _countdownDigit = digit.clamp(1, 3));
    });

    _holdCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onSosTriggered();
      }
    });

    // ── Entry ─────────────────────────────────────────────────────────────────
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _holdCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── Hold logic ───────────────────────────────────────────────────────────────

  void _onHoldStart() {
    setState(() {
      _isHolding = true;
      _countdownDigit = 3;
    });
    HapticFeedback.mediumImpact();
    _holdCtrl.forward(from: 0);
  }

  void _onHoldEnd() {
    if (_holdCtrl.isCompleted) return; // already triggered
    setState(() {
      _isHolding = false;
      _countdownDigit = 3;
    });
    _holdCtrl.stop();
    _holdCtrl.reset();
  }

  void _onSosTriggered() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isHolding = false;
      _countdownDigit = 3;
    });
    _holdCtrl.reset();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'SOS Alert Sent! Emergency contacts notified.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _sosRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

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
              // ── Top app bar ──────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: cs.surface,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 1,
                leading: IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Back',
                ),
                title: Text(
                  'Emergency SOS',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => _showInfoDialog(context),
                    icon: Icon(Icons.info_outline_rounded,
                        color: cs.onSurfaceVariant),
                    tooltip: 'Emergency info',
                  ),
                  const SizedBox(width: 4),
                ],
              ),

              // ── Hero SOS button ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildHeroSection(cs),
              ),

              // ── Countdown preview ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, 0, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: _CountdownPreview(
                    digit: _countdownDigit,
                    progress: _holdProgress,
                    isActive: _isHolding,
                    cs: cs,
                  ),
                ),
              ),

              // ── Emergency actions ────────────────────────────────────────────
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Emergency Actions',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: _EmergencyActionsGrid(
                    actions: _emergencyActions,
                    cs: cs,
                  ),
                ),
              ),

              // ── Trusted contacts ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Trusted Contacts',
                    actionLabel: 'Manage',
                    onAction: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                sliver: SliverList.separated(
                  itemCount: _trustedContacts.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) =>
                      _ContactTile(contact: _trustedContacts[i], cs: cs),
                ),
              ),

              // ── Emergency instructions ───────────────────────────────────────
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Emergency Instructions',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xxl),
                sliver: SliverToBoxAdapter(
                  child: _InstructionsCard(
                    instructions: _instructions,
                    cs: cs,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero section ─────────────────────────────────────────────────────────────

  Widget _buildHeroSection(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _sosRed.withValues(alpha: 0.06),
            cs.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          // SOS button
          GestureDetector(
            onLongPressStart: (_) => _onHoldStart(),
            onLongPressEnd: (_) => _onHoldEnd(),
            onLongPressCancel: _onHoldEnd,
            child: AnimatedScale(
              scale: _isHolding ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: SizedBox(
                width: _buttonSize + 100,
                height: _buttonSize + 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulse ring 1
                    AnimatedBuilder(
                      animation: _pulseScale1,
                      builder: (_, __) => Transform.scale(
                        scale: _pulseScale1.value,
                        child: Opacity(
                          opacity: _pulseOpacity1.value,
                          child: Container(
                            width: _buttonSize,
                            height: _buttonSize,
                            decoration: const BoxDecoration(
                              color: _sosRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Outer pulse ring 2 (offset)
                    AnimatedBuilder(
                      animation: _pulseScale2,
                      builder: (_, __) => Transform.scale(
                        scale: _pulseScale2.value,
                        child: Opacity(
                          opacity: _pulseOpacity2.value,
                          child: Container(
                            width: _buttonSize,
                            height: _buttonSize,
                            decoration: const BoxDecoration(
                              color: _sosRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Inner glow
                    Container(
                      width: _buttonSize + 24,
                      height: _buttonSize + 24,
                      decoration: BoxDecoration(
                        color: _sosRed.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Main button
                    Container(
                      width: _buttonSize,
                      height: _buttonSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFF6B6B), _sosRed],
                          stops: [0.25, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _sosRed.withValues(alpha: 0.50),
                            blurRadius: 32,
                            spreadRadius: _isHolding ? 8 : 4,
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sos_rounded,
                              color: Colors.white, size: 58),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Labels
          Text(
            'Tap and Hold for 3 Seconds',
            style: AppTextStyles.titleLarge.copyWith(
              color: _sosRed,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This will notify your emergency contacts.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Info bottom sheet ─────────────────────────────────────────────────────────

  void _showInfoDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _InfoSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CountdownPreview
// ─────────────────────────────────────────────────────────────────────────────

class _CountdownPreview extends StatelessWidget {
  const _CountdownPreview({
    required this.digit,
    required this.progress,
    required this.isActive,
    required this.cs,
  });

  final int digit;
  final Animation<double> progress;
  final bool isActive;
  final ColorScheme cs;

  static const _sosRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isActive
            ? _sosRed.withValues(alpha: 0.08)
            : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isActive
              ? _sosRed.withValues(alpha: 0.40)
              : cs.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // Progress arc + digit
          SizedBox(
            width: 64,
            height: 64,
            child: AnimatedBuilder(
              animation: progress,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: isActive ? progress.value : 0,
                    strokeWidth: 5,
                    backgroundColor: cs.outlineVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(_sosRed),
                    strokeCap: StrokeCap.round,
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: isActive ? _sosRed : cs.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                    child: Text('$digit'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Description text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isActive ? _sosRed : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  child: Text(
                    isActive
                        ? 'SOS activating in $digit...'
                        : 'Hold to Activate SOS',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isActive
                      ? 'Release to cancel the alert.'
                      : 'Press and hold the button for 3 seconds.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Status dots
          Column(
            children: List.generate(3, (i) {
              final filled = isActive && (2 - i) >= (digit - 1);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: filled ? _sosRed : cs.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Emergency actions
// ─────────────────────────────────────────────────────────────────────────────

class _EmergencyAction {
  const _EmergencyAction({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final Color bgColor;
}

class _EmergencyActionsGrid extends StatelessWidget {
  const _EmergencyActionsGrid({
    required this.actions,
    required this.cs,
  });

  final List<_EmergencyAction> actions;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.15,
      ),
      itemCount: actions.length,
      itemBuilder: (context, i) =>
          _EmergencyActionCard(action: actions[i], cs: cs),
    );
  }
}

class _EmergencyActionCard extends StatefulWidget {
  const _EmergencyActionCard({required this.action, required this.cs});

  final _EmergencyAction action;
  final ColorScheme cs;

  @override
  State<_EmergencyActionCard> createState() => _EmergencyActionCardState();
}

class _EmergencyActionCardState extends State<_EmergencyActionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.action;
    final cs = widget.cs;

    return AnimatedBuilder(
      animation: _pressScale,
      builder: (_, child) =>
          Transform.scale(scale: _pressScale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _pressed = true);
          _pressCtrl.forward();
          HapticFeedback.selectionClick();
        },
        onTapUp: (_) {
          setState(() => _pressed = false);
          _pressCtrl.reverse();
        },
        onTapCancel: () {
          setState(() => _pressed = false);
          _pressCtrl.reverse();
        },
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${action.label} — UI only, no backend.',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: _pressed
                  ? action.color.withValues(alpha: 0.45)
                  : cs.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    action.color.withValues(alpha: _pressed ? 0.12 : 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: action.color,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(action.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: AppTextStyles.titleSmall.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                action.sublabel,
                style: AppTextStyles.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
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
// Trusted contact
// ─────────────────────────────────────────────────────────────────────────────

class _TrustedContact {
  const _TrustedContact({
    required this.name,
    required this.relation,
    required this.initials,
    required this.bgColor,
    required this.fgColor,
  });

  final String name;
  final String relation;
  final String initials;
  final Color bgColor;
  final Color fgColor;
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, required this.cs});

  final _TrustedContact contact;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: contact.bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: AppTextStyles.titleMedium.copyWith(
                  color: contact.fgColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Name + relation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.relation,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Phone action
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.phone_rounded,
              color: cs.primary,
              size: 22,
            ),
            style: IconButton.styleFrom(
              backgroundColor: cs.primaryContainer,
              minimumSize: const Size(40, 40),
              padding: const EdgeInsets.all(8),
            ),
            tooltip: 'Call ${contact.name}',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Instructions card
// ─────────────────────────────────────────────────────────────────────────────

class _InstructionsCard extends StatelessWidget {
  const _InstructionsCard({
    required this.instructions,
    required this.cs,
  });

  final List<String> instructions;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: cs.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Stay Safe — What To Do',
                style: AppTextStyles.titleSmall.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          // Instruction items
          ...instructions.asMap().entries.map((entry) {
            final idx = entry.key;
            final text = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Numbered dot
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${idx + 1}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _InfoSheet extends StatelessWidget {
  const _InfoSheet();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'About Emergency SOS',
              style: AppTextStyles.titleLarge.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text(
              'Emergency SOS is designed to instantly alert your trusted contacts '
              'when you are in danger. Hold the SOS button for 3 seconds to '
              'send an alert with your live location.\n\n'
              'Your contacts will receive an SMS and app notification with '
              'your real-time GPS coordinates. This feature works even in '
              'low connectivity areas.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            const StatusCard(
              icon: Icons.lock_rounded,
              title: 'Your Privacy is Protected',
              message:
                  'Location data is only shared during active emergencies.',
              variant: StatusVariant.info,
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
