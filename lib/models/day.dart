import 'data.dart';
import 'local_files.dart';
import 'time_interval.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class Day extends Data {
  static var localFile = LocalFiles('days');
  late TimeOfDay sleepTime;
  late TimeOfDay wakeTime;
  late DateTime date;

  Day(this.sleepTime, this.wakeTime, this.date);

  // Day.day(Day sleepTime, Day wakeTime) {
  //   DateTime now = DateTime.now();
  //   this.sleepTime = DateTime(now.year, now.month, now.day,
  //       sleepTime.sleepTime.hour, sleepTime.sleepTime.minute);
  //   this.wakeTime = DateTime(now.year, now.month, now.day,
  //       wakeTime.wakeTime.hour, wakeTime.wakeTime.minute);
  // }

  Day.fromJson(Map<String, dynamic> json) {
    // final format = DateFormat.jm();
    sleepTime = TimeOfDay(
        hour: int.parse(json['sleepTime'].split(":")[0]),
        minute: int.parse(json['sleepTime'].split(":")[1]));
    wakeTime = TimeOfDay(
        hour: int.parse(json['wakeTime'].split(":")[0]),
        minute: int.parse(json['wakeTime'].split(":")[1]));
    // wakeTime = TimeOfDay.fromDateTime(format.parse(json['wakeTime']));
    date = DateTime.parse(json['date']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sleepTime'] = sleepTime.toString();
    data['wakeTime'] = wakeTime.toString();
    return data;
  }

  double hoursSlept() {
    double doubleSleepTime = sleepTime.toDouble();
    double doubleWakeTime = wakeTime.toDouble();
    if (!isSameDay()) {
      return TimeOfDay.hoursPerDay.toDouble() -
          doubleSleepTime +
          doubleWakeTime;
    }
    return doubleWakeTime - doubleSleepTime;
  }

  bool isSameDay() {
    return sleepTime.toDouble() < wakeTime.toDouble();
  }

  static Future<List<Day>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Day.fromJson(element)).toList();
  }

  static TimeInterval createIntervals(int intervalAmount, List<Day> days) {
    Day earliest = days.reduce((current, next) {
      // Les deux jours ont des heures de coucher après minuit
      if (!current.isSameDay() && !next.isSameDay()) {
        if (current.sleepTime.hour < next.sleepTime.hour) return current;
        return next;
      }
      if (!next.isSameDay()) return next;
      if (!current.isSameDay()) return current;

      if (current.sleepTime.hour < next.sleepTime.hour) return current;
      return next;
    });

    Day latest = days.reduce((current, next) =>
        current.wakeTime.hour > next.wakeTime.hour ? current : next);

    late double difference =
        Day(earliest.sleepTime, latest.wakeTime, DateTime.now())
            .hoursSlept()
            .toDouble();

    List<int> intervals = [];

    int intervalLength = (difference / intervalAmount.toDouble()).ceil();
    difference += intervalLength.toDouble();

    for (var i = 0; i < difference; i += intervalLength) {
      int untreatedHour = i + earliest.sleepTime.hour;
      intervals.add(untreatedHour < 24 ? untreatedHour : untreatedHour - 24);
    }

    return TimeInterval(intervalLength, difference.round(), intervals);
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay difference(TimeOfDay first) {
    return TimeOfDay(
        hour: first.hour > hour
            ? first.hour - hour
            : TimeOfDay.hoursPerDay - first.hour + hour,
        minute: first.minute - minute);
  }

  double toDouble() => hour + minute / 60.0;
  int toInt() => toDouble().round();
}

extension DayGroups on List<Day> {
  List<List<Day>> groupBySize(int groupSize) {
    // Liste des jours de la semaine présentement itérée
    late List<Day> daysInCurrentGroup = [];

    // Toutes les semaines
    late List<List<Day>> dayGroups = [];
    for (var i = 0; i < length; i++) {
      Day currentDay = this[i];
      daysInCurrentGroup.add(currentDay);
      if ((i + 1) % groupSize == 0 || i == length - 1) {
        dayGroups.add([...daysInCurrentGroup]);
        daysInCurrentGroup.clear();
      }
    }
    return dayGroups;
  }
}
