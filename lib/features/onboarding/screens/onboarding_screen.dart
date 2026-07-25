import 'dart:math' as math;
import 'dart:ui' show PathMetric, PathMetrics, Tangent;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nari_suraksha/core/routes/app_routes.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/core/theme/app_text_styles.dart';
import 'package:nari_suraksha/core/widgets/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

/// Immutable data for a single onboarding page.
class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.gradientColors,
    required this.illustrationPainter,
  });

  final String title;
  final String description;
  final IconData icon;

  /// Accent used for the icon container and indicator dot.
  final Color accentColor;

  /// Background gradient for this page.
  final List<Color> gradientColors;

  /// Function that returns the page-specific illustration painter widget.
  final Widget Function(Animation<double> anim) illustrationPainter;
}

// ─────────────────────────────────────────────────────────────────────────────
// OnboardingScreen
// ─────────────────────────────────────────────────────────────────────────────

/// Premium four-page onboarding flow for Nari Suraksha.
///
/// Uses [PageView] with a custom [PageScrollPhysics] for smooth swipe,
/// combined with two animation layers:
///   1. Per-page entrance: fade + slide-up content.
///   2. Inter-page: shared background gradient cross-fade.
///
/// Navigates to [AppRoutes.login] on "Get Started".
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── Page state ──────────────────────────────────────────────────────────────
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Fractional scroll position used for smooth indicator interpolation.
  double _pageOffset = 0.0;

  // ── Per-page entrance animation ─────────────────────────────────────────────
  late final AnimationController _entranceCtrl;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  // ── Illustration loop animation ──────────────────────────────────────────────
  late final AnimationController _loopCtrl;

  // ── Page definitions ────────────────────────────────────────────────────────
  late final List<_OnboardingPage> _pages;

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _buildAnimations();
    _buildPages();

    _pageController.addListener(() {
      if (mounted) {
        setState(() => _pageOffset = _pageController.page ?? 0);
      }
    });
  }

  void _setupSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // dark icons on warm bg
    ));
  }

  void _buildAnimations() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _contentFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));

    _loopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _entranceCtrl.forward();
  }

  void _buildPages() {
    _pages = [
      _OnboardingPage(
        title: 'Instant Emergency SOS',
        description:
            'Send your live location and emergency alert to trusted contacts with a single tap.',
        icon: Icons.emergency_rounded,
        accentColor: AppColors.error,
        gradientColors: const [
          Color(0xFFFFF3C4), // soft gold top
          AppColors.primaryContainer,
          Color(0xFFFFE082), // golden bottom
        ],
        illustrationPainter: (anim) => _SosIllustration(animation: anim),
      ),
      _OnboardingPage(
        title: 'Real-Time Live Tracking',
        description:
            'Allow family members and emergency contacts to track your location safely.',
        icon: Icons.location_on_rounded,
        accentColor: AppColors.secondary,
        gradientColors: const [
          Color(0xFFCCFBF1), // soft mint top
          AppColors.secondaryContainer,
          Color(0xFF99F6E4), // teal bottom
        ],
        illustrationPainter: (anim) => _LocationIllustration(animation: anim),
      ),
      _OnboardingPage(
        title: 'AI Voice Threat Detection',
        description:
            'Detect danger keywords and trigger emergency actions automatically.',
        icon: Icons.mic_rounded,
        accentColor: AppColors.tertiary,
        gradientColors: const [
          Color(0xFFEDE9FE), // lavender top
          AppColors.tertiaryContainer,
          Color(0xFFC4B5FD), // deeper lavender bottom
        ],
        illustrationPainter: (anim) => _VoiceIllustration(animation: anim),
      ),
      _OnboardingPage(
        title: 'Safe Route Navigation',
        description:
            'Navigate through safer routes with emergency support always available.',
        icon: Icons.map_rounded,
        accentColor: const Color(0xFF5EC7B7),
        gradientColors: const [
          Color(0xFFF0FDFA), // very soft teal
          Color(0xFFCCFBF1),
          Color(0xFF99F6E4),
        ],
        illustrationPainter: (anim) => _RouteIllustration(animation: anim),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceCtrl.dispose();
    _loopCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _goToNext() {
    if (_isLastPage) {
      _navigateToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipToLogin() => _navigateToLogin();

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _entranceCtrl.reset();
    _entranceCtrl.forward();
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.sizeOf(context);
    final bool isSmall = screen.height < 680;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── 1. Animated gradient background ──────────────────────────────
          _AnimatedGradientBackground(
            pages: _pages,
            pageOffset: _pageOffset,
          ),

          // ── 2. Decorative blobs ───────────────────────────────────────────
          _DecorativeBlobs(screen: screen, pageOffset: _pageOffset),

          // ── 3. Main content ───────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Skip row
                _SkipRow(
                  visible: !_isLastPage,
                  onSkip: _skipToLogin,
                ),

                // PageView fills remaining vertical space
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _pages.length,
                    itemBuilder: (_, index) => _PageContent(
                      page: _pages[index],
                      contentFade: _contentFade,
                      contentSlide: _contentSlide,
                      loopAnimation: _loopCtrl,
                      isSmall: isSmall,
                    ),
                  ),
                ),

                // Bottom nav area
                _BottomNav(
                  pageCount: _pages.length,
                  currentPage: _currentPage,
                  pageOffset: _pageOffset,
                  pages: _pages,
                  isLastPage: _isLastPage,
                  onNext: _goToNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skip Row
// ─────────────────────────────────────────────────────────────────────────────

class _SkipRow extends StatelessWidget {
  const _SkipRow({required this.visible, required this.onSkip});
  final bool visible;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: TextButton(
            onPressed: visible ? onSkip : null,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onBackground.withValues(alpha: 0.60),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
            ),
            child: Text(
              'Skip',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.onBackground.withValues(alpha: 0.85),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page content
// ─────────────────────────────────────────────────────────────────────────────

class _PageContent extends StatelessWidget {
  const _PageContent({
    required this.page,
    required this.contentFade,
    required this.contentSlide,
    required this.loopAnimation,
    required this.isSmall,
  });

  final _OnboardingPage page;
  final Animation<double> contentFade;
  final Animation<Offset> contentSlide;
  final Animation<double> loopAnimation;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final double illustrationSize = isSmall ? 200.0 : 260.0;

    return FadeTransition(
      opacity: contentFade,
      child: SlideTransition(
        position: contentSlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Illustration ────────────────────────────────────────────
              SizedBox(
                width: illustrationSize,
                height: illustrationSize,
                child: page.illustrationPainter(loopAnimation),
              ),

              SizedBox(height: isSmall ? AppSpacing.lg : AppSpacing.xxl),

              // ── Title ────────────────────────────────────────────────────
              Text(
                page.title,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Description ──────────────────────────────────────────────
              Text(
                page.description,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation area
// ─────────────────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.pageCount,
    required this.currentPage,
    required this.pageOffset,
    required this.pages,
    required this.isLastPage,
    required this.onNext,
  });

  final int pageCount;
  final int currentPage;
  final double pageOffset;
  final List<_OnboardingPage> pages;
  final bool isLastPage;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Smooth indicator ──────────────────────────────────────────
          _SmoothPageIndicator(
            pageCount: pageCount,
            pageOffset: pageOffset,
            pages: pages,
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── CTA button ────────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: isLastPage
                ? PrimaryButton(
                    key: const ValueKey('get_started'),
                    label: 'Get Started',
                    onPressed: onNext,
                    icon: Icons.arrow_forward_rounded,
                  )
                : _NextButton(
                    key: const ValueKey('next'),
                    onPressed: onNext,
                    currentPage: currentPage,
                    pageCount: pageCount,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Smooth page indicator
// ─────────────────────────────────────────────────────────────────────────────

class _SmoothPageIndicator extends StatelessWidget {
  const _SmoothPageIndicator({
    required this.pageCount,
    required this.pageOffset,
    required this.pages,
  });

  final int pageCount;
  final double pageOffset;
  final List<_OnboardingPage> pages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        // Fractional proximity of this dot to the current scroll offset.
        final double proximity = (pageOffset - index).abs().clamp(0.0, 1.0);
        final double width = 8.0 + (1.0 - proximity) * 20.0; // 8 → 28 dp
        final double opacity = 0.35 + (1.0 - proximity) * 0.65;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: width,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Next button (non-last pages)
// ─────────────────────────────────────────────────────────────────────────────

class _NextButton extends StatelessWidget {
  const _NextButton({
    super.key,
    required this.onPressed,
    required this.currentPage,
    required this.pageCount,
  });

  final VoidCallback onPressed;
  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Page counter text
        Expanded(
          child: Text(
            '${currentPage + 1} of $pageCount',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onBackground.withValues(alpha: 0.55),
            ),
          ),
        ),
        // Gold pill Next button
        FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: const StadiumBorder(),
            minimumSize: const Size(120, 52),
            elevation: 0,
            shadowColor: AppColors.primary.withValues(alpha: 0.40),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Next',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated gradient background
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedGradientBackground extends StatelessWidget {
  const _AnimatedGradientBackground({
    required this.pages,
    required this.pageOffset,
  });

  final List<_OnboardingPage> pages;
  final double pageOffset;

  /// Linearly interpolates two [Color] lists element-by-element.
  List<Color> _lerpGradients(List<Color> a, List<Color> b, double t) {
    return List.generate(
      math.min(a.length, b.length),
      (i) => Color.lerp(a[i], b[i], t)!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int fromIndex = pageOffset.floor().clamp(0, pages.length - 1);
    final int toIndex = (fromIndex + 1).clamp(0, pages.length - 1);
    final double t = pageOffset - fromIndex;

    final List<Color> colors = _lerpGradients(
      pages[fromIndex].gradientColors,
      pages[toIndex].gradientColors,
      t.clamp(0.0, 1.0),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Decorative blobs
// ─────────────────────────────────────────────────────────────────────────────

class _DecorativeBlobs extends StatelessWidget {
  const _DecorativeBlobs({required this.screen, required this.pageOffset});
  final Size screen;
  final double pageOffset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -screen.width * 0.30,
          left: -screen.width * 0.25,
          child: Container(
            width: screen.width * 0.85,
            height: screen.width * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary.withValues(alpha: 0.05),
            ),
          ),
        ),
        Positioned(
          bottom: -screen.width * 0.35,
          right: -screen.width * 0.22,
          child: Container(
            width: screen.width * 0.78,
            height: screen.width * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary.withValues(alpha: 0.06),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Illustration widgets — one per page
// ─────────────────────────────────────────────────────────────────────────────

/// Base illustration widget with a common layout: outer ring + icon container.
abstract class _BaseIllustration extends StatelessWidget {
  const _BaseIllustration({required this.animation});
  final Animation<double> animation;

  /// Primary icon shown inside the logo circle.
  IconData get primaryIcon;

  /// Colour of the logo ring.
  Color get ringColor;

  /// Optional extra widget rendered on top of the base.
  Widget? buildOverlay(BuildContext context, Animation<double> anim) => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final double pulse = 0.97 + animation.value * 0.06; // subtle breathing

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing ring
            Transform.scale(
              scale: pulse,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ringColor.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Mid ring
            Container(
              width: 164,
              height: 164,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.08),
                border: Border.all(
                  color: AppColors.onPrimary.withValues(alpha: 0.18),
                  width: 1.2,
                ),
              ),
            ),
            // Icon container
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.15),
                border: Border.all(
                  color: AppColors.onPrimary.withValues(alpha: 0.30),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.20),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                primaryIcon,
                size: 52,
                color: AppColors.onPrimary,
              ),
            ),

            // Page-specific decoration
            if (buildOverlay(context, animation) != null)
              buildOverlay(context, animation)!,
          ],
        );
      },
    );
  }
}

// ── Page 1 — SOS ──────────────────────────────────────────────────────────────

class _SosIllustration extends _BaseIllustration {
  const _SosIllustration({required super.animation});

  @override
  IconData get primaryIcon => Icons.emergency_rounded;

  @override
  Color get ringColor => AppColors.error;

  @override
  Widget? buildOverlay(BuildContext ctx, Animation<double> anim) {
    // Three alert dots orbiting the shield at 120° increments.
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (i) {
        final double angle = (i * 2 * math.pi / 3) + anim.value * math.pi;
        const double r = 92.0;
        final double dx = r * math.cos(angle);
        final double dy = r * math.sin(angle);
        return Transform.translate(
          offset: Offset(dx, dy),
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error,
              border: Border.all(
                color: AppColors.onPrimary.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── Page 2 — Location ─────────────────────────────────────────────────────────

class _LocationIllustration extends _BaseIllustration {
  const _LocationIllustration({required super.animation});

  @override
  IconData get primaryIcon => Icons.location_on_rounded;

  @override
  Color get ringColor => AppColors.secondary;

  @override
  Widget? buildOverlay(BuildContext ctx, Animation<double> anim) {
    // Expanding location ping circle.
    return Opacity(
      opacity: 1.0 - anim.value,
      child: Transform.scale(
        scale: 1.0 + anim.value * 0.6,
        child: Container(
          width: 164,
          height: 164,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.secondary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Page 3 — Voice ────────────────────────────────────────────────────────────

class _VoiceIllustration extends _BaseIllustration {
  const _VoiceIllustration({required super.animation});

  @override
  IconData get primaryIcon => Icons.mic_rounded;

  @override
  Color get ringColor => AppColors.tertiary;

  @override
  Widget? buildOverlay(BuildContext ctx, Animation<double> anim) {
    // Waveform bars that grow with the animation.
    const int barCount = 5;
    const List<double> maxHeights = [20, 36, 52, 36, 20];

    return Positioned(
      bottom: 22,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barCount, (i) {
          final double phase = (i / (barCount - 1));
          final double t = ((anim.value + phase) % 1.0);
          final double h = 8 + (maxHeights[i] - 8) * math.sin(t * math.pi).abs();
          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            width: 6,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(AppRadius.chip),
            ),
          );
        }),
      ),
    );
  }
}

// ── Page 4 — Route ────────────────────────────────────────────────────────────

class _RouteIllustration extends _BaseIllustration {
  const _RouteIllustration({required super.animation});

  @override
  IconData get primaryIcon => Icons.map_rounded;

  @override
  Color get ringColor => const Color(0xFF0EA5E9);

  @override
  Widget? buildOverlay(BuildContext ctx, Animation<double> anim) {
    // Dashed path drawn with CustomPaint.
    return CustomPaint(
      size: const Size(200, 200),
      painter: _RoutePainter(
        progress: anim.value,
        color: AppColors.onPrimary.withValues(alpha: 0.55),
      ),
    );
  }
}

/// Draws a simple animated dashed path from bottom-left to top-right.
class _RoutePainter extends CustomPainter {
  _RoutePainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.35, size.height * 0.60,
        size.width * 0.50, size.height * 0.50,
      )
      ..quadraticBezierTo(
        size.width * 0.65, size.height * 0.40,
        size.width * 0.82, size.height * 0.22,
      );

    final PathMetrics metrics = path.computeMetrics();
    for (final PathMetric m in metrics) {
      final double len = m.length * progress;
      final Path sub = m.extractPath(0, len);
      // Draw as dashes manually.
      const double dashLen = 8.0;
      const double gapLen  = 5.0;
      double d = 0;
      final PathMetrics subMetrics = sub.computeMetrics();
      for (final PathMetric sm in subMetrics) {
        while (d < sm.length) {
          final double end = (d + dashLen).clamp(0, sm.length);
          canvas.drawPath(sm.extractPath(d, end), paint);
          d += dashLen + gapLen;
        }
      }
    }

    // Draw moving dot at current progress tip.
    if (progress > 0) {
      final PathMetrics m2 = path.computeMetrics();
      for (final PathMetric metric in m2) {
        final double tipPos = metric.length * progress;
        final Tangent? tangent = metric.getTangentForOffset(tipPos);
        if (tangent != null) {
          canvas.drawCircle(
            tangent.position,
            5,
            Paint()
              ..color = color.withValues(alpha: 1.0)
              ..style = PaintingStyle.fill,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_RoutePainter old) => old.progress != progress;
}
