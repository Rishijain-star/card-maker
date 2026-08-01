import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/widgets/auth/tm_auth_hero_shell.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return TmAuthHeroShell(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 12, 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back<void>(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: isDark ? scheme.onSurface : TmAuthTokens.primaryGreen,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Reset password',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: isDark ? scheme.onSurface : TmAuthTokens.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: TmAuthTokens.primaryGreen.withValues(alpha: isDark ? 0.5 : 0.35),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TmAuthLayout.hPad,
                    TmAuthLayout.topPad,
                    TmAuthLayout.hPad,
                    TmAuthLayout.bodyBottomPad,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: c.maxWidth, maxHeight: c.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                  const SizedBox(height: 12),
                  Text(
                    'We’ll email you a link',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                      color: isDark ? scheme.onSurface.withValues(alpha: 0.75) : TmAuthTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      filled: true,
                      fillColor: scheme.surface,
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: TmAuthTokens.textSecondary,
                      ),
                      hintStyle: GoogleFonts.inter(color: TmAuthTokens.textSecondary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.28)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: TripMatesColors.green, width: 1.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Check spam if you don’t see it within a few minutes.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? scheme.onSurface.withValues(alpha: 0.65) : TmAuthTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Get.back<void>(),
                      style: FilledButton.styleFrom(
                        backgroundColor: TmAuthTokens.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'Send reset link',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.back<void>(),
                      child: Text(
                        'Back to log in',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: TmAuthTokens.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ),
          ),
        );
              },
            ),
          ),
        ],
      ),
    );
  }
}
