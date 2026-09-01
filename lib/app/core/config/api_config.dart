import 'package:flutter/foundation.dart';

/// Admin API base URL Configuration.
///
/// Live Server: `https://admin.idshaydi.in/api/v1/`
/// Local Dev (Wi-Fi): `http://192.168.1.36:8000/api/v1/`
/// Override with: `--dart-define=APP_API_BASE_URL=http://<YOUR_IP>:8000/api/v1`
abstract final class ApiConfig {
  static const String liveBaseUrl = 'https://admin.idshaydi.in/api/v1/';
  static const String localDevBaseUrl = 'http://127.0.0.1:8000/api/v1/';
  static const String wifiDevBaseUrl = 'http://192.168.1.36:8000/api/v1/';

  static String get baseUrl {
    const fromEnv = String.fromEnvironment('APP_API_BASE_URL');
    if (fromEnv.isNotEmpty) {
      return fromEnv.endsWith('/') ? fromEnv : '$fromEnv/';
    }

    // Primary default: Live Production Server
    return liveBaseUrl;
  }
}
