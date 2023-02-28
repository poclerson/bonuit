import 'package:bonuit/models/sleep_day.dart';

import 'schedule.dart';
import 'local_files.dart';
import 'data.dart';
import 'date.dart';
import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';
import 'notification_controller.dart';

/// Représente un jour de la semaine où on peut assigner un horaire
///
/// Gère les différents horaires assignables vers chaque jour de la semaine
/// et permet leur affichage dynamique
class Weekday extends Data {
  static LocalFiles localFile = LocalFiles('weekdays', [
    {"day": "lundi", "schedule": null},
    {"day": "mardi", "schedule": null},
    {"day": "mercredi", "schedule": null},
    {"day": "jeudi", "schedule": null},
    {"day": "vendredi", "schedule": null},
    {"day": "samedi", "schedule": null},
    {"day": "dimanche", "schedule": null}
  ]);

  static JSONManager<Weekday> json = JSONManager(
      localFile: localFile, constructor: ((json) => Weekday.fromJson(json)));

  /// Nom du jour
  late String day;
  late Schedule? schedule;

  static Future<Weekday> get today async {
    final weekdays = await json.all;

    return weekdays[DateTime.now().weekday - 1];
  }

  /// Crée un identifiant unique d'après le jour de la semaine, pour les notificationControllers
  int get sleepID => Date.weekdays.indexOf(day) * 2;

  /// Crée un identifiant unique d'après le jour de la semaine, pour les notificationControllers
  int get wakeID => Date.weekdays.indexOf(day) * 2 + 1;

  Weekday({required this.day, required this.schedule});

  Weekday.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    schedule =
        json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['schedule'] = schedule != null ? schedule!.toJson() : null;
    return data;
  }

  @override
  String toString() => 'Weekday($day, $schedule)';

  /// S'exécute lorsqu'un nouveau [Schedule] est ajouté sur un bloc
  /// de jour de la semaine
  ///
  /// Assigne le nouveau [Schedule] dans le json et crée
  /// une nouvelle notification
  onScheduleAdded(Schedule newSchedule) async {
    Weekday newWeekday = Weekday(day: day, schedule: newSchedule);

    await json.edit(
        data: newWeekday, shouldEditWhere: (weekday) => weekday.day == day);

    NotificationController.addSleepScheduled(newWeekday);
  }

  /// S'exécute lorsqu'un bloc de jour de la semaine avait déjà un [Schedule],
  /// mais qu'il en reçoit un nouveau
  ///
  /// Assigne le nouveau [Schedule] dans le json et crée
  /// une nouvelle notification
  onScheduleChanged(Schedule newSchedule) async {
    Weekday newWeekday = Weekday(day: day, schedule: newSchedule);

    await json.edit(
        data: newWeekday, shouldEditWhere: (weekday) => weekday.day == day);

    NotificationController.deleteSleepScheduled(this);
    NotificationController.addSleepScheduled(this);
  }

  /// S'exécute lorsqu'on enlève le [Schedule] d'un bloc de jour de la semaine
  ///
  /// Enlève le [Schedule] du jour dans le json et supprime sa notification
  onScheduleRemoved() async {
    Weekday newWeekday = Weekday(day: day, schedule: null);

    await json.edit(
        data: newWeekday, shouldEditWhere: (weekday) => weekday.day == day);

    NotificationController.deleteSleepScheduled(this);
  }

  /// S'exécute lorsqu'un [Schedule] se fait supprimer
  /// Supprime le [Schedule] supprimé de tous les jours de la semaine qui l'avaient
  ///
  /// Enlève le [Schedule] des jours de la semaine du json et supprime les notifications
  static onScheduleDeleted(Schedule deletedSchedule) async {
    final weekdays = await json.editAll(
        editTo: (weekday) => Weekday(day: weekday.day, schedule: null),
        shouldEditWhere: (weekday) => weekday.schedule != null
            ? weekday.schedule!.name == deletedSchedule.name
            : false);

    weekdays.forEach((weekday) async {
      if (weekday.schedule != null &&
          (weekday.schedule!.name == deletedSchedule.name)) {
        NotificationController.deleteSleepScheduled(weekday);
      }
    });
  }

  /// S'exécute lorsqu'un [Schedule] se fait modifier
  /// Modifie le [Schedule] modifié de tous les jours de la semaine qui l'avaient
  ///
  /// Enlève le [Schedule] des jours de la semaine du json et supprime les notifications
  static onScheduleEdited(Schedule editedSchedule) async {
    final weekdays = await json.editAll(
        editTo: (weekday) =>
            Weekday(day: weekday.day, schedule: editedSchedule),
        shouldEditWhere: (weekday) => weekday.schedule != null
            ? weekday.schedule!.name == editedSchedule.name
            : false);

    weekdays.forEach((weekday) async {
      if (weekday.schedule != null) {
        if (weekday.schedule!.name == editedSchedule.name) {
          NotificationController.deleteSleepScheduled(weekday);
          NotificationController.addSleepScheduled(weekday);
        }
      }
    });
  }

  /// Génère la liste de toutes les `NotificationOptions` disponibles.
  ///
  /// Si un `weekday` a un `schedule`, c'est nécessairement qu'une notification
  /// existe pour ce `weekday`
  ///
  /// On retourne donc la notification de coucher et celle de lever pour chaque
  /// `weekday` qui a un `schedule`
  static Future<List<NotificationOptions>> get allNotificationOptions async {
    final weekdays = await json.all;
    List<NotificationOptions> options = [];
    weekdays.forEach((weekday) {
      if (weekday.schedule != null) {
        options.add(NotificationOptions.fromTemplate(
            template: NotificationController.sleepTemplate,
            id: weekday.sleepID,
            body: weekday.schedule!.name,
            sound: weekday.schedule!.sleepSound,
            onAccepted: SleepDay.onWentToSleep));
        options.add(NotificationOptions.fromTemplate(
            template: NotificationController.wakeTemplate,
            id: weekday.wakeID,
            body: weekday.schedule!.name,
            sound: weekday.schedule!.wakeSound,
            onAccepted: SleepDay.onAwakened));
      }
    });

    return options;
  }
}
