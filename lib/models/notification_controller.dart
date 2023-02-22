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

  static final NotificationOptions sleepOptions = NotificationOptions(
      title: "C'est l'heure de dormir!",
      body: 'Glisser pour accepter',
      category: 'sleep',
      onAccepted: SleepDay.onWentToSleep,
      onDismissed: (response) => Timer(
          Duration(minutes: 30), () => show(optionsFromResponse(response))));

  static final NotificationOptions wakeOptions = NotificationOptions(
      title: "On se réveille",
      body: 'Glisser pour accepter',
      category: 'wake',
      onAccepted: SleepDay.onAwakened,
      onDismissed: (response) => Timer(
          Duration(seconds: 30), () => show(optionsFromResponse(response))));

  static List<NotificationOptions> options = [sleepOptions, wakeOptions];

  /// Donne les `NotificationOptions` relatifs au `payload` de la `response`
  static NotificationOptions optionsFromResponse(
          NotificationResponse response) =>
      options.firstWhere((options) => options.category == response.payload);

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
  /// `flnp.periodicallyShow`
  static addSleepScheduled(Weekday weekday) async {
    // Commencer la notification du coucher
    Timer(weekday.schedule!.beforeSleep, () async {
      // Prochaine
      await show(sleepOptions);
      // Toutes les autres
      Timer.periodic(Duration(days: 7), (timer) async {
        await show(sleepOptions, weekday.sleepID);
        listenForDismissed();
      });
    });

    // Commencer la notification du lever
    Timer(weekday.schedule!.beforeWake, () async {
      // Prochaine
      await show(wakeOptions);

      // Toutes les autres
      Timer.periodic(Duration(days: 7), (timer) async {
        await show(wakeOptions, weekday.wakeID);
        listenForDismissed();
      });
    });
  }

  /// Fait apparaitre une notification à l'instant d'après une `NotificationCategory`
  static show(NotificationOptions options, [int? id]) async {
    id ??= Random().nextInt(1000);
    await flnp.show(id, options.title, options.body, options.details,
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
      optionsFromResponse(response).onAccepted();
    }

    // Refuse la réponse
    // On réenvoie la même notification dans 30 minutes, et seulement une fois
    if (response.actionId == denyResponse) {
      Timer(Duration(minutes: 30), () => show(optionsFromResponse(response)));
    }
  }

  static deleteScheduled(Weekday weekday) {
    flnp.cancel(weekday.sleepID);
    flnp.cancel(weekday.wakeID);
  }

  /// Executée en même temps que l'envoie de notifications programmées
  ///
  /// Attend ensuite 30 secondes avant de vérifier si `oldResponse` et `newResponse`
  /// correspondent.
  ///
  /// Si c'est le cas, ça veut dire que `newResponse` n'a jamais été actualisée
  /// par `onReceived`, et donc, qu'on n'a jamais répondu à la plus récente notification
  ///
  /// On appelle alors `onDismissed` relatif aux `NotificationOptions`
  ///
  /// Si les réponse ne sont pas égales, on ne fait rien mais on actualise
  /// `oldResponse` à `newResponse` pour les appels futurs
  static listenForDismissed() {
    Timer(Duration(seconds: 30), () {
      if (oldResponse.isEqual(newResponse)) {
        optionsFromResponse(oldResponse).onDismissed(oldResponse);
      }
    });
    oldResponse = newResponse;
  }
}

class NotificationOptions {
  String title;
  String body;
  String category;

  /// Appelée lorsqu'une notification répond avec `'accept'`
  Function onAccepted;

  /// Appelée lorsqu'une notification ne reçoit pas de réponse
  /// 30 secondes après son envoi
  Function(NotificationResponse response) onDismissed;
  NotificationOptions(
      {required this.title,
      required this.body,
      required this.category,
      required this.onAccepted,
      required this.onDismissed});

  NotificationDetails get details {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'android_channel_id', 'android_channel_name',
        category: AndroidNotificationCategory(category));

    DarwinNotificationDetails iOSDetails =
        DarwinNotificationDetails(categoryIdentifier: category);

    return NotificationDetails(android: androidDetails, iOS: iOSDetails);
  }
}

extension NotificationResponseExtension on NotificationResponse {
  bool isEqual(NotificationResponse other) => id == other.id;
}
