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

  static bool pending = false;

  @pragma("vm:entry-point")
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
                actionType: ActionType.Default,
                key: 'accept',
                label: 'Aller dormir'),
            NotificationActionButton(
                actionType: ActionType.DisabledAction,
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
              autoDismissible: false,
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

  @pragma("vm:entry-point")
  static Future<void> onActionReceived(ReceivedAction event) async {
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
    debugPrint('receive' + event.buttonKeyPressed.toString());
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissed(ReceivedAction event) async {
    debugPrint('dismissed' + event.toString());
  }

  @pragma("vm:entry-point")
  static Future<void> onDisplayed(ReceivedNotification event) async {
    debugPrint('display' + event.toString());
  }

  @pragma("vm:entry-point")
  static Future<void> onCreated(ReceivedNotification event) async {
    debugPrint('created' + event.toString());
  }

  @pragma("vm:entry-point")
  static deleteAll() async {
    AwesomeNotifications().cancelAll();
  }

  @pragma("vm:entry-point")
  static delete(int id) async {
    AwesomeNotifications()
        .cancel(id)
        .then((value) => debugPrint('Deleted ID: ' + id.toString()));
  }

  @pragma("vm:entry-point")
  static printScheduledNotifications() async {
    AwesomeNotifications().listScheduledNotifications().then(
          (value) => debugPrint('Scheduled notifs: ' + value.toString()),
        );
  }

  @pragma("vm:entry-point")
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
