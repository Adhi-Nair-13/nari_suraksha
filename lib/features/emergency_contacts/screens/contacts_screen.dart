import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';
import 'package:nari_suraksha/core/widgets/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ContactsScreen
// ─────────────────────────────────────────────────────────────────────────────

/// Premium Emergency Contacts screen.
///
/// UI only — no backend. Sections:
///  1. Gradient header  — title, subtitle, contact count badge
///  2. Search bar       — filters the visible contact list
///  3. Contacts list    — 4 dummy cards with avatar, name, relation, phone,
///                        call + message buttons, long-press options sheet
///  4. How-it-works card — info card explaining emergency notification flow
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with TickerProviderStateMixin {
  // ── Entry animation ──────────────────────────────────────────────────────
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  // ── Stagger controller for contact cards ────────────────────────────────
  late final AnimationController _staggerCtrl;

  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  // ── Dummy contacts ───────────────────────────────────────────────────────
  static const List<_Contact> _allContacts = [
    _Contact(
      name: 'Ananya Sharma',
      relation: 'Mother',
      phone: '+91 98765 43210',
      initials: 'AS',
      avatarBg: AppColors.pastYellow,
      avatarFg: AppColors.pastYellowIcon,
      tag: _ContactTag.family,
    ),
    _Contact(
      name: 'Vikram Sharma',
      relation: 'Father',
      phone: '+91 98765 43211',
      initials: 'VS',
      avatarBg: AppColors.pastGreen,
      avatarFg: AppColors.pastGreenIcon,
      tag: _ContactTag.family,
    ),
    _Contact(
      name: 'Divya Menon',
      relation: 'Best Friend',
      phone: '+91 91234 56789',
      initials: 'DM',
      avatarBg: AppColors.pastLavender,
      avatarFg: AppColors.pastLavenderIcon,
      tag: _ContactTag.friend,
    ),
    _Contact(
      name: 'Preethi Nair',
      relation: 'Sister',
      phone: '+91 90123 45678',
      initials: 'PN',
      avatarBg: AppColors.pastPeach,
      avatarFg: AppColors.pastPeachIcon,
      tag: _ContactTag.family,
    ),
  ];

  List<_Contact> get _filtered => _query.isEmpty
      ? _allContacts
      : _allContacts
          .where((c) =>
              c.name.toLowerCase().contains(_query.toLowerCase()) ||
              c.relation.toLowerCase().contains(_query.toLowerCase()) ||
              c.phone.contains(_query))
          .toList();

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
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) {
        _entryCtrl.forward();
        _staggerCtrl.forward();
      }
    });

    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim());
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _staggerCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Add contact sheet (UI only) ──────────────────────────────────────────

  void _showAddContactSheet() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final relationCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddContactSheet(
        nameCtrl: nameCtrl,
        phoneCtrl: phoneCtrl,
        relationCtrl: relationCtrl,
      ),
    );
  }

  // ── Contact options sheet ────────────────────────────────────────────────

  void _showContactOptions(BuildContext ctx, _Contact contact) {
    BottomActionSheet.show(
      context: ctx,
      title: contact.name,
      subtitle: contact.relation,
      actions: [
        SheetAction(
          icon: Icons.phone_rounded,
          label: 'Call',
          subtitle: contact.phone,
          onTap: () {},
        ),
        SheetAction(
          icon: Icons.message_rounded,
          label: 'Send Message',
          onTap: () {},
        ),
        SheetAction(
          icon: Icons.edit_rounded,
          label: 'Edit Contact',
          onTap: () {},
        ),
        SheetAction(
          icon: Icons.delete_outline_rounded,
          label: 'Remove Contact',
          isDangerous: true,
          onTap: () {},
        ),
      ],
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final contacts = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContactSheet,
        icon: const Icon(Icons.person_add_rounded),
        label: Text(
          'Add Contact',
          style: AppTextStyles.labelLarge.copyWith(color: cs.onPrimary),
        ),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 3,
      ),
      body: FadeTransition(
        opacity: _entryFade,
        child: SlideTransition(
          position: _entrySlide,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Gradient header ────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildHeader(cs)),

              // ── Search bar ─────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: _SearchBar(controller: _searchCtrl),
                ),
              ),

              // ── Section label ──────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.lg, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Text(
                        'My Contacts',
                        style: AppTextStyles.sectionHeading.copyWith(
                          color: cs.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '${contacts.length} / 5',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Contact cards ──────────────────────────────────────────────
              if (contacts.isEmpty)
                const SliverPadding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  sliver: SliverToBoxAdapter(
                    child: EmptyStateWidget(
                      icon: Icons.contacts_outlined,
                      title: 'No contacts found',
                      message:
                          'Try a different search term or add a new contact.',
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                  sliver: SliverList.separated(
                    itemCount: contacts.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final start = (i * 0.12).clamp(0.0, 0.7);
                      final end = (start + 0.40).clamp(0.0, 1.0);
                      final fade = Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _staggerCtrl,
                          curve: Interval(start, end,
                              curve: Curves.easeOut),
                        ),
                      );
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.12),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _staggerCtrl,
                          curve: Interval(start, end,
                              curve: Curves.easeOut),
                        ),
                      );
                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(
                          position: slide,
                          child: _ContactCard(
                            contact: contacts[i],
                            cs: cs,
                            onLongPress: () =>
                                _showContactOptions(context, contacts[i]),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // ── How-it-works card ──────────────────────────────────────────
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'How It Works',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.xxl + AppSpacing.xl),
                sliver: SliverToBoxAdapter(
                  child: _HowItWorksCard(cs: cs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(ColorScheme cs) {
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
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Row(
            children: [
              // Text block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contacts',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'These contacts will be notified during an emergency.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.80),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Shield icon badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: AppColors.onPrimary,
                  size: 28,
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
// _SearchBar
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: 'Search contacts…',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: cs.onSurfaceVariant,
        ),
        prefixIcon: Icon(Icons.search_rounded,
            color: cs.onSurfaceVariant, size: 22),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, val, __) => val.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: cs.onSurfaceVariant, size: 20),
                  onPressed: controller.clear,
                )
              : const SizedBox.shrink(),
        ),
        filled: true,
        fillColor: cs.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact model
// ─────────────────────────────────────────────────────────────────────────────

enum _ContactTag { family, friend, other }

class _Contact {
  const _Contact({
    required this.name,
    required this.relation,
    required this.phone,
    required this.initials,
    required this.avatarBg,
    required this.avatarFg,
    required this.tag,
  });

  final String name;
  final String relation;
  final String phone;
  final String initials;
  final Color avatarBg;
  final Color avatarFg;
  final _ContactTag tag;
}

// ─────────────────────────────────────────────────────────────────────────────
// _ContactCard
// ─────────────────────────────────────────────────────────────────────────────

class _ContactCard extends StatefulWidget {
  const _ContactCard({
    required this.contact,
    required this.cs,
    required this.onLongPress,
  });

  final _Contact contact;
  final ColorScheme cs;
  final VoidCallback onLongPress;

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  static IconData _tagIcon(_ContactTag tag) => switch (tag) {
        _ContactTag.family => Icons.family_restroom_rounded,
        _ContactTag.friend => Icons.people_rounded,
        _ContactTag.other => Icons.person_rounded,
      };

  static Color _tagColor(_ContactTag tag, ColorScheme cs) => switch (tag) {
        _ContactTag.family => const Color(0xFF16A34A),
        _ContactTag.friend => cs.primary,
        _ContactTag.other => cs.onSurfaceVariant,
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.contact;
    final cs = widget.cs;

    return AnimatedBuilder(
      animation: _pressScale,
      builder: (_, child) =>
          Transform.scale(scale: _pressScale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) => _pressCtrl.reverse(),
        onTapCancel: () => _pressCtrl.reverse(),
        onLongPress: () {
          HapticFeedback.mediumImpact();
          widget.onLongPress();
        },
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // ── Top row: avatar + info + tag ─────────────────────────────
                Row(
                  children: [
                    // Avatar with online-style border
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.avatarFg.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: c.avatarBg,
                        child: Text(
                          c.initials,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: c.avatarFg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSpacing.md),

                    // Name + relation + phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                _tagIcon(c.tag),
                                size: 13,
                                color: _tagColor(c.tag, cs),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                c.relation,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: _tagColor(c.tag, cs),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            c.phone,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // More options
                    IconButton(
                      onPressed: widget.onLongPress,
                      icon: Icon(Icons.more_vert_rounded,
                          color: cs.onSurfaceVariant, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                          minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),
                Divider(height: 1, color: cs.outlineVariant),
                const SizedBox(height: AppSpacing.sm),

                // ── Action buttons ───────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: AppColors.secondary,
                        bgColor: AppColors.secondaryContainer,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calling ${c.name}…'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        color: cs.primary,
                        bgColor: cs.primaryContainer,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Messaging ${c.name}…'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
// _ActionButton
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 110));
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 16, color: widget.color),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: widget.color,
                  fontSize: 13,
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
// _HowItWorksCard
// ─────────────────────────────────────────────────────────────────────────────

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.cs});

  final ColorScheme cs;

  static const _steps = <_HowStep>[
    _HowStep(
      icon: Icons.sos_rounded,
      title: 'SOS Triggered',
      description: 'You hold the SOS button for 3 seconds.',
    ),
    _HowStep(
      icon: Icons.location_on_rounded,
      title: 'Location Captured',
      description:
          'Your real-time GPS location is captured immediately.',
    ),
    _HowStep(
      icon: Icons.sms_rounded,
      title: 'Contacts Notified',
      description:
          'All contacts here receive an SMS and app alert with your location.',
    ),
    _HowStep(
      icon: Icons.phone_in_talk_rounded,
      title: 'Help Dispatched',
      description:
          'Your contacts can see your live location and call for help.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.info_outline_rounded,
                    color: cs.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'How Emergency Contacts Work',
                style: AppTextStyles.titleSmall.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: cs.primary.withValues(alpha: 0.15)),
          const SizedBox(height: AppSpacing.md),

          // Steps
          ...List.generate(_steps.length, (i) {
            final step = _steps[i];
            final isLast = i == _steps.length - 1;
            return _StepRow(
                step: step, index: i, isLast: isLast, cs: cs);
          }),
        ],
      ),
    );
  }
}

class _HowStep {
  const _HowStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.index,
    required this.isLast,
    required this.cs,
  });

  final _HowStep step;
  final int index;
  final bool isLast;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — number + connector line
        SizedBox(
          width: 36,
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(step.icon, color: cs.onPrimary, size: 14),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 36,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // Right — text
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AddContactSheet  (UI only)
// ─────────────────────────────────────────────────────────────────────────────

class _AddContactSheet extends StatelessWidget {
  const _AddContactSheet({
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.relationCtrl,
  });

  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController relationCtrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.sm),
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
                'Add Emergency Contact',
                style: AppTextStyles.titleLarge.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'This person will be alerted during emergencies.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Name field
              CustomTextField(
                controller: nameCtrl,
                label: 'Full Name',
                hint: 'e.g. Ananya Sharma',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: AppSpacing.md),

              // Relation field
              CustomTextField(
                controller: relationCtrl,
                label: 'Relationship',
                hint: 'e.g. Mother, Friend, Sister',
                prefixIcon: Icons.family_restroom_rounded,
              ),
              const SizedBox(height: AppSpacing.md),

              // Phone field
              CustomTextField(
                controller: phoneCtrl,
                label: 'Phone Number',
                hint: '+91 98765 43210',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.lg),

              PrimaryButton(
                label: 'Save Contact',
                onPressed: () => Navigator.pop(context),
                icon: Icons.check_rounded,
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
