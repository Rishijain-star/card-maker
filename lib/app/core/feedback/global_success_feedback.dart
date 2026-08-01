import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../navigation/user_home_navigation.dart';
import '../sounds/ui_sounds.dart';

/// Reusable success moment: chime + Lottie (same asset/duration app-wide).
abstract final class GlobalSuccessFeedback {
  static const Duration _displayDuration = Duration(milliseconds: 2400);

  /// Shows centered success card, plays sound, auto-dismisses after [_displayDuration].
  static Future<void> present({
    required String title,
    String? subtitle,
  }) async {
    await Get.dialog<void>(
      _SuccessDialogBody(
        title: title,
        subtitle: subtitle,
        autoCloseAfter: _displayDuration,
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
    );
  }

  /// Ride published → global feedback, then root shell (driver or passenger).
  static Future<void> presentRidePublished() async {
    await present(
      title: 'ride_flow.publish_success_title'.tr,
      subtitle: 'ride_flow.publish_success_sub'.tr,
    );
    UserHomeNavigation.offAllToUserHome();
  }
}

class _SuccessDialogBody extends StatefulWidget {
  const _SuccessDialogBody({
    required this.title,
    this.subtitle,
    required this.autoCloseAfter,
  });

  final String title;
  final String? subtitle;
  final Duration autoCloseAfter;

  @override
  State<_SuccessDialogBody> createState() => _SuccessDialogBodyState();
}

class _SuccessDialogBodyState extends State<_SuccessDialogBody> {
  @override
  void initState() {
    super.initState();
    unawaited(UiSounds.playSuccessChime());
    Future<void>.delayed(widget.autoCloseAfter, () {
      if (!mounted) return;
      final nav = Navigator.maybeOf(context);
      if (nav != null && nav.canPop()) {
        nav.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width * 0.86,
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  child: Lottie.asset(
                    'assets/lottie/Success.json',
                    fit: BoxFit.contain,
                    repeat: false,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
