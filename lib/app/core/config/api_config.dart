/// Admin API base URL.
///
/// Physical device (same Wi‑Fi): `--dart-define=APP_API_BASE_URL=http://<PC_IP>:8000/api/v1`
/// Android emulator: `http://10.0.2.2:8000/api/v1`
abstract final class ApiConfig {
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('APP_API_BASE_URL');
    if (fromEnv.isNotEmpty) {
      return fromEnv.endsWith('/') ? fromEnv : '$fromEnv/';
    }
    return 'http://192.168.1.43:8000/api/v1/';
  }
}
