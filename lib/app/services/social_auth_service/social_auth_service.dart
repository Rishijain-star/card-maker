import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/auth_config.dart';
import '../../core/navigation/user_home_navigation.dart';
import '../local_storage_services/local_storage_services.dart';

/// Google Sign-In (v7 API) + Sign in with Apple; persists demo session via [LocalStorageService].
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
      final idToken = account.authentication.idToken ?? '';
      final token = idToken.isNotEmpty ? idToken : 'google:${account.id}';
      await _persistUser(
        token: token,
        email: account.email,
        name: account.displayName ?? '',
      );
      UserHomeNavigation.offAllToUserHome();
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
      final email = credential.email ?? '';
      final nameParts =
          credential.givenName != null || credential.familyName != null
          ? '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                .trim()
          : '';
      await _persistUser(token: 'apple:$uid', email: email, name: nameParts);
      UserHomeNavigation.offAllToUserHome();
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

  Future<void> _persistUser({
    required String token,
    required String email,
    required String name,
  }) async {
    final storage = LocalStorageService();
    await storage.setAuthToken(token);
    if (email.isNotEmpty) await storage.setEmailId(email);
    if (name.isNotEmpty) await storage.setUserName(name);
    await storage.setLegalGateAccepted(true);
  }
}
