import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../services/social_auth_service/social_auth_service.dart';
import '../../create_flow/controllers/create_flow_controller.dart';

class LoginController extends GetxController {
  final RxBool obscurePassword = true.obs;
  final RxBool isSubmitting = false.obs;

  // Login inputs
  final TextEditingController loginIdCtrl = TextEditingController();
  final TextEditingController loginPasswordCtrl = TextEditingController();

  // Register required inputs
  final TextEditingController registerFullNameCtrl = TextEditingController();
  final TextEditingController registerMobileCtrl = TextEditingController();
  final TextEditingController registerEmailCtrl = TextEditingController();
  final TextEditingController registerPasswordCtrl = TextEditingController();
  final TextEditingController registerConfirmPasswordCtrl =
      TextEditingController();

  SocialAuthService get _social => Get.find<SocialAuthService>();
  CreateFlowController get _flow => Get.find<CreateFlowController>();

  void toggleObscurePassword() => obscurePassword.toggle();

  Future<void> _persistLocalProfile({
    String? fullName,
    String? mobile,
    String? email,
  }) async {
    final storage = LocalStorageService();
    if (fullName != null && fullName.trim().isNotEmpty) {
      await storage.setUserName(fullName.trim());
    }
    if (mobile != null && mobile.trim().isNotEmpty) {
      await storage.setUserPhone(mobile.trim());
    }
    if (email != null && email.trim().isNotEmpty) {
      await storage.setEmailId(email.trim());
    }
    await storage.setLegalGateAccepted(true);
  }

  Future<void> login() async {
    if (isSubmitting.value) return;

    final input = loginIdCtrl.text.trim();
    final password = loginPasswordCtrl.text;
    final isEmail = input.contains('@');

    if (!isEmail) {
      Get.snackbar(
        'Email required',
        'Please sign in with your registered email address.',
      );
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Password', 'Enter your account password.');
      return;
    }

    isSubmitting.value = true;
    try {
      final ok = await ApiRepository.login(email: input, password: password);
      if (!ok) {
        Get.snackbar(
          'Login failed',
          'Invalid email or password. Try again or create an account.',
        );
        return;
      }

      await _persistLocalProfile(email: input);
      _flow.markLoginSuccess();
      Get.offAllNamed<void>(Routes.SPLASH);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> registerAndLogin() async {
    if (isSubmitting.value) return;

    final fullName = registerFullNameCtrl.text.trim();
    final mobile = registerMobileCtrl.text.trim();
    final email = registerEmailCtrl.text.trim();
    final password = registerPasswordCtrl.text;
    final confirm = registerConfirmPasswordCtrl.text;

    if (fullName.isEmpty) {
      Get.snackbar('Name required', 'Please enter your full name.');
      return;
    }
    if (!email.contains('@')) {
      Get.snackbar('Email required', 'Enter a valid email address.');
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Password', 'Use at least 8 characters.');
      return;
    }
    if (password != confirm) {
      Get.snackbar('Password', 'Passwords do not match.');
      return;
    }

    isSubmitting.value = true;
    try {
      final result = await ApiRepository.register(
        name: fullName,
        email: email,
        password: password,
      );

      if (!result.ok) {
        Get.snackbar('Sign up failed', result.message);
        return;
      }

      await _persistLocalProfile(
        fullName: fullName,
        mobile: mobile,
        email: email,
      );
      _flow.markLoginSuccess();
      Get.offAllNamed<void>(Routes.SPLASH);
    } finally {
      isSubmitting.value = false;
    }
  }

  void goRegister() {
    Get.toNamed<void>(Routes.REGISTER);
  }

  /// Clears session and returns to login (home is gated until sign-in again).
  static Future<void> signOut() async {
    await ApiRepository.logout();
    if (Get.isRegistered<CreateFlowController>()) {
      Get.find<CreateFlowController>().isLoggedIn.value = false;
    }
    Get.offAllNamed<void>(Routes.LOGIN);
  }

  Future<void> signInWithGoogle() => _social.signInWithGoogle();

  Future<void> signInWithApple() => _social.signInWithApple();

  @override
  void onClose() {
    loginIdCtrl.dispose();
    loginPasswordCtrl.dispose();
    registerFullNameCtrl.dispose();
    registerMobileCtrl.dispose();
    registerEmailCtrl.dispose();
    registerPasswordCtrl.dispose();
    registerConfirmPasswordCtrl.dispose();
    super.onClose();
  }
}
