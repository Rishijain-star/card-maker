// // function to listen to background changes
// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// // import 'package:rentienew/main.dart';
// import 'extra_model_message_screen.dart';
// import 'notification_service.dart';
//
// Future _firebaseBackgroundMessage(RemoteMessage message) async {
//   if (message.notification != null) {}
// }
//
// // to handle notification on foreground on web platform
// void showNotification({required String title, required String body}) {
//   showDialog(
//     context: Get.context!,
//     builder: (context) => AlertDialog(
//       title: Text(title),
//       content: Text(body),
//       actions: [
//         TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Ok"))
//       ],
//     ),
//   );
// }
//
// Future<void> notificationAllServicesInit() async {
//   // initialize firebase messaging
//   await PushNotifications.init().then(
//     (value) {
//       print("line_39_$value");
//     },
//   );
//
//   if (!kIsWeb) {
//     await PushNotifications.localNotiInit();
//   }
//
//   // Listen to background notifications
//   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
//
//   // on background notification tapped
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     if (message.notification != null) {
//       onTapNotificationNavigateSpecificScreen(extraModelMessageScreen: ExtraModelMessageScreen(remoteMessage: message, notificationResponse: null));
//     }
//   });
//
//   // to handle foreground notifications
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     String payloadData = jsonEncode(message.data);
//     print(payloadData);
//     print(message.notification);
//
//     if (message.notification != null) {
//       if (kIsWeb) {
//         showNotification(title: message.notification!.title!, body: message.notification!.body!);
//       } else {
//         PushNotifications.showSimpleNotification(title: message.notification!.title!, body: message.notification!.body!, payload: payloadData);
//       }
//     }
//   });
//
//   // for handling in terminated state
//   final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
//
//   if (message != null) {
//     Future.delayed(const Duration(seconds: 1), () {
//       onTapNotificationNavigateSpecificScreen(extraModelMessageScreen: ExtraModelMessageScreen(remoteMessage: message, notificationResponse: null));
//     });
//   }
//   PushNotifications.getDeviceToken(maxRetires: 3);
// }
//
// void onTapNotificationNavigateSpecificScreen({required ExtraModelMessageScreen extraModelMessageScreen}) {
//   try {
//     if (extraModelMessageScreen.notificationResponse?.payload != null) {
//       Map<String, dynamic> payLoad = jsonDecode(extraModelMessageScreen.notificationResponse?.payload ?? "");
//       // Get.to(() => OtherUserProfileScreen(boyId: int.parse(payLoad["sender_id"])));//todo
//     }
//     if (extraModelMessageScreen.remoteMessage?.data != null) {
//       // Get.to(() => OtherUserProfileScreen(boyId: int.parse(extraModelMessageScreen.remoteMessage?.data["sender_id"])));//todo
//     }
//   } catch (e, s) {
//     print("line_93$e $s");
//     // talker.error(e, e, s);
//   }
// }

