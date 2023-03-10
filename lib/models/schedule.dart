// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/material.dart';
import 'local_files.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'time_slept.dart';
import 'time_of_day_extension.dart';
import 'data.dart';
import 'sound.dart';

enum Operation { addition, edition }

class Schedule extends TimeSlept implements Data {
  static LocalFiles localFile = LocalFiles('schedules', []);
  static JSONManager<Schedule> json = JSONManager(
      localFile: localFile, constructor: ((json) => Schedule.fromJson(json)));
  late String name;
  late Color color;
  late String sleepSound;
  late String wakeSound;

  static String baseName = 'Nouvel horaire';

  Schedule(
      {required this.name,
      required this.color,
      required this.sleepSound,
      required this.wakeSound,
      required sleepTime,
      required wakeTime});

  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = Color(json['color']);
    sleepSound = json['sleepSound'];
    wakeSound = json['wakeSound'];
    sleepTime = TimeOfDayExtension.parse(json['sleepTime']);
    wakeTime = TimeOfDayExtension.parse(json['wakeTime']);
  }

  /// Fonctionnement avec `progressive_time_picker`
  Schedule.pickedTime(
      {required this.name,
      required this.color,
      required this.sleepSound,
      required this.wakeSound,
      required PickedTime sleepTime,
      required PickedTime wakeTime}) {
    this.sleepTime = TimeOfDayExtension.parse(
        '${sleepTime.h}:${sleepTime.m == 0 ? '00' : sleepTime.m}');
    this.wakeTime = TimeOfDayExtension.parse(
        '${wakeTime.h}:${wakeTime.m == 0 ? '00' : wakeTime.m}');
  }

  /// Valeur de base de `Schedule`, si jamais on a
  /// absolument besoin que `Schedule` ne soit pas `null`,
  /// mais qu'il est possible qu'il le soit
  Schedule.base(this.color) {
    name = 'Nouvel horaire';
    sleepSound = Sound.sleep.first.fileName;
    wakeSound = Sound.wake.first.fileName;
    sleepTime = const TimeOfDay(hour: 22, minute: 0);
    wakeTime = const TimeOfDay(hour: 6, minute: 0);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['color'] = color.value;
    data['sleepSound'] = sleepSound;
    data['wakeSound'] = wakeSound;
    data['sleepTime'] = sleepTime.toStringFormatted();
    data['wakeTime'] = wakeTime.toStringFormatted();
    return data;
  }

  @override
  String toString() =>
      'Schedule($name, $color, $sleepSound, $wakeSound, ${sleepTime.toStringFormatted()}, ${wakeTime.toStringFormatted()})';

  add() async => await json.add(this);

  delete() async =>
      await json.delete(shouldDeleteWhere: (schedule) => schedule.name == name);

  edit(Schedule newSchedule, [String? editedName]) async {
    await json.edit(
        to: newSchedule,
        shouldEditWhere: (schedule) {
          return schedule.name == (editedName ?? name);
        });
  }
}
