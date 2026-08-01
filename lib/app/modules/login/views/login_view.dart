import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';
import '../widgets/auth_ui_widgets.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenShell(
      title: 'Welcome Back',
      subtitle: 'Sign in to create your ID cards',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthSectionHeader(label: 'Login'),
          UnderlineAuthField(
            hint: 'Email or Mobile',
            controller: controller.loginIdCtrl,
            icon: const Icon(
              Icons.person_outline_rounded,
              size: 22,
              color: kAuthFormBlue,
            ),
            keyboardType: TextInputType.emailAddress,
            kHint: kAuthHint,
            kUnderline: kAuthUnderline,
          ),
          Obx(
            () => UnderlineAuthField(
              hint: 'Password',
              controller: controller.loginPasswordCtrl,
              obscureText: controller.obscurePassword.value,
              icon: const Icon(
                Icons.lock_outline_rounded,
                size: 22,
                color: kAuthFormBlue,
              ),
              kHint: kAuthHint,
              kUnderline: kAuthUnderline,
              suffixIcon: IconButton(
                onPressed: controller.toggleObscurePassword,
                icon: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: kAuthFormBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: controller.login,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAuthBrandBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                'LOGIN',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => Get.toNamed<void>(Routes.REGISTER),
              child: Text(
                "Don't have an account? Register",
                style: GoogleFonts.poppins(
                  color: kAuthBrandBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Get.toNamed<void>(Routes.WELCOME),
              child: Text(
                'Back',
                style: GoogleFonts.poppins(
                  color: kAuthHint,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnderlineAuthField extends StatelessWidget {
  const UnderlineAuthField({
    super.key,
    required this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    required this.kHint,
    required this.kUnderline,
  });

  final String hint;
  final TextEditingController controller;
  final Widget icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Color kHint;
  final Color kUnderline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 30, height: 30, child: Center(child: icon)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    filled: false,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF94A3B8)
                          : kHint,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: suffixIcon,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                Divider(height: 1, thickness: 1.2, color: kUnderline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
