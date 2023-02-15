import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';

class Notifications {
  static NotificationOptions sleep = NotificationOptions(
      title: "C'est l'heure de dormir", body: 'Glisser pour accepter');
  static Future<int> add(
      {required NotificationOptions options,
      required TimeOfDay time,
      int? weekday,
      bool isRepeating = true}) async {
    weekday ??= DateTime.now().weekday;

    int id = (await AwesomeNotifications().listScheduledNotifications()).length;

    AwesomeNotifications().createNotification(
        actionButtons: [
          NotificationActionButton(
              buttonType: ActionButtonType.DisabledAction,
              key: 'accept',
              label: 'Aller dormir'),
          NotificationActionButton(
              buttonType: ActionButtonType.DisabledAction,
              key: 'deny',
              label: 'Me rappeler dans 30 minutes')
        ],
        schedule: NotificationCalendar(
            repeats: isRepeating,
            weekday: weekday,
            hour: time.hour,
            minute: time.minute,
            preciseAlarm: true),
        content: NotificationContent(
            wakeUpScreen: true,
            criticalAlert: true,
            id: id,
            channelKey: 'instant_notifications',
            title: options.title,
            body: options.body));
    return id;
  }

  static deleteAll() async {
    AwesomeNotifications().cancelAll();
  }

  static delete(int id) async {
    AwesomeNotifications()
        .cancel(id)
        .then((value) => debugPrint('Deleted ID: ' + id.toString()));
  }

  static printScheduledNotifications() async {
    AwesomeNotifications().listScheduledNotifications().then(
          (value) => debugPrint('Scheduled notifs: ' + value.toString()),
        );
  }

  static printScheduledNotificationsIDs() async {
    AwesomeNotifications().listScheduledNotifications().then(
          (value) => debugPrint(
              'IDs: ' + value.map((e) => e.content!.id.toString()).toString()),
        );
  }
}

class NotificationOptions {
  String title;
  String body;
  NotificationOptions({required this.title, required this.body});
}
