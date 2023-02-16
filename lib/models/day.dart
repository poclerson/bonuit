import 'time_slept.dart';
import 'local_files.dart';
import 'time_interval.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'time_of_day_extension.dart';
import 'data.dart';

enum DayTime { sleep, wake }

class Day extends TimeSlept implements Data {
  static var localFile = LocalFiles('days', null);
  static late TimeOfDay? nextDaySleepTime;
  static late TimeOfDay? nextDayWakeTime;
  late DateTime date;

  Day(TimeOfDay sleepTime, TimeOfDay wakeTime, this.date) {
    this.sleepTime = sleepTime;
    this.wakeTime = wakeTime;
  }

  Day.fromJson(Map<String, dynamic> json) {
    sleepTime = TimeOfDayExtension.parse(json['sleepTime']);
    wakeTime = TimeOfDayExtension.parse(json['wakeTime']);
    date = DateTime.parse(json['date']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sleepTime'] = sleepTime.toString();
    data['wakeTime'] = wakeTime.toString();
    return data;
  }

  static Day? get next => nextDaySleepTime != null && nextDayWakeTime != null
      ? Day(nextDaySleepTime!, nextDayWakeTime!, DateTime.now())
      : null;

  static add() async {
    if (Day.next != null) {
      final days = await getAll();
      days.add(Day.next!);
      Data.write(days, localFile);
      nextDaySleepTime = null;
      nextDayWakeTime = null;
    }
  }

  static Future<List<Day>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Day.fromJson(element)).toList();
  }
}

extension DayGroups on List<Day> {
  /// Crée une [List] de [List] à partir de [groupSize]
  ///
  /// Par exemple, si [this.length] est 14 et que [groupSize] est 7,
  ///
  /// La fonction retournera une [List] contenant deux [List] de longueur 7
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

  /// Retourne un [Day] avec le [sleepTime] et le [wakeTime] moyens
  /// d'une [List] crée à partir des [amount] dernières valeurs de [this]
  Day averageFromLast([int amount = 1]) {
    double totalTimeBeforeMidnight = 0;
    double totalTimeAfterMidnight = 0;

    int amountOfDaysBeforeMidnight = 0;
    int amountOfDaysAfterMidnight = 0;

    Day combinedDay = getRange(length > amount ? length - amount : 0, length)
        .toList()
        .reduce((curr, next) {
      // Si c'est le même jour, sleepTime arrive avant minuit
      if (!next.isSameDay) {
        totalTimeBeforeMidnight += next.sleepTime.distanceFromMidnight;
        amountOfDaysBeforeMidnight++;
      }

      // Si ce n'est pas le même jour, sleepTime arrive après minuit
      if (next.isSameDay) {
        totalTimeAfterMidnight += next.sleepTime.toDouble();
        amountOfDaysAfterMidnight++;
      }

      return Day(
          curr.sleepTime, [curr.wakeTime, next.wakeTime].average(), curr.date);
    });

    // Faire la différence entre les deux moyennes de temps d'avant et d'après minuit
    return Day(
        (totalTimeAfterMidnight / amountOfDaysAfterMidnight -
                totalTimeBeforeMidnight / amountOfDaysBeforeMidnight)
            .toTimeOfDay(),
        combinedDay.wakeTime,
        first.date);
  }

  /// Retourne les [hoursSlept] moyennenes
  /// d'une [List] crée à partir des [amount] dernières valeurs de [this]
  double averageHoursSleptFromLast([int amount = 1]) {
    if (length == 0) return 0;
    return getRange(length > amount ? length - amount : 0, length)
            .toList()
            .map((day) => day.hoursSlept)
            .reduce((curr, next) => curr + next) /
        length;
  }
}
