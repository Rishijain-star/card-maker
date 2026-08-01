import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../routes/app_pages.dart';
import '../../../core/widgets/welcome_wave_clipper.dart';

const String _kWelcomeHeroAsset =
    'imagesss/ChatGPT Image Jun 1, 2026, 11_38_45 AM.png';

const Color _kSkyTop = Color(0xFF8FC4E8);
const Color _kSkyBottom = Color(0xFFD2E9F8);

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final whitePanelHeight = size.height * 0.46;

    return Scaffold(
      backgroundColor: _kSkyBottom,
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // —— Top: sky + hero (≈58% screen) ——
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.58,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_kSkyTop, _kSkyBottom],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    left: -24,
                    child: _DecorCircle(size: 100, opacity: 0.28),
                  ),
                  Positioned(
                    top: 48,
                    right: -20,
                    child: _DecorCircle(size: 72, opacity: 0.22),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      _kWelcomeHeroAsset,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ],
              ),
            ),
            // —— Bottom: white panel with curved top (reference layout) ——
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: whitePanelHeight,
              child: ClipPath(
                clipper: WelcomeWaveClipper(),
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      44,
                      AppSpacing.lg,
                      bottomInset + AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Welcome to',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(context, size: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ID-SHAYDI',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading(context, size: 34).copyWith(
                            color: const Color(0xFF2E66E7),
                            letterSpacing: 0.4,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Create, manage and share your\nID cards easily.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(context, size: 15).copyWith(
                            height: 1.45,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const _PageDots(activeIndex: 0),
                        const Spacer(),
                        _GetStartedButton(
                          onPressed: () {
                            final loggedIn = LocalStorageService().isLoggedIn();
                            Get.offAllNamed<void>(
                              loggedIn ? Routes.SPLASH : Routes.LOGIN,
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _SignInRow(
                          onSignIn: () => Get.toNamed<void>(Routes.LOGIN),
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
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF2E66E7);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final active = index == activeIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 9 : 8,
          height: active ? 9 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? activeColor
                : activeColor.withValues(alpha: 0.22),
          ),
        );
      }),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E66E7),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Get Started', style: AppTextStyles.button(context)),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded, size: 24),
          ],
        ),
      ),
    );
  }
}

class _SignInRow extends StatelessWidget {
  const _SignInRow({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyles.body(context, size: 14),
        ),
        GestureDetector(
          onTap: onSignIn,
          child: Text(
            'Sign In',
            style: AppTextStyles.body(context, size: 14).copyWith(
              color: const Color(0xFF2E66E7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
