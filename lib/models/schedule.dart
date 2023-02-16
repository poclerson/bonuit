// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'local_files.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'time_slept.dart';
import 'time_of_day_extension.dart';
import 'data.dart';

enum Operation { addition, edition }

class Schedule extends TimeSlept implements Data {
  static LocalFiles localFile = LocalFiles('schedules', []);
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
    data['color'] = color.value;
    data['songURL'] = songURL;
    data['sleepTime'] = sleepTime!.toStringFormatted();
    data['wakeTime'] = wakeTime!.toStringFormatted();
    return data;
  }

  String timeInterval() {
    PickedTime intervalTime = formatIntervalTime(
        init: sleepTime.toPickedTime(), end: wakeTime!.toPickedTime());
    return '${intervalTime.h}:${intervalTime.m == 0 ? '00' : intervalTime.m}';
  }

  add() async {
    final schedules = await getAll();
    schedules.add(this);
    Data.write(schedules as List<Data>, localFile);
  }

  delete() async {
    final schedules = await getAll();
    schedules.removeWhere((schedule) => schedule.name == name);
    Data.write(schedules, localFile);
  }

  edit(Schedule newSchedule) async {
    final schedules = await getAll();
    schedules[schedules.indexWhere(
        (schedule) => (schedule as Schedule).name == name)] = newSchedule;
    Data.write(schedules, localFile);
  }

  static Future<List<Schedule>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Schedule.fromJson(element)).toList();
  }
}
