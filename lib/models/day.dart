import 'time_slept.dart';
import 'local_files.dart';
import 'time_interval.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'time_of_day_extension.dart';

class Day extends TimeSlept {
  static var localFile = LocalFiles('days');
  late DateTime date;

  Day(TimeOfDay sleepTime, TimeOfDay wakeTime, this.date) {
    this.sleepTime = sleepTime;
    this.wakeTime = wakeTime;
  }

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

  static Future<List<Day>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Day.fromJson(element)).toList();
  }
}

extension DayGroups on List<Day> {
  List<List<Day>> groupBySize(int groupSize) {
    // Liste des jours présentement itérée
    late List<Day> daysInCurrentGroup = [];

    // Toutes les listes
    late List<List<Day>> dayGroups = [];
    for (var i = 0; i < length; i++) {
      Day currentDay = this[i];
      // Ajoute au groupe présent le jour présent
      daysInCurrentGroup.add(currentDay);

      // Lors qu'on arrive à la bonne taille de groupe
      if ((i + 1) % groupSize == 0 || i + 1 == length) {
        // Ajoute le groupe présent à la liste des groupes
        dayGroups.add([...daysInCurrentGroup]);
        // Efface le groupe présent
        daysInCurrentGroup.clear();
      }
    }
    return dayGroups;
  }

  Day average() {
    Day day = Day(map((day) => day.sleepTime).toList().average(),
        map((day) => day.wakeTime).toList().average(), first.date);
    return day;
  }

  TimeInterval createIntervals(int intervalAmount) {
    Day earliest = reduce((current, next) {
      // Les deux jours ont des heures de coucher après minuit
      if (!current.isSameDay && !next.isSameDay) {
        if (current.sleepTime.hour < next.sleepTime.hour) return current;
        return next;
      }
      if (!next.isSameDay) return next;
      if (!current.isSameDay) return current;

      if (current.sleepTime.hour < next.sleepTime.hour) return current;
      return next;
    });

    Day latest = reduce((current, next) =>
        current.wakeTime.hour > next.wakeTime.hour ? current : next);

    late double difference =
        Day(earliest.sleepTime, latest.wakeTime, DateTime.now())
            .hoursSlept
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

  double averageHoursSleptFromLast([int amount = 1]) {
    return getRange(length > amount ? length - amount : 0, length)
            .toList()
            .map((day) => day.hoursSlept)
            .reduce((curr, next) => curr + next) /
        length;
  }
}
