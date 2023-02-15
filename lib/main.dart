import 'package:flutter/material.dart';
import 'app.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'models/notifications.dart';

main() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'instant_notifications',
            channelName: 'Basic instant notification',
            channelDescription: 'Instant notif',
            channelShowBadge: true,
            importance: NotificationImportance.High,
            enableVibration: true,
            defaultColor: Colors.red,
            ledColor: Colors.blue)
      ],
      debug: true);
  runApp(App());
}
