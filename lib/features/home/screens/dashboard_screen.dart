import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';
import 'package:nari_suraksha/core/widgets/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DashboardScreen
// ─────────────────────────────────────────────────────────────────────────────

/// Premium home dashboard for authenticated users.
///
/// Sections (top → bottom):
///  1. Gradient header  — time-aware greeting, user name, notification bell, avatar
///  2. Safety status card  — "You are Safe" (green accent)
///  3. Hero SOS button  — large circular button with repeating pulse rings
///  4. Quick-actions grid  — 8 features in a 2-column grid with stagger animation
///  5. Recent alerts placeholder card
///  6. Daily safety tip card (gradient accent)
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  // Pulse animation for the SOS button
  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // Screen-entry fade + slide
  late final AnimationController _entryController;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  // Stagger controller for quick-action grid cards
  late final AnimationController _staggerController;

  static const String _userName = 'Priya'; // placeholder

  static const List<_QuickAction> _quickActions = [
    _QuickAction(
      icon: Icons.contacts_rounded,
      label: 'Emergency\nContacts',
      color: AppColors.pastYellowIcon,
      bgColor: AppColors.pastYellow,
    ),
    _QuickAction(
      icon: Icons.location_on_rounded,
      label: 'Live\nTracking',
      color: AppColors.pastBlueIcon,
      bgColor: AppColors.pastBlue,
    ),
    _QuickAction(
      icon: Icons.route_rounded,
      label: 'Safe\nRoute',
      color: AppColors.pastPurpleIcon,
      bgColor: AppColors.pastPurple,
    ),
    _QuickAction(
      icon: Icons.phone_callback_rounded,
      label: 'Fake\nCall',
      color: AppColors.pastPeachIcon,
      bgColor: AppColors.pastPeach,
    ),
    _QuickAction(
      icon: Icons.mic_rounded,
      label: 'Voice\nDetection',
      color: AppColors.pastGreenIcon,
      bgColor: AppColors.pastGreen,
    ),
    _QuickAction(
      icon: Icons.videocam_rounded,
      label: 'Hidden\nCamera',
      color: AppColors.pastMintIcon,
      bgColor: AppColors.pastMint,
    ),
    _QuickAction(
      icon: Icons.timer_rounded,
      label: 'Safety\nTimer',
      color: AppColors.pastLavenderIcon,
      bgColor: AppColors.pastLavender,
    ),
    _QuickAction(
      icon: Icons.smart_toy_rounded,
      label: 'AI\nAssistant',
      color: AppColors.pastCyanIcon,
      bgColor: AppColors.pastCyan,
    ),
  ];

  static const List<String> _safetyTips = [
    'Share your live location with a trusted contact before traveling alone.',
    'Keep your phone charged above 30% when heading out.',
    'Save local emergency numbers under ICE (In Case of Emergency).',
    'Walk in well-lit, populated areas whenever possible at night.',
    'Trust your instincts — if something feels wrong, leave immediately.',
    'Inform someone of your expected arrival time and route.',
    'Avoid wearing headphones in both ears while walking alone.',
    'Keep a personal alarm or whistle accessible at all times.',
  ];

  /// 15 motivational safety quotes, rotated daily.
  static const List<String> _motivationalQuotes = [
    'Your safety is our highest priority. ✨',
    'Stay aware. Stay confident. 💡',
    'You are never alone. We are with you. 🤝',
    'Small precautions create big protection. 🛡️',
    'Confidence is your greatest strength. 💪',
    'Prepared today. Protected tomorrow. 🌟',
    'Safety begins with awareness. 👀',
    'You deserve to feel secure every day. ❤️',
    'Your journey matters. We keep you safe. 📍',
    'Stay strong. Stay safe. 🌿',
    'Confidence is your best protection. 🔥',
    'Trust yourself. You know what to do. 🌈',
    'Safety is not a privilege — it is your right. 💯',
    'Every step you take, we are right beside you. 💛',
    'Be alert, be aware, be amazing. 🌚',
  ];

  late final String _todayTip;
  late final String _todayQuote;

  @override
  void initState() {
    super.initState();

    // Daily tip + motivational quote rotate by day-of-year
    final dayOfYear = DateTime.now()
            .difference(DateTime(DateTime.now().year, 1, 1))
            .inDays;
    _todayTip = _safetyTips[dayOfYear % _safetyTips.length];
    _todayQuote = _motivationalQuotes[dayOfYear % _motivationalQuotes.length];

    // ── Pulse ─────────────────────────────────────────────────────────────────
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseScale = Tween<double>(begin: 1.0, end: 1.55).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutCubic),
    );
    _pulseOpacity = Tween<double>(begin: 0.55, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutCubic),
    );

    // ── Entry ────────────────────────────────────────────────────────────────
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entryFade = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    // ── Stagger ──────────────────────────────────────────────────────────────
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        _entryController.forward();
        _staggerController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

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
              // ── Gradient header ────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildHeader(cs)),

              // ── Safety status ──────────────────────────────────────────────
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: StatusCard(
                    icon: Icons.shield_rounded,
                    title: 'You are Safe',
                    message: 'No emergency detected.',
                    variant: StatusVariant.success,
                  ),
                ),
              ),

              // ── SOS hero ───────────────────────────────────────────────────
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                sliver: SliverToBoxAdapter(
                  child: _SosButton(
                    pulseScale: _pulseScale,
                    pulseOpacity: _pulseOpacity,
                  ),
                ),
              ),

              // ── Quick actions label ────────────────────────────────────────
              const SliverPadding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Quick Actions',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              // ── Quick actions grid ─────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: _QuickActionsGrid(
                    actions: _quickActions,
                    staggerController: _staggerController,
                  ),
                ),
              ),

              // ── Recent alerts label ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Recent Alerts',
                    actionLabel: 'See all',
                    onAction: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              // ── Recent alerts card ─────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: _RecentAlertsCard(cs: cs),
                ),
              ),

              // ── Daily tip label ────────────────────────────────────────────
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Daily Safety Tip',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              // ── Daily tip card ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xxl),
                sliver: SliverToBoxAdapter(
                  child: _SafetyTipCard(tip: _todayTip, cs: cs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header widget ───────────────────────────────────────────────────────────

  Widget _buildHeader(ColorScheme cs) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,      // warm gold
            AppColors.primaryDark,  // deeper gold
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Greeting + name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_greeting,',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.90),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_userName 👋',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification bell
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined),
                        color: AppColors.onPrimary,
                        tooltip: 'Notifications',
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: AppSpacing.xs),

                  // Avatar
                  CircularAvatarWidget(
                    name: _userName,
                    radius: 22,
                    backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
                    foregroundColor: AppColors.onPrimary,
                    badge: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryDark,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Motivational quote
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: AppColors.onPrimary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _todayQuote,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.90),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
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
// _SosButton
// ─────────────────────────────────────────────────────────────────────────────

class _SosButton extends StatefulWidget {
  const _SosButton({
    required this.pulseScale,
    required this.pulseOpacity,
  });

  final Animation<double> pulseScale;
  final Animation<double> pulseOpacity;

  @override
  State<_SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<_SosButton> {
  bool _pressed = false;

  static const Color _sosRed = Color(0xFFEF4444);
  static const double _buttonSize = 140;

  void _showConfirmation(BuildContext ctx) {
    ConfirmationDialog.show(
      context: ctx,
      title: 'Send SOS Alert?',
      message:
          'This will immediately alert your emergency contacts and share your live location.',
      confirmLabel: 'Send SOS',
      isDangerous: true,
      icon: Icons.sos_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            _showConfirmation(context);
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.93 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: SizedBox(
              width: _buttonSize + 80,
              height: _buttonSize + 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer repeating pulse ring
                  AnimatedBuilder(
                    animation: widget.pulseScale,
                    builder: (_, __) => Transform.scale(
                      scale: widget.pulseScale.value,
                      child: Opacity(
                        opacity: widget.pulseOpacity.value,
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
                  // Soft inner glow ring
                  Container(
                    width: _buttonSize + 22,
                    height: _buttonSize + 22,
                    decoration: BoxDecoration(
                      color: _sosRed.withValues(alpha: 0.12),
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
                        stops: [0.3, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _sosRed.withValues(alpha: 0.45),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sos_rounded,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Emergency SOS',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap only in emergency',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick action model
// ─────────────────────────────────────────────────────────────────────────────

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
}

// ─────────────────────────────────────────────────────────────────────────────
// _QuickActionsGrid
// ─────────────────────────────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.actions,
    required this.staggerController,
  });

  final List<_QuickAction> actions;
  final AnimationController staggerController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.55,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final start = (index * 0.10).clamp(0.0, 0.8);
        final end = (start + 0.35).clamp(0.0, 1.0);

        final fadeIn = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: staggerController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );
        final slideIn = Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: staggerController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

        return FadeTransition(
          opacity: fadeIn,
          child: SlideTransition(
            position: slideIn,
            child: _QuickActionTile(action: actions[index]),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _QuickActionTile
// ─────────────────────────────────────────────────────────────────────────────

class _QuickActionTile extends StatefulWidget {
  const _QuickActionTile({required this.action});

  final _QuickAction action;

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final action = widget.action;

    return AnimatedBuilder(
      animation: _pressScale,
      builder: (_, child) =>
          Transform.scale(scale: _pressScale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _hovered = true);
          _pressCtrl.forward();
        },
        onTapUp: (_) {
          setState(() => _hovered = false);
          _pressCtrl.reverse();
        },
        onTapCancel: () {
          setState(() => _hovered = false);
          _pressCtrl.reverse();
        },
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: _hovered
                  ? action.color.withValues(alpha: 0.40)
                  : cs.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: action.color.withValues(alpha: _hovered ? 0.10 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: action.color,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(action.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    action.label,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RecentAlertsCard
// ─────────────────────────────────────────────────────────────────────────────

class _RecentAlertsCard extends StatelessWidget {
  const _RecentAlertsCard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 44,
            color: cs.onSurfaceVariant.withValues(alpha: 0.45),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No Recent Alerts',
            style: AppTextStyles.titleSmall.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Alerts and notifications will appear here.',
            style: AppTextStyles.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SafetyTipCard
// ─────────────────────────────────────────────────────────────────────────────

class _SafetyTipCard extends StatelessWidget {
  const _SafetyTipCard({required this.tip, required this.cs});

  final String tip;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tertiary.withValues(alpha: 0.12),
            AppColors.primary.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: AppColors.tertiary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Tip",
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: cs.onSurface,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
