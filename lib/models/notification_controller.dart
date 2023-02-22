import 'dart:math';

import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'weekday.dart';
import 'day.dart';
import 'package:flutter/material.dart';

class NotificationController {
  static final FlutterLocalNotificationsPlugin flnp =
      FlutterLocalNotificationsPlugin();

  static const String acceptResponse = 'accept';
  static const String denyResponse = 'deny';

  static final NotificationOptions sleepOptions = NotificationOptions(
      title: "C'est l'heure de dormir!",
      body: 'Glisser pour accepter',
      category: 'sleep',
      onAccepted: SleepDay.onWentToSleep);

  static final NotificationOptions wakeOptions = NotificationOptions(
      title: "On se réveille",
      body: 'Glisser pour accepter',
      category: 'wake',
      onAccepted: SleepDay.onAwakened);

  static NotificationOptions optionsFromName(String name) => [
        sleepOptions,
        wakeOptions
      ].firstWhere((options) => options.category == name);

  /// Initialise tous les paramètres nécessaires à `flnp`
  /// Initialise les catégories de notification statique à [NotificationController]
  /// Initialise [TimeZone]
  ///
  /// N'appeler qu'une seule fois au début du lancement de l'application
  static initialize() async {
    final androidSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    final darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        notificationCategories: [
          DarwinNotificationCategory(sleepOptions.category, actions: [
            DarwinNotificationAction.plain(acceptResponse, 'Aller dormir',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.foreground
                }),
            DarwinNotificationAction.plain(
                denyResponse, 'Me rappeler dans 30 minutes',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.foreground
                }),
          ], options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.customDismissAction
          }),
          DarwinNotificationCategory(wakeOptions.category, actions: [
            DarwinNotificationAction.plain(acceptResponse, 'Se réveiller'),
            DarwinNotificationAction.plain(
                denyResponse, 'Me rappeler dans 15 minutes'),
          ])
        ]);

    final initSettings =
        InitializationSettings(android: androidSettings, iOS: darwinSettings);

    flnp.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) async =>
            await onReceived(response));
    tz.initializeTimeZones();
  }

  /// Crée un cycle de notifications à être montrées à chaque semaine
  ///
  /// Montre la prochaine notification immédiatement à la date prévue par
  /// l'heure de différence entre maintenant et `weekday.schedule.sleepTime`
  ///
  /// Continue d'afficher des notifications chaque semaine grâce à
  /// `FlutterLocalNotificationflnp.periodicallyShow`
  static addScheduled(Weekday weekday) async {
    // Commencer la notification du coucher
    Timer(weekday.schedule!.beforeSleep, () async {
      // Prochaine
      await flnp.show(weekday.sleepID, sleepOptions.title, sleepOptions.body,
          sleepOptions.details,
          payload: sleepOptions.category);

      // Toutes les autres
      await flnp.periodicallyShow(weekday.wakeID, sleepOptions.title,
          sleepOptions.body, RepeatInterval.weekly, sleepOptions.details,
          payload: sleepOptions.category);
    });

    // Commencer la notification du lever
    Timer(weekday.schedule!.beforeWake, () async {
      // Prochaine
      await flnp.show(weekday.wakeID, wakeOptions.title, wakeOptions.body,
          wakeOptions.details,
          payload: wakeOptions.category);

      // Toutes les autres
      await flnp.periodicallyShow(weekday.sleepID, wakeOptions.title,
          wakeOptions.body, RepeatInterval.weekly, wakeOptions.details,
          payload: wakeOptions.category);
    });
  }

  /// Fait apparaitre une notification à l'instant d'après une `NotificationCategory`
  static show(NotificationOptions options) async {
    int id = Random().nextInt(1000);
    await flnp.show(id, options.title, options.body, options.details,
        payload: options.category);
  }

  /// Reçoit une `NotificationResponse` à chaque fois qu'on reçoit
  /// une interaction avec une notification
  @pragma('vm:entry-point')
  static onReceived(NotificationResponse response) async {
    debugPrint(response.notificationResponseType.toString());
    // Accepte la réponse
    if (response.actionId == acceptResponse) {
      // On appelle la fonction correspondante
      optionsFromName(response.payload!).onAccepted();
    }

    // Refuse la réponse
    // On réenvoie la même notification dans 30 minutes, et seulement une fois
    if (response.actionId == denyResponse) {
      Timer(Duration(seconds: 15),
          () => show(optionsFromName(response.payload!)));
    }
  }

  static deleteScheduled(Weekday weekday) {
    flnp.cancel(weekday.sleepID);
    flnp.cancel(weekday.wakeID);
  }
}

class NotificationOptions {
  String title;
  String body;
  String category;

  /// Appelée lorsqu'une notification répond avec `'accept'`
  Function onAccepted;
  NotificationOptions(
      {required this.title,
      required this.body,
      required this.category,
      required this.onAccepted});

  NotificationDetails get details {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'android_channel_id', 'android_channel_name',
        category: AndroidNotificationCategory(category));

    DarwinNotificationDetails iOSDetails =
        DarwinNotificationDetails(categoryIdentifier: category);

    return NotificationDetails(android: androidDetails, iOS: iOSDetails);
  }
}
