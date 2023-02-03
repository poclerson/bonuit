import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'local_files.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class Schedule {
  static var localFile = LocalFiles('schedule');
  late String name;
  late Color color;
  String? songURL;
  String? sleepTime;
  String? wakeTime;

  Schedule(
      {required this.name,
      required this.color,
      required this.songURL,
      required this.sleepTime,
      required this.wakeTime});

  Schedule.minimum(
      [this.name = 'Horaire', this.color = const Color(0xFFAFAFAF)]);

  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = Color(int.parse(json['color']));
    songURL = json['songURL'];
    sleepTime = json['sleepTime'];
    wakeTime = json['wakeTime'];
  }

  Schedule.pickedTime(
      {required this.name,
      required this.color,
      required this.songURL,
      required PickedTime sleepTime,
      required PickedTime wakeTime}) {
    this.sleepTime = '${sleepTime.h}:${sleepTime.m == 0 ? '00' : sleepTime.m}';
    this.wakeTime = '${wakeTime.h}:${wakeTime.m == 0 ? '00' : wakeTime.m}';
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
    data['sleepTime'] = sleepTime;
    data['wakeTime'] = wakeTime;
    return data;
  }

  Future<void> add() async {
    final schedules = await getAll();
    schedules.add(this);
    localFile.write(
        jsonEncode(schedules.map((schedule) => schedule.toJson()).toList()));
  }
}
