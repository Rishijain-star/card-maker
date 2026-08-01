 import 'package:flutter/foundation.dart';
 import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenService {
  static const _keyAuthToken = 'secure_auth_token';
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  static final _storage = FlutterSecureStorage();

  Future<void> setAuthToken(String token) async {
    await _storage.write(
      key: _keyAuthToken,
      value: token,
      aOptions: _androidOptions,
    );
  }

  Future<String> getAuthToken() async {
    try {
      final v = await _storage.read(
        key: _keyAuthToken,
        aOptions: _androidOptions,
      );
      return v ?? '';
    } catch (error, stackTrace) {
      debugPrint(
        'SecureTokenService.getAuthToken failed (clearing key): $error',
      );
      debugPrintStack(stackTrace: stackTrace);
      await _resetCorruptedStorage();
      return '';
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _keyAuthToken, aOptions: _androidOptions);
    } catch (_) {
      await _resetCorruptedStorage();
    }
  }

  Future<bool> isLoggedIn() async {
    return (await getAuthToken()).isNotEmpty;
  }

  Future<void> _resetCorruptedStorage() async {
    try {
      await _storage.deleteAll(aOptions: _androidOptions);
    } catch (_) {
      // If secure storage cannot be recovered, fall back to logged-out state.
    }
  }
}

