import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';

class Notifications {
  Notifications();
  static final Notifications instance = Notifications();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidInitializationSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSetting =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (payload) => debugPrint(payload),
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (payload != null && payload.isNotEmpty) {
      debugPrint(payload);
    }
  }

  void onSelectNotification(String? payload) {
    debugPrint(payload);
  }

  void listenToNotification(BuildContext context) =>
      instance.onNotificationClick.stream.listen((String? payload) {
        if (payload != null && payload.isNotEmpty) {
          debugPrint(payload);

          showDialog(context: context, builder: (context) => Text('allo'));
        }
      });

  Future<void> showNotification(String title, String body) async {
    const androidNotificationDetail = AndroidNotificationDetails(
        '0', // channel Id
        'general' // channel Name
        );
    const iosNotificatonDetail = IOSNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  Future<void> showNotificationWithPayload(
      String title, String body, String payload) async {}

  Future<void> showNotificationWithTextChoice() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const IOSNotificationDetails darwinNotificationDetails =
        IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        0, "C'est l'heure de dormir", 'Aller dormir?', notificationDetails,
        payload: 'item x');
  }
}
