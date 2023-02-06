import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'local_files.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'time.dart';

enum Operation { addition, edition }

class Schedule {
  static var localFile = LocalFiles('schedule');
  late String name;
  late Color color;
  String? songURL;
  Time? sleepTime;
  Time? wakeTime;

  static final Schedule base = Schedule(
      name: 'Nouvel horaire',
      color: Colors.white,
      songURL: 'allo.com',
      sleepTime: Time.zero,
      wakeTime: Time(8, 0));

  Schedule(
      {required this.name,
      required this.color,
      required this.songURL,
      required this.sleepTime,
      required this.wakeTime});

  Schedule.minimum(
      [this.name = 'Horaire',
      this.color = const Color(0xFFAFAFAF),
      this.songURL = 'allo.com']);

  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = Color(int.parse(json['color']));
    songURL = json['songURL'];
    sleepTime = json['sleepTime'] != null
        ? Time.fromString(json['sleepTime'])
        : Time.zero;
    wakeTime = json['wakeTime'] != null
        ? Time.fromString(json['wakeTime'])
        : Time.zero;
  }

  Schedule.pickedTime(
      {required this.name,
      required this.color,
      required this.songURL,
      required PickedTime sleepTime,
      required PickedTime wakeTime}) {
    this.sleepTime = Time.fromString(
        '${sleepTime.h}:${sleepTime.m == 0 ? '00' : sleepTime.m}');
    this.wakeTime =
        Time.fromString('${wakeTime.h}:${wakeTime.m == 0 ? '00' : wakeTime.m}');
  }

  static Future<List<Schedule>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Schedule.fromJson(element)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['color'] = color.toString().substring(6, 16);
    data['songURL'] = songURL;
    data['sleepTime'] = sleepTime.toString();
    data['wakeTime'] = wakeTime.toString();
    return data;
  }

  String timeInterval() {
    PickedTime intervalTime = formatIntervalTime(
        init: sleepTime!.toPickedTime(), end: wakeTime!.toPickedTime());
    return '${intervalTime.h}:${intervalTime.m == 0 ? '00' : intervalTime.m}';
  }

  bool isBase() {
    return (name == Schedule.base.name &&
        color == Schedule.base.color &&
        songURL == Schedule.base.songURL &&
        sleepTime == Schedule.base.sleepTime &&
        wakeTime == Schedule.base.wakeTime);
  }

  Future<bool> nameExists(String newName) async {
    final schedules = await getAll();
    return schedules.any((schedule) => name == schedule.name);
  }

  bool compareTo(Schedule other) {
    return (name == other.name &&
        color == other.color &&
        songURL == other.songURL &&
        sleepTime == other.sleepTime &&
        wakeTime == other.wakeTime);
  }

  static Schedule getBaseCopy() {
    return Schedule(
        name: Schedule.base.name,
        color: Schedule.base.color,
        songURL: Schedule.base.songURL,
        sleepTime: Schedule.base.sleepTime,
        wakeTime: Schedule.base.wakeTime);
  }

  void add() async {
    final schedules = await getAll();
    schedules.add(this);
    _write(schedules);
  }

  void delete() async {
    final schedules = await getAll();
    schedules.removeWhere((schedule) => schedule.name == name);
    _write(schedules);
  }

  void edit(Schedule newSchedule) async {
    final schedules = await getAll();
    schedules[schedules.indexWhere((schedule) => schedule.name == name)] =
        newSchedule;
    _write(schedules);
  }

  void _write(List<Schedule> schedules) async {
    localFile.write(
        jsonEncode(schedules.map((schedule) => schedule.toJson()).toList()));
  }
}
