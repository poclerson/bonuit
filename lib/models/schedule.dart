// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'local_files.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'time_slept.dart';
import 'time_of_day_extension.dart';

enum Operation { addition, edition }

class Schedule extends TimeSlept {
  static var localFile = LocalFiles('schedules', null);
  late String name;
  late Color color;
  late String songURL;

  static String baseName = 'Nouvel horaire';

  Schedule(
      {required this.name,
      required this.color,
      required this.songURL,
      required sleepTime,
      required wakeTime});

  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = Color(json['color']);
    songURL = json['songURL'];
    sleepTime = TimeOfDayExtension.parse(json['sleepTime']);
    wakeTime = TimeOfDayExtension.parse(json['wakeTime']);
  }

  Schedule.pickedTime(
      {required this.name,
      required this.color,
      required this.songURL,
      required PickedTime sleepTime,
      required PickedTime wakeTime}) {
    this.sleepTime = TimeOfDayExtension.parse(
        '${sleepTime.h}:${sleepTime.m == 0 ? '00' : sleepTime.m}');
    this.wakeTime = TimeOfDayExtension.parse(
        '${wakeTime.h}:${wakeTime.m == 0 ? '00' : wakeTime.m}');
  }

  Schedule.base(this.color) {
    name = 'Nouvel horaire';
    songURL = '';
    sleepTime = const TimeOfDay(hour: 22, minute: 0);
    wakeTime = const TimeOfDay(hour: 6, minute: 0);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['color'] = color != null ? color!.value : null;
    data['songURL'] = songURL;
    data['sleepTime'] =
        sleepTime != null ? sleepTime!.toStringFormatted() : null;
    data['wakeTime'] = wakeTime != null ? wakeTime!.toStringFormatted() : null;
    return data;
  }

  String timeInterval() {
    PickedTime intervalTime = formatIntervalTime(
        init: sleepTime!.toPickedTime(), end: wakeTime!.toPickedTime());
    return '${intervalTime.h}:${intervalTime.m == 0 ? '00' : intervalTime.m}';
  }

  add() async {
    final schedules = await getAll();
    schedules.add(this);
    _write(schedules);
  }

  delete() async {
    final schedules = await getAll();
    schedules.removeWhere((schedule) => schedule.name == name);
    _write(schedules);
  }

  edit(Schedule newSchedule) async {
    final schedules = await getAll();
    schedules[schedules.indexWhere((schedule) => schedule.name == name)] =
        newSchedule;
    _write(schedules);
  }

  _write(List<Schedule> schedules) async {
    localFile.write(schedules.map((schedule) => schedule.toJson()).toList());
  }

  static Future<List<Schedule>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Schedule.fromJson(element)).toList();
  }
}
