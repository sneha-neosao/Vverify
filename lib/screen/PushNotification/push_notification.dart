import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'firebase_token.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("title ${message.notification?.title}");
  print("body ${message.notification?.body}");
  print("playLoad ${message.data}");
  print("image ${message.data["image"]}");
}

// Future<void> showLocalNotification(RemoteMessage message) async {
//   print("start notification");
//   final title = message.notification?.title;
//   final body = message.notification?.body;
//   final imageUrl = message.data['image'];
//   BigPictureStyleInformation? bigPictureStyleInformation;
//   if (imageUrl != null) {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         final byteArray = response.bodyBytes;
//         bigPictureStyleInformation = BigPictureStyleInformation(
//           ByteArrayAndroidBitmap(byteArray),
//           largeIcon: ByteArrayAndroidBitmap(byteArray),
//           contentTitle: title,
//           summaryText: body,
//         );
//       }
//     } catch (e) {
//       log('Failed to fetch image: $e');
//     }
//   }
//
//   AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'high_importance_channel', 'High Importance Notifications',
//       channelDescription: 'This channel is used for important notifications.',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       icon: "logo",
//       enableLights: true,
//       enableVibration: true,
//       colorized: true,
//       color: const Color(0xffE28B2D),
//       styleInformation: bigPictureStyleInformation);
//
//   NotificationDetails platformDetails = NotificationDetails(
//     android: androidDetails,
//   );
//
//   await flutterLocalNotificationsPlugin.show(
//     message.hashCode,
//     message.notification?.title,
//     message.notification?.body,
//     platformDetails,
//   );
// }

Future<void> _showForegroundNotification(RemoteMessage message) async {
  final title = message.notification?.title;
  final body = message.notification?.body;
  final imageUrl = message.data['image'];
  BigPictureStyleInformation? bigPictureStyleInformation;
  if (imageUrl != null) {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final byteArray = response.bodyBytes;
        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap(byteArray),
          largeIcon: ByteArrayAndroidBitmap(byteArray),
          contentTitle: title,
          summaryText: body,
        );
      }
    } catch (e) {
      log('Failed to fetch image: $e');
    }
  }
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'logo',
        colorized: true,
        color: Color(0xffE28B2D),
        styleInformation: bigPictureStyleInformation,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
    payload: jsonEncode(message.data),
  );
}

class FirebaseApi {
  final _firebaseMessage = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessage.requestPermission();
    final fcmToken = await _firebaseMessage.getToken();
    firebaseToken = fcmToken;

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp;

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void localNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
      // Show local notification when app is in the foreground
    });
  }
}
