import 'package:flutter/cupertino.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'time_of_day_extension.dart';
import 'day.dart';
import 'package:permission_handler/permission_handler.dart';
import 'schedule.dart';

class Notifications {
  static NotificationOptions sleep = NotificationOptions(
      title: "C'est l'heure de dormir", body: 'Glisser pour accepter');
  static Future<int> add(
      {required NotificationOptions options,
      required TimeOfDay time,
      int? weekday,
      bool isRepeating = true,
      Schedule? schedule}) async {
    weekday ??= DateTime.now().weekday;

    int id = (await AwesomeNotifications().listScheduledNotifications()).length;

    if (await Permission.notification.isGranted) {
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
    } else {
      await Permission.notification.request();
    }
    return id;
  }

  static handleResponses(ReceivedAction event) async {
    if (event.buttonKeyPressed == 'accept') {
      Day.onWentToSleep();
    }

    if (event.buttonKeyPressed == 'deny') {
      TimeOfDay now = TimeOfDay.now();
      Notifications.add(
          options: Notifications.sleep,
          time: now + TimeOfDay(hour: now.hour, minute: now.minute + 30),
          isRepeating: false);
    }
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
