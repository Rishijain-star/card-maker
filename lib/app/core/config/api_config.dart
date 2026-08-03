/// Admin API base URL.
///
/// Live Server: `https://idshaydi.in/backend/api/v1/`
/// Physical device (same Wi‑Fi dev): `--dart-define=APP_API_BASE_URL=http://<PC_IP>:8000/api/v1`
/// Android emulator (dev): `http://10.0.2.2:8000/api/v1`
abstract final class ApiConfig {
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('APP_API_BASE_URL');
    if (fromEnv.isNotEmpty) {
      return fromEnv.endsWith('/') ? fromEnv : '$fromEnv/';
    }
    return 'https://idshaydi.in/backend/api/v1/';
  }
}

