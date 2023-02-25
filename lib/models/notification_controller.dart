import 'dart:math';

import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'weekday.dart';
import 'sleep_day.dart';
import 'package:flutter/material.dart';

class NotificationController {
  /// Instance de `flutter_local_notifications`
  static final FlutterLocalNotificationsPlugin flnp =
      FlutterLocalNotificationsPlugin();

  static const String acceptResponse = 'accept';
  static const String denyResponse = 'deny';

  static const String sleepCategory = 'sleep';
  static const String sleepTitle = "C'est l'heure d'aller dormir";
  static const String wakeCategory = 'wake';
  static const String wakeTitle = 'Réveillez-vous!';

  /// Donne les `NotificationOptions` relatifs au `payload` de la `response`
  static Future<NotificationOptions> optionsFromResponse(
          NotificationResponse response) async =>
      (await Weekday.allNotificationOptions)
          .firstWhere((options) => options.category == response.payload);

  static late NotificationResponse oldResponse;
  static late NotificationResponse newResponse;
  static bool mostRecentWasDismissed = true;

  /// Initialise tous les paramètres nécessaires à `flnp`
  /// Initialise les catégories de notification statique à `NotificationController`
  /// Initialise `TimeZone`
  ///
  /// N'appeler qu'une seule fois au début du lancement de l'application
  static initialize() async {
    final androidSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    final darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentSound: false,
        notificationCategories: [
          DarwinNotificationCategory(sleepCategory, actions: [
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
          DarwinNotificationCategory(wakeCategory, actions: [
            DarwinNotificationAction.plain(acceptResponse, 'Se réveiller'),
            DarwinNotificationAction.plain(
                denyResponse, 'Me rappeler dans 15 minutes'),
          ]),
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
  /// `flnp.periodicallyShow`
  static addSleepScheduled(Weekday weekday) async {
    debugPrint('Horaire ${weekday.schedule!.name} ajouté le ${weekday.day}');
    NotificationOptions sleepOptions = NotificationOptions(
        id: weekday.sleepID,
        title: sleepTitle,
        body: weekday.schedule!.name,
        sound: weekday.schedule!.sleepSound,
        category: sleepCategory,
        onAccepted: SleepDay.onWentToSleep);

    // Commencer la notification du coucher
    Timer(weekday.schedule!.beforeSleep, () async {
      await periodicallyShow(sleepOptions);
    });

    NotificationOptions wakeOptions = NotificationOptions(
        id: weekday.wakeID,
        title: wakeTitle,
        body: weekday.schedule!.name,
        sound: weekday.schedule!.wakeSound,
        category: wakeCategory,
        onAccepted: SleepDay.onAwakened);
    // Commencer la notification du lever
    Timer(weekday.schedule!.beforeWake, () async {
      await periodicallyShow(wakeOptions);
    });
  }

  /// Annule la notification de réveil et celle de coucher de `weekday`
  static deleteSleepScheduled(Weekday weekday) {
    debugPrint('Horaire ${weekday.schedule!.name} retiré du ${weekday.day}');
    flnp.cancel(weekday.sleepID);
    flnp.cancel(weekday.wakeID);
  }

  /// Fait apparaitre une notification à l'instant d'après une `NotificationCategory`
  static show(NotificationOptions options) async {
    int id = Random().nextInt(1000);
    await flnp.show(id, options.title, options.body, options.details,
        payload: options.category);
  }

  static periodicallyShow(NotificationOptions options) async {
    debugPrint('Horaire ${options.body} planifié');
    await show(options);
    await flnp.periodicallyShow(options.id, options.title, options.body,
        RepeatInterval.weekly, options.details,
        payload: options.category);
  }

  /// Reçoit une `NotificationResponse` à chaque fois qu'on reçoit
  /// une interaction avec une notification
  ///
  /// Si on répond avec `'accept'`, on appelle la fonction correspondante
  /// Soit `SleepDay.onWentToSleep` ou `SleepDay.onAwakened`
  ///
  /// Sinon, on réenvoie la même notification, cette fois à usage unique,
  /// dans 30 minutes afin de redonner un rappel
  @pragma('vm:entry-point')
  static onReceived(NotificationResponse response) async {
    // La notification n'a pas été ignorée
    newResponse = response;
    // Accepte la réponse
    if (response.actionId == acceptResponse) {
      // On appelle la fonction correspondante
      (await optionsFromResponse(response)).onAccepted();
    }

    // Refuse la réponse
    // On réenvoie la même notification dans 30 minutes, et seulement une fois
    if (response.actionId == denyResponse) {
      Timer(Duration(minutes: 30),
          () async => show(await optionsFromResponse(response)));
    }
  }

  static printAllPendingNotificationRequests() async {
    List<PendingNotificationRequest> pendingNotificationRequests =
        await NotificationController.flnp.pendingNotificationRequests();
    pendingNotificationRequests.map((e) => debugPrint(e.toStringFormatted()));
    debugPrint('All pending notification requests: ' +
        pendingNotificationRequests.toStringFormatted().toString());
  }
}

class NotificationOptions {
  final int id;
  final String title;
  final String body;
  final String sound;
  final String category;

  /// Appelée lorsqu'une notification répond avec `'accept'`
  final Function onAccepted;

  NotificationOptions({
    required this.id,
    required this.title,
    required this.body,
    required this.sound,
    required this.category,
    required this.onAccepted,
  });

  NotificationDetails get details {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'android_channel_id', 'android_channel_name',
        category: AndroidNotificationCategory(category));

    DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      categoryIdentifier: category,
      sound: sound,
      presentSound: true,
      badgeNumber: 0,
    );

    return NotificationDetails(android: androidDetails, iOS: iOSDetails);
  }
}

extension NotificationResponseExtension on NotificationResponse {
  bool isEqual(NotificationResponse other) => id == other.id;
}

extension PendingNotificationRequestExtension on PendingNotificationRequest {
  String toStringFormatted() => 'PNR($id, $payload)';
}

extension PendingNotificationRequestListExtension
    on List<PendingNotificationRequest> {
  List<String> toStringFormatted() =>
      map((e) => '\n${e.toStringFormatted()}').toList();
}
