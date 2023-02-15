import 'schedule.dart';
import 'local_files.dart';
import 'data.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'notifications.dart';
import 'date.dart';

class Weekday extends Data {
  static var localFile = LocalFiles('weekdays', [
    {"day": "lundi", "notificationID": null, "schedule": null},
    {"day": "mardi", "notificationID": null, "schedule": null},
    {"day": "mercredi", "notificationID": null, "schedule": null},
    {"day": "jeudi", "notificationID": null, "schedule": null},
    {"day": "vendredi", "notificationID": null, "schedule": null},
    {"day": "samedi", "notificationID": null, "schedule": null},
    {"day": "dimanche", "notificationID": null, "schedule": null}
  ]);
  late String day;
  late Schedule? schedule;
  late int? notificationID;

  Weekday.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    schedule =
        json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
    notificationID = json['notificationID'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['schedule'] = schedule != null ? schedule!.toJson() : null;
    data['notificationID'] = notificationID;
    return data;
  }

  toNull() {
    schedule = null;
    notificationID = null;
  }

  onScheduleAddedOrChanged(Schedule newSchedule) async {
    final weekdays = await getAll();
    schedule = newSchedule;
    Weekday weekdayToChange =
        weekdays.firstWhere((weekday) => weekday.day == day);
    int index = weekdays.indexOf(weekdayToChange);
    weekdays[index] = this;

    notificationID = await Notifications.add(
        options: Notifications.sleep,
        weekday: Date.weekdays.indexOf(day) + 1,
        time: schedule!.sleepTime);

    _write(weekdays);
  }

  onScheduleRemoved() async {
    final weekdays = await getAll();

    weekdays.firstWhere((weekday) => weekday.day == day).toNull();

    await _write(weekdays);
  }

  static Future<List<Weekday>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Weekday.fromJson(element)).toList();
  }

  static onScheduleDeleted(Schedule schedule) async {
    final weekdays = await getAll();

    weekdays.forEach((weekday) {
      if (weekday.schedule != null &&
          (weekday.schedule!.name == schedule.name)) {
        weekday.toNull();
      }
    });

    await _write(weekdays);
  }

  static onScheduleEdited(Schedule editedSchedule) async {
    final weekdays = await getAll();

    weekdays.forEach((weekday) async {
      if (weekday.schedule != null) {
        if (weekday.schedule!.name == editedSchedule.name) {
          weekday.schedule = editedSchedule;

          Notifications.delete(weekday.notificationID!);

          weekday.notificationID = await Notifications.add(
              options: Notifications.sleep, time: weekday.schedule!.sleepTime);
        }
      }
    });

    await _write(weekdays);
  }

  static _write(List<Weekday> weekdays) async {
    localFile
        .write(weekdays.map((weekday) => weekday.toJson()).toList())
        .then((value) {
      Notifications.printScheduledNotifications();
      Notifications.printScheduledNotificationsIDs();
    });
  }
}
