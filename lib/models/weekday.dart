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

  /// Nom du jour
  late String day;
  late Schedule? schedule;

  static Future<Weekday> get today async {
    final weekdays = await all;

    return weekdays[DateTime.now().weekday - 1];
  }

  /// Crée un identifiant unique d'après le jour de la semaine, pour les notificationControllers
  int get sleepID => Date.weekdays.indexOf(day) * 2;

  /// Crée un identifiant unique d'après le jour de la semaine, pour les notificationControllers
  int get wakeID => Date.weekdays.indexOf(day) * 2 + 1;

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

  static Future<List<Weekday>> get all async {
    final json = await localFile.readAll();

    return json.map((element) => Weekday.fromJson(element)).toList();
  }

  /// S'exécute lorsqu'un nouveau [Schedule] est ajouté sur un bloc
  /// de jour de la semaine
  ///
  /// Assigne le nouveau [Schedule] dans le json et crée
  /// une nouvelle notification
  onScheduleAdded(Schedule newSchedule) async {
    final weekdays = await all;
    schedule = newSchedule;
    Weekday weekdayToChange =
        weekdays.firstWhere((weekday) => weekday.day == day);
    int index = weekdays.indexOf(weekdayToChange);
    weekdays[index] = this;

    NotificationController.addSleepScheduled(this);
    Data.write(weekdays, localFile);
  }

  /// S'exécute lorsqu'un bloc de jour de la semaine avait déjà un [Schedule],
  /// mais qu'il en reçoit un nouveau
  ///
  /// Assigne le nouveau [Schedule] dans le json et crée
  /// une nouvelle notification
  onScheduleChanged(Schedule newSchedule) async {
    final weekdays = await all;
    schedule = newSchedule;
    Weekday weekdayToChange =
        weekdays.firstWhere((weekday) => weekday.day == day);
    int index = weekdays.indexOf(weekdayToChange);
    weekdays[index] = this;

    NotificationController.deleteScheduled(this);
    NotificationController.addSleepScheduled(this);
    Data.write(weekdays, localFile);
  }

  /// S'exécute lorsqu'on enlève le [Schedule] d'un bloc de jour de la semaine
  ///
  /// Enlève le [Schedule] du jour dans le json et supprime sa notification
  onScheduleRemoved() async {
    final weekdays = await all;

    weekdays.firstWhere((weekday) => weekday.day == day).schedule = null;

    NotificationController.deleteScheduled(this);
    await Data.write(weekdays, localFile);
  }

  /// S'exécute lorsqu'un [Schedule] se fait supprimer
  /// Supprime le [Schedule] supprimé de tous les jours de la semaine qui l'avaient
  ///
  /// Enlève le [Schedule] des jours de la semaine du json et supprime les notifications
  static onScheduleDeleted(Schedule schedule) async {
    final weekdays = await all;

    weekdays.forEach((weekday) async {
      if (weekday.schedule != null &&
          (weekday.schedule!.name == schedule.name)) {
        NotificationController.deleteScheduled(weekday);
        weekday.schedule = null;
      }
    });

    await Data.write(weekdays, localFile);
  }

  /// S'exécute lorsqu'un [Schedule] se fait modifier
  /// Modifie le [Schedule] modifié de tous les jours de la semaine qui l'avaient
  ///
  /// Enlève le [Schedule] des jours de la semaine du json et supprime les notifications
  static onScheduleEdited(Schedule editedSchedule) async {
    final weekdays = await all;

    weekdays.forEach((weekday) async {
      if (weekday.schedule != null) {
        if (weekday.schedule!.name == editedSchedule.name) {
          weekday.schedule = editedSchedule;

          NotificationController.deleteScheduled(weekday);
          NotificationController.addSleepScheduled(weekday);
        }
      }
    });

    await Data.write(weekdays, localFile);
  }
}
