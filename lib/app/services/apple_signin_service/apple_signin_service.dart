// import 'dart:developer';
//
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:my_app/app/data/api_repository.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// import '../../routes/app_pages.dart';
//
// class AppleSignInService {
//
//   static Future<AppleUserModel?> loginWithApple() async {
//     print("apple_sign_in_service");
//
//     try {
//       final credential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         // Android ke liye yeh zaroori hai â€” iOS pe null rahega
//         webAuthenticationOptions: GetPlatform.isAndroid
//             ? WebAuthenticationOptions(
//           clientId: 'com.crowddeliver.signin', // â† Apple Developer mein bana Service ID
//           redirectUri: Uri.parse('https://crowddeliver.in/auth/apple/callback'), // â† Tera backend URL
//         )
//             : null,
//       );
//
//       final appleUser = AppleUserModel.fromCredential(credential);
//       log("Apple User Model => ${appleUser.toString()}");
//
//       // Backend Call
//       bool success = await ApiRepository.loginWithApple(
//         idToken: appleUser.identityToken,
//       );
//
//       if (success) {
//         Get.offAllNamed(Routes.DASHBOARD);
//       }
//
//       return appleUser;
//     } on SignInWithAppleAuthorizationException catch (e) {
//       // User ne cancel kiya ya kuch error
//       print("Apple Sign-In Cancelled/Error: ${e.message}");
//       return null;
//     } catch (e) {
//       print("Apple Login Error: $e");
//       return null;
//     }
//   }
//   // static Future<AppleUserModel?> loginWithApple() async {
//   //   print("apple_sign_in_service");
//   //
//   //   try {
//   //     final credential = await SignInWithApple.getAppleIDCredential(
//   //       scopes: [
//   //         AppleIDAuthorizationScopes.email,
//   //         AppleIDAuthorizationScopes.fullName,
//   //       ],
//   //     );
//   //
//   //     final appleUser = AppleUserModel.fromCredential(credential);
//   //
//   //     log("ðŸŽ Apple User Model => ${appleUser.toString()}");
//   //
//   //     // ðŸ”¥ Backend Call
//   //     bool success = await ApiRepository.loginWithApple(
//   //       idToken: appleUser.identityToken,
//   //     );
//   //
//   //     if (success) {
//   //       Get.offAllNamed(Routes.DASHBOARD);
//   //     }
//   //
//   //     return appleUser;
//   //   } catch (e) {
//   //     print("âŒ Apple Login Error: $e");
//   //     return null;
//   //   }
//   // }
// }
//
//
//
//
//
//
// class AppleUserModel {
//   final String userId;
//   final String email;
//   final String fullName;
//   final String identityToken;
//   final String authorizationCode;
//
//   AppleUserModel({
//     required this.userId,
//     required this.email,
//     required this.fullName,
//     required this.identityToken,
//     required this.authorizationCode,
//   });
//
//   factory AppleUserModel.fromCredential(
//       AuthorizationCredentialAppleID credential) {
//
//     final email = credential.email ?? "";
//     final firstName = credential.givenName;
//     final lastName = credential.familyName;
//     final identityToken = credential.identityToken ?? "";
//     final authCode = credential.authorizationCode ?? "";
//
//     // ðŸ‘‡ Full name fallback logic
//     String generatedName = "";
//     if (firstName != null || lastName != null) {
//       generatedName = "${firstName ?? ""} ${lastName ?? ""}".trim();
//     } else if (email.isNotEmpty) {
//       generatedName = email[0].toUpperCase();
//     }
//
//     return AppleUserModel(
//       userId: credential.userIdentifier ?? "",
//       email: email,
//       fullName: generatedName,
//       identityToken: identityToken,
//       authorizationCode: authCode,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "userId": userId,
//     "email": email,
//     "fullName": fullName,
//     "identityToken": identityToken,
//     "authorizationCode": authorizationCode,
//   };
//
//   @override
//   String toString() => toJson().toString();
// }

