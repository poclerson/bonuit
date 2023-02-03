import 'schedule.dart';
import 'local_files.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Weekday {
  static var localFile = LocalFiles('weekdays',
      '[{"day": "lundi","schedule" : {}},{"day": "mardi","schedule" : {}},{"day": "mercredi","schedule" : {}},{"day": "jeudi","schedule" : {}},{"day": "vendredi","schedule" : { }},{"day": "samedi","schedule" : {}},{"day": "dimanche","schedule" : {}}]');
  late String day;
  late Schedule? schedule;

  Weekday(this.day, this.schedule);

  Weekday.fromJson(Map<String, dynamic> json) {
    debugPrint(json['schedule'].toString());
    day = json['day'];
    schedule = json['schedule'].toString() != '{}'
        ? Schedule.fromJson(json['schedule'])
        : Schedule.minimum();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['day'] = day;
    data['schedule'] = schedule!.toJson();
    return data;
  }

  static Future<List<Weekday>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Weekday.fromJson(element)).toList();
  }

  Future<void> changeSchedule(Schedule newSchedule) async {
    final weekdays = await getAll();
    Weekday weekdayToChange =
        weekdays.firstWhere((weekday) => weekday.day == day);
    int index = weekdays.indexOf(weekdayToChange);
    weekdays[index].schedule = newSchedule;
    final json =
        jsonEncode(weekdays.map((weekday) => weekday.toJson()).toList());
    localFile.write(json);
  }
}
