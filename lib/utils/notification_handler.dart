import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> checkAndRequestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied || status.isLimited) {
        await Permission.notification.request();
    } 
  }

  Future<void> showNotification(String title, String body) async {
    // Check and request notification permission before showing notification
    bool hasPermission = await Permission.notification.isGranted;

    if (hasPermission) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'general-notifications',
        'General-Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      try {
        await flutterLocalNotificationsPlugin.show(
            0, title, body, notificationDetails);
      } catch (e) {
        print(e);
      }
    } else {
      print('Notification permission not granted');
    }
  }
}
