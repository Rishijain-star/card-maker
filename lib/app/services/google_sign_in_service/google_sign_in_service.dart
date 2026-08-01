// import 'package:google_sign_in/google_sign_in.dart';
//
// class GoogleSignInService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//
//   bool _isInitialized = false;
//   GoogleSignInAccount? _currentUser;
//
//   final String iosClientId = "764200556269-6cvju8m1r94ch02nqno06c4ufag5mbn6.apps.googleusercontent.com";
//   final String webClientId = "764200556269-5uriss8kt76v0i9bcc2ovlouqfnccbra.apps.googleusercontent.com";
//
//   Future<void> initialize() async {
//     if (_isInitialized) return;
//
//     try {
//       await _googleSignIn.initialize(
//         clientId: iosClientId,
//         serverClientId: webClientId,
//       );
//
//       _isInitialized = true;
//       print("Google initialized");
//     } catch (e) {
//       print("Init error: $e");
//     }
//   }
//
//   Future<void> _ensureInitialized() async {
//     if (!_isInitialized) await initialize();
//   }
//
//   Future<GoogleSignInAccount?> dsfsfsafd() async {
//     await _ensureInitialized();
//
//     try {
//       print('Attempting Google sign-in...');
//       final account = await _googleSignIn.authenticate(
//         scopeHint: ['email', 'profile'],
//       );
//
//       _currentUser = account;
//
//       print('Google sign-in successful: ${account.email}');
//       return account;
//     } catch (e) {
//       print('Google Sign-In error: $e');
//       return null;
//     }
//   }
//
//   GoogleSignInAccount? get currentUser => _currentUser;
//
//
//
//  static Future<GoogleSignInAccount?> loginWithGoogle() async {
//     try{
//       final GoogleSignInService _googleService = GoogleSignInService();
//
//       final account = await _googleService.dsfsfsafd();
//
//       if (account != null) {
//         final auth = account.authentication;
//         print("User Logged In: ${account.email}");
//         print("User ID Token: ${auth.idToken}");
//         return account;
//       } else {
//         print("Login cancelled");
//       }
//     }catch(e){
//       print("line_80_$e");
//     }
//     return null;
//   }
//
// }

