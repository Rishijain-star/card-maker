import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';
import '../widgets/auth_ui_widgets.dart';
import 'login_view.dart';

class RegisterView extends GetView<LoginController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenShell(
      title: 'Create Account',
      subtitle: 'Register to start designing ID cards',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthSectionHeader(label: 'Register'),
          UnderlineAuthField(
            hint: 'Full Name',
            controller: controller.registerFullNameCtrl,
            icon: const Icon(Icons.person_rounded, size: 22, color: kAuthFormBlue),
            kHint: kAuthHint,
            kUnderline: kAuthUnderline,
          ),
          UnderlineAuthField(
            hint: 'Mobile Number',
            controller: controller.registerMobileCtrl,
            keyboardType: TextInputType.phone,
            icon: const Icon(Icons.phone_rounded, size: 22, color: kAuthFormBlue),
            kHint: kAuthHint,
            kUnderline: kAuthUnderline,
          ),
          UnderlineAuthField(
            hint: 'Email Address',
            controller: controller.registerEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            icon: const Icon(Icons.mail_outline_rounded, size: 22, color: kAuthFormBlue),
            kHint: kAuthHint,
            kUnderline: kAuthUnderline,
          ),
          Obx(
            () => UnderlineAuthField(
              hint: 'Password',
              controller: controller.registerPasswordCtrl,
              obscureText: controller.obscurePassword.value,
              icon: const Icon(Icons.lock_outline_rounded, size: 22, color: kAuthFormBlue),
              suffixIcon: IconButton(
                onPressed: controller.toggleObscurePassword,
                icon: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: kAuthFormBlue,
                ),
              ),
              kHint: kAuthHint,
              kUnderline: kAuthUnderline,
            ),
          ),
          Obx(
            () => UnderlineAuthField(
              hint: 'Confirm Password',
              controller: controller.registerConfirmPasswordCtrl,
              obscureText: controller.obscurePassword.value,
              icon: const Icon(Icons.lock_reset_rounded, size: 22, color: kAuthFormBlue),
              kHint: kAuthHint,
              kUnderline: kAuthUnderline,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: controller.registerAndLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAuthBrandBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'REGISTER',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Get.back<void>(),
              child: Text(
                'Back to Login',
                style: GoogleFonts.poppins(
                  color: kAuthBrandBlue,
                  fontWeight: FontWeight.w600,
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
