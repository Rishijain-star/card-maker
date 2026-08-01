import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/welcome_wave_clipper.dart';
import '../../create_flow/controllers/create_flow_controller.dart';
import '../../login/controllers/login_controller.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';

const String _kHomeHeroAsset =
    'imagesss/ChatGPT Image Jun 1, 2026, 12_55_53 PM (1).png';

const String _kStudentIconAsset =
    'imagesss/graduate_icoin_-removebg-preview.png';

const String _kEmployeeIconAsset =
    'imagesss/empluye_id_card-removebg-preview.png';

const String _kSavedCardIconAsset =
    'imagesss/saved_card-removebg-preview.png';

const String _kServiceIconAsset =
    'imagesss/setting_icoin_-removebg-preview.png';

const String _kPolicyIconAsset =
    'imagesss/policy_icon_-removebg-preview.png';

const Color _kHeaderBlue = Color(0xFF1E88E5);
const Color _kHeaderBlueDark = Color(0xFF1565C0);
const Color _kBrandBlue = Color(0xFF2E66E7);

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<CreateFlowController>();

    // Guard: Splash/home should open only after login.
    final loggedIn = LocalStorageService().isLoggedIn();
    if (!loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Get.offAllNamed<void>(Routes.LOGIN),
      );
      return const SizedBox.shrink();
    }

    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final topInset = MediaQuery.paddingOf(context).top;
    // ~46% header — hero image fully visible; less empty space below cards.
    final headerHeight =
        (size.height * 0.445).clamp(275.0, size.height * 0.46);
    const gridGap = 8.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
        ),
        child: Column(
          children: [
            // —— Hero header (clipped — image cannot cover menu below) ——
            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [_kHeaderBlue, _kHeaderBlueDark],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        _kHomeHeroAsset,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    Positioned(
                      top: topInset + 6,
                      right: 10,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(22),
                        child: InkWell(
                          onTap: LoginController.signOut,
                          borderRadius: BorderRadius.circular(22),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Sign Out',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // —— Menu section (white, wave, cards) ——
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    top: -22,
                    child: ClipPath(
                      clipper: WelcomeWaveClipper(),
                      child: const ColoredBox(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: -18,
                    left: 20,
                    right: 20,
                    child: const _IdShaydiBanner(),
                  ),
                  Positioned.fill(
                    top: 42,
                    child: _HomeMenuSection(
                      menuCards: _buildMenuCards(flow),
                      gridGap: gridGap,
                      bottomInset: bottomInset,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuCards(CreateFlowController flow) {
    return [
      _HomeMenuCard(
        title: 'Student ID Card',
        accent: const Color(0xFF3B82F6),
        iconAsset: _kStudentIconAsset,
        onTap: () {
          flow.selectedService.value = 'Student ID Card';
          flow.selectedLayout.value = 'Portrait';
          flow.applyStudentDemoFields();
          Get.toNamed<void>(Routes.DETAILS_FORM);
        },
      ),
      _HomeMenuCard(
        title: 'Employee ID Card',
        accent: const Color(0xFF22C55E),
        iconAsset: _kEmployeeIconAsset,
        onTap: () {
          flow.selectedService.value = 'Employee ID Card';
          flow.selectedLayout.value = 'Portrait';
          flow.applyEmployeeDemoFields();
          Get.toNamed<void>(Routes.DETAILS_FORM);
        },
      ),
      _HomeMenuCard(
        title: 'Lanyard',
        accent: const Color(0xFFEC4899),
        icon: Icons.card_membership_outlined,
        onTap: () {
          flow.selectedService.value = 'Lanyard';
          flow.applyLanyardDemoFields();
          Get.toNamed<void>(Routes.DETAILS_FORM);
        },
      ),
      _HomeMenuCard(
        title: 'Saved Card',
        accent: const Color(0xFF8B5CF6),
        iconAsset: _kSavedCardIconAsset,
        onTap: () => Get.toNamed<void>(Routes.MY_DESIGNS),
      ),
      _HomeMenuCard(
        title: 'Products',
        accent: const Color(0xFF6366F1),
        iconAsset: _kServiceIconAsset,
        onTap: () => Get.toNamed<void>(Routes.SUBSCRIPTION),
      ),
    ];
  }
}

class _HomeMenuSection extends StatelessWidget {
  const _HomeMenuSection({
    required this.menuCards,
    required this.gridGap,
    required this.bottomInset,
  });

  final List<Widget> menuCards;
  final double gridGap;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    const cardH = _HomeMenuCard.cardHeight;
    const gridRows = 3; // 5 items in 2 columns
    const topPad = 6.0;
    final contentHeight = topPad +
        gridRows * cardH +
        (gridRows - 1) * gridGap +
        gridGap +
        cardH;

    final policyCard = _HomeMenuCard(
      title: 'Policy',
      accent: const Color(0xFFF97316),
      iconAsset: _kPolicyIconAsset,
      onTap: () => Get.toNamed<void>(Routes.TERMS),
    );

    final menuBody = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MenuGrid(gap: gridGap, children: menuCards),
        SizedBox(height: gridGap),
        policyCard,
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = EdgeInsets.fromLTRB(14, topPad, 14, bottomInset + 8);
        final needsScroll = contentHeight > constraints.maxHeight;

        if (needsScroll) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: padding,
            child: menuBody,
          );
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(14, 0, 14, bottomInset + 8),
          child: Column(
            children: [
              const SizedBox(height: topPad),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MenuGrid(gap: gridGap, children: menuCards),
                    policyCard,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IdShaydiBanner extends StatelessWidget {
  const _IdShaydiBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(child: _RainbowAccentLine()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'ID-SHAYDI',
              style: AppTextStyles.heading(context, size: 21).copyWith(
                color: _kBrandBlue,
                letterSpacing: 0.5,
                height: 1.1,
              ),
            ),
          ),
          const Expanded(child: _RainbowAccentLine()),
        ],
      ),
    );
  }
}

class _RainbowAccentLine extends StatelessWidget {
  const _RainbowAccentLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEF4444),
            Color(0xFFF97316),
            Color(0xFFEAB308),
            Color(0xFF22C55E),
            Color(0xFF3B82F6),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({required this.children, required this.gap});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  const _HomeMenuCard({
    required this.title,
    required this.accent,
    required this.onTap,
    this.icon,
    this.iconAsset,
  }) : assert(icon != null || iconAsset != null);

  static const double cardHeight = 74;
  static const double _iconCircleSize = 42;
  static const double _iconImageSize = 28;

  final String title;
  final Color accent;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onTap;

  Color get _cardBackground =>
      Color.lerp(Colors.white, accent, 0.025) ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: cardHeight,
          decoration: BoxDecoration(
            color: _cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accent.withValues(alpha: 0.34),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.14),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: _iconCircleSize,
                  height: _iconCircleSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: iconAsset != null
                      ? Image.asset(
                          iconAsset!,
                          width: _iconImageSize,
                          height: _iconImageSize,
                          fit: BoxFit.contain,
                        )
                      : Icon(icon, color: accent, size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heading(
                      context,
                      size: title.length > 14 ? 11.5 : 12.5,
                    ).copyWith(
                      height: 1.2,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 18,
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
