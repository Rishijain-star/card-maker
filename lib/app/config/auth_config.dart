/// OAuth / social sign-in configuration.
///
/// **Google (all platforms)**  
/// 1. [Google Cloud Console](https://console.cloud.google.com/) → APIs & Services → Credentials.  
/// 2. Create **OAuth 2.0 Client ID** of type **Web application** and copy the client ID
///    (ends with `.apps.googleusercontent.com`). This is your **server / web client ID**.  
/// 3. For Android, add the **SHA-1** of your keystore to the same project and download
///    or note the **Android** OAuth client.  
/// 4. For iOS, add an **iOS** OAuth client and use `GOOGLE_IOS_CLIENT_ID` if the plugin
///    does not read it from `GoogleService-Info.plist`.
///
/// Pass at build time (recommended):
/// `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=xxx.apps.googleusercontent.com`
///
/// **Sign in with Apple**  
/// - **iOS / macOS**: Xcode → Signing & Capabilities → add **Sign In with Apple**.  
/// - **Android**: Apple Developer + Services ID + redirect; see
///   [sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple) docs.
class AuthConfig {
  AuthConfig._();

  /// Web / server OAuth client ID — used by `google_sign_in` 7.x `initialize(serverClientId:)`.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  /// Optional explicit iOS client ID (`initialize(clientId:)`), if not using plist.
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );
}
