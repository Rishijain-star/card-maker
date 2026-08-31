import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../data/api_repository.dart';
import '../../modules/create_flow/controllers/create_flow_controller.dart';
import '../../config/auth_config.dart';
import '../../core/navigation/user_home_navigation.dart';

/// Google Sign-In (v7 API) + Sign in with Apple; authenticates with backend.
class SocialAuthService extends GetxService {
  Future<SocialAuthService> init() async {
    try {
      await GoogleSignIn.instance.initialize(
        clientId: AuthConfig.googleIosClientId.isEmpty
            ? null
            : AuthConfig.googleIosClientId,
        serverClientId: AuthConfig.googleServerClientId.isEmpty
            ? null
            : AuthConfig.googleServerClientId,
      );
    } catch (_) {
      // Misconfiguration should not block app startup; social buttons will surface errors.
    }
    return this;
  }

  Future<void> signInWithGoogle() async {
    try {
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        Get.snackbar('common.error'.tr, 'auth.google_unsupported'.tr);
        return;
      }
      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate(scopeHint: const <String>['email', 'profile']);

      final email = account.email.trim().toLowerCase();
      final name = account.displayName ?? '';

      final ok = await ApiRepository.socialLogin(
        email: email,
        name: name,
        provider: 'google',
        providerId: account.id,
      );

      if (ok) {
        if (Get.isRegistered<CreateFlowController>()) {
          Get.find<CreateFlowController>().markLoginSuccess();
        }
        UserHomeNavigation.offAllToUserHome();
      } else {
        Get.snackbar('Login failed', 'Could not authenticate with server.');
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      Get.snackbar('common.error'.tr, e.description ?? e.toString());
    } catch (e) {
      Get.snackbar('common.error'.tr, e.toString());
    }
  }

  Future<void> signInWithApple() async {
    if (kIsWeb) {
      Get.snackbar('common.error'.tr, 'auth.apple_unsupported'.tr);
      return;
    }
    try {
      if (!await _appleAvailable) {
        Get.snackbar('common.error'.tr, 'auth.apple_unavailable'.tr);
        return;
      }
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final uid = credential.userIdentifier ?? 'apple_unknown';
      final email = (credential.email ?? '').trim().toLowerCase();
      final nameParts =
          credential.givenName != null || credential.familyName != null
          ? '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                .trim()
          : '';

      final effectiveEmail = email.isNotEmpty ? email : 'apple_$uid@idshaydi.com';

      final ok = await ApiRepository.socialLogin(
        email: effectiveEmail,
        name: nameParts,
        provider: 'apple',
        providerId: uid,
      );

      if (ok) {
        if (Get.isRegistered<CreateFlowController>()) {
          Get.find<CreateFlowController>().markLoginSuccess();
        }
        UserHomeNavigation.offAllToUserHome();
      } else {
        Get.snackbar('Login failed', 'Could not authenticate with server.');
      }
    } catch (e) {
      Get.snackbar('common.error'.tr, e.toString());
    }
  }

  Future<bool> get _appleAvailable async {
    if (Platform.isIOS || Platform.isMacOS) {
      return SignInWithApple.isAvailable();
    }
    if (Platform.isAndroid) {
      return SignInWithApple.isAvailable();
    }
    return false;
  }
}
