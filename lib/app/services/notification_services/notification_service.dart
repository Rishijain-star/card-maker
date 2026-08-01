// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../../data/api_repository.dart';
// import 'all_notification_service_init.dart';
// import 'extra_model_message_screen.dart';
//
// class PushNotifications {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   // request notification permission
//   static Future init() async {
//     try {
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: false,
//         criticalAlert: true,
//         provisional: false,
//         sound: true,
//       );
//     } catch (e) {}
//   }
//
// // get the fcm device token
//   // get the fcm device token
//   static Future<String?> getDeviceToken({int maxRetires = 3}) async {
//     try {
//       String? token;
//       if (kIsWeb) {
//         // get the device fcm token
//         token = await _firebaseMessaging.getToken();
//         print("for web device token: $token");
//       } else {
//         // get the device fcm token
//         token = await _firebaseMessaging.getToken();
//         await ApiRepository.updateFcmToken(fcmToken: token!);
//         print("for android device token: $token");
//       }
//       // saveTokentoFirestore(token: token);
//       return token;
//     } catch (e) {
//       print("failed to get device token");
//       if (maxRetires > 0) {
//         print("try after 10 sec");
//         await Future.delayed(const Duration(seconds: 1));
//         return getDeviceToken(maxRetires: maxRetires - 1);
//       } else {
//         return null;
//       }
//     }
//   }
//
// // initalize local notifications
//
//   static Future localNotiInit() async {
//     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     try {
//       const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
//         '@mipmap/ic_launcher',
//       );
//       final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
//         requestSoundPermission: false,
//         requestBadgePermission: false,
//         requestAlertPermission: false,
//         // onDidReceiveLocalNotification: (id, title, body, payload) {},
//       );
//       const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open notification');
//       final InitializationSettings initializationSettings =
//           InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, linux: initializationSettingsLinux);
//
//       // request notification permissions for android 13 or above
//       _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.requestNotificationsPermission();
//
//       _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//           onDidReceiveNotificationResponse: onNotificationTap, onDidReceiveBackgroundNotificationResponse: onNotificationTap);
//     } catch (e) {
//       //kLogger.e(e, stackTrace: s);
//     }
//   }
//
//   // on tap local notification in foreground
//   static void onNotificationTap(NotificationResponse notificationResponse) {
//     onTapNotificationNavigateSpecificScreen(
//         extraModelMessageScreen: ExtraModelMessageScreen(remoteMessage: null, notificationResponse: notificationResponse));
//   }
//
//   // show a simple notification
//   static Future showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     try {
//       const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('club_loyalty_channel_id', 'club_loyalty_channel_name',
//           channelDescription: 'channel description', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
//       const NotificationDetails notificationDetails = NotificationDetails(
//           android: androidNotificationDetails, iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true));
//       await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
//     } catch (e) {
//       //kLogger.e(e, stackTrace: s);
//     }
//   }
// }

