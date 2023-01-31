import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'local_files.dart';

class Schedule {
  static var localFile = LocalFiles('schedule');
  late String name;
  late Color color;
  late String songURL;
  late DateTime sleepTime;
  late DateTime wakeTime;

  Schedule(this.name, this.color, this.songURL, this.sleepTime, this.wakeTime);

  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = Color(int.parse(json['color']));
    songURL = json['songURL'];
    sleepTime = DateTime.parse(json['sleepTime']);
    wakeTime = DateTime.parse(json['wakeTime']);
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

  Future<void> add() async {
    final schedules = await getAll();
    schedules.add(this);
    localFile.write(
        jsonEncode(schedules.map((schedule) => schedule.toJson()).toList()));
  }
}
