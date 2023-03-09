import 'dart:math';

import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect.dart';
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

  static final NotificationTemplate sleepTemplate = NotificationTemplate(
      title: "C'est l'heure d'aller dormir",
      category: 'sleep',
      onDeniedDelay: Duration(minutes: 30));
  static final NotificationTemplate wakeTemplate = NotificationTemplate(
      title: 'On se réveille!',
      category: 'wake',
      onDeniedDelay: Duration(minutes: 10));

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
          DarwinNotificationCategory(sleepTemplate.category, actions: [
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
          DarwinNotificationCategory(wakeTemplate.category, actions: [
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
    NotificationOptions sleepOptions = NotificationOptions.fromTemplate(
        template: sleepTemplate,
        id: weekday.sleepID,
        body: weekday.schedule!.name,
        sound: weekday.schedule!.sleepSound,
        onAccepted: () => SleepDay.onWentToSleep());

    // Commencer la notification du coucher
    Timer(weekday.schedule!.beforeSleep, () async {
      await periodicallyShow(sleepOptions);
    });

    NotificationOptions wakeOptions = NotificationOptions.fromTemplate(
      template: wakeTemplate,
      id: weekday.wakeID,
      body: weekday.schedule!.name,
      sound: weekday.schedule!.wakeSound,
      onAccepted: () => SleepDay.onAwakened(),
    );
    // Commencer la notification du lever
    Timer(weekday.schedule!.beforeWake, () async {
      await periodicallyShow(wakeOptions);
    });
  }

  /// Annule la notification de réveil et celle de coucher de `weekday`
  static deleteSleepScheduled(Weekday weekday) {
    flnp.cancel(weekday.sleepID);
    flnp.cancel(weekday.wakeID);
  }

  /// Fait apparaitre une notification à l'instant d'après une `NotificationCategory`
  static show(NotificationOptions options) async {
    int id = Random().nextInt(1000);
    await flnp.show(id, options.title, options.body, options.details,
        payload: options.category);
  }

  static showDelayed(NotificationOptions options, Duration delay) async {
    Timer(delay, () async => await show(options));
  }

  static periodicallyShow(NotificationOptions options) async {
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

class NotificationTemplate {
  final String title;
  final String category;
  final Duration onDeniedDelay;

  NotificationTemplate(
      {required this.title,
      required this.category,
      required this.onDeniedDelay});
}

class NotificationOptions {
  final int id;

  /// Information statique par rapport au type de notification.
  /// Par exemple, une notification de coucher aura toujours le même titre
  late String title;

  /// Information dynamique par rapport au type de notification.
  /// `body` changera d'après la valeur du nom de l'horaire du jour
  /// de la semaine assigné
  final String body;

  /// Son émis lors de la réception de la notification
  final String sound;

  /// Sert à identifier le type de notification pour `FlutterLocalNotificationPlugin`
  /// et à la réception d'une notification dans le `payload`
  late String category;

  /// Appelée lorsqu'une notification répond avec `'accept'`
  final Function onAccepted;

  /// Appelée lorsqu'une notification répond avec `'deny'`
  late Function onDenied;

  /// Construit un `NotificationOptions` à partir de tous les éléments nécessaires
  /// et d'une `Duration` qui instantiera `onDenied`
  NotificationOptions(
      {required this.id,
      required this.title,
      required this.body,
      required this.sound,
      required this.category,
      required this.onAccepted,
      required Duration onDeniedDelay}) {
    onDenied = () async =>
        await NotificationController.showDelayed(this, onDeniedDelay);
  }

  /// Construit un `NotificationOptions` à partir d'un `NotificationTemplate`
  /// pour du code plus clair
  NotificationOptions.fromTemplate(
      {required NotificationTemplate template,
      required this.id,
      required this.body,
      required this.sound,
      required this.onAccepted}) {
    title = template.title;
    category = template.category;
    onDenied = () async =>
        await NotificationController.showDelayed(this, template.onDeniedDelay);
  }

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
