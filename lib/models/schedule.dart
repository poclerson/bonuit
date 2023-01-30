import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Schedule {
  static const url = 'assets/schedule.json';
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

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    File('$path/schedule.json').create(recursive: true);
    return File('$path/schedule.json');
  }

  static Future<List<Schedule>> getAllSchedules() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    List<dynamic> json = await jsonDecode(contents);

    return json.map((element) => Schedule.fromJson(element)).toList();
  }

  static Map<String, dynamic> toJson(Schedule schedule) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = schedule.name;
    data['color'] = schedule.color.toString();
    data['songURL'] = schedule.songURL;
    data['sleepTime'] = schedule.sleepTime.toString();
    data['wakeTime'] = schedule.wakeTime.toString();

    return data;
  }

  static void addSchedule(
      {required String name,
      required Color color,
      String songURL = 'https://allo.com',
      required DateTime sleepTime,
      required DateTime wakeTime}) async {
    final file = await _localFile;
    file.writeAsStringSync(json
        .encode(toJson(Schedule(name, color, songURL, sleepTime, wakeTime))));
  }
}
