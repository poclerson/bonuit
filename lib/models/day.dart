import 'data.dart';
import 'local_files.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class Day extends Data {
  static var localFile = LocalFiles('days');
  late DateTime sleepTime;
  late DateTime wakeTime;

  Day(this.sleepTime, this.wakeTime);

  Day.day(Day sleepTime, Day wakeTime) {
    DateTime now = DateTime.now();
    this.sleepTime = DateTime(now.year, now.month, now.day,
        sleepTime.sleepTime.hour, sleepTime.sleepTime.minute);
    this.wakeTime = DateTime(now.year, now.month, now.day,
        wakeTime.wakeTime.hour, wakeTime.wakeTime.minute);
  }

  Day.fromJson(Map<String, dynamic> json) {
    this.sleepTime = DateTime.parse(json['sleepTime']);
    this.wakeTime = DateTime.parse(json['wakeTime']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sleepTime'] = sleepTime.toString();
    data['wakeTime'] = wakeTime.toString();
    return data;
  }

  static Future<List<Day>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Day.fromJson(element)).toList();
  }

  double hoursSlept() {
    return durationToDouble(sleepTime.difference(wakeTime));
  }

  bool isSameDay() {
    return sleepTime.day == wakeTime.day;
  }

  static double durationToDouble(Duration duration) {
    String differenceString = duration
        .toString()
        // Retirer le - s'il y en a un
        .substring(duration.toString().substring(0, 1) == '-' ? 1 : 0);

    // Si le : est en position 1, c'est que les heures n'ont qu'un chiffre
    bool isLongTime = differenceString.substring(1, 2) != ':';
    String hours = differenceString.substring(0, isLongTime ? 2 : 1);
    debugPrint(differenceString);
    String minutes =
        differenceString.substring(isLongTime ? 3 : 2, isLongTime ? 5 : 4);
    return double.parse(hours) + (double.parse(minutes) / 60);
  }

  static Map<Day, bool> toSameDayMap(List<Day> days) {
    Map<Day, bool> sameDaySleep = {};
    for (var i = 0; i < days.length; i++) {
      Day current = days[i];
      sameDaySleep[current] = current.sleepTime.day == current.wakeTime.day;
    }
    return sameDaySleep;
  }

  static List<int> createIntervals(int intervalAmount, List<Day> days) {
    Map<Day, bool> sameDaySleep = toSameDayMap(days);

    Day earliest = days.reduce((current, next) {
      if (!sameDaySleep[current]! && !sameDaySleep[next]!) {
        if (current.sleepTime.hour < next.sleepTime.hour) return current;
        return next;
      }
      if (!sameDaySleep[next]!) return next;
      if (!sameDaySleep[current]!) return current;

      if (current.sleepTime.hour < next.sleepTime.hour) return current;
      return next;
    });

    Day latest = days.reduce((current, next) =>
        current.wakeTime.hour > next.wakeTime.hour ? current : next);

// Trouver la différence entre deux DateTime seulement par rapport aux heuress
    late Duration difference = Duration(
        hours: sameDaySleep[earliest]!
            ? latest.wakeTime.hour - earliest.sleepTime.hour
            : latest.wakeTime.hour + 24 - earliest.sleepTime.hour,
        minutes: latest.wakeTime.minute - earliest.sleepTime.minute);

    double doubleDifference = durationToDouble(difference);
    List<int> intervals = [];
    int interval = (doubleDifference / intervalAmount.toDouble()).round();
    for (var i = 0; i < doubleDifference; i += interval) {
      int untreatedHour = i + earliest.sleepTime.hour;
      intervals.add(untreatedHour < 24 ? untreatedHour : untreatedHour - 24);
    }

    intervals.add(intervals[intervals.length - 1] + interval);

    return intervals;
  }
}
