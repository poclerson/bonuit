import 'dart:async';

import 'package:bonuit/models/weekday.dart';

import 'time_slept.dart';
import 'local_files.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'time_of_day_extension.dart';
import 'data.dart';

enum DayTime { sleep, wake }

class Day extends TimeSlept implements Data {
  static var localFile = LocalFiles('days', null);
  static late TimeOfDay? nextDaySleepTime;
  static late TimeOfDay? nextDayWakeTime;

  Day(TimeOfDay sleepTime, TimeOfDay wakeTime) {
    this.sleepTime = sleepTime;
    this.wakeTime = wakeTime;
  }

  Day.fromJson(Map<String, dynamic> json) {
    sleepTime = TimeOfDayExtension.parse(json['sleepTime']);
    wakeTime = TimeOfDayExtension.parse(json['wakeTime']);
  }

  Day.midnight() {
    sleepTime = TimeOfDay(hour: 0, minute: 0);
    wakeTime = TimeOfDay(hour: 0, minute: 0);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sleepTime'] = sleepTime.toStringFormatted();
    data['wakeTime'] = wakeTime.toStringFormatted();
    return data;
  }

  static Day? get next => nextDaySleepTime != null && nextDayWakeTime != null
      ? Day(nextDaySleepTime!, nextDayWakeTime!)
      : null;

  static onAwakened() async {
    debugPrint("Réveil");
    Day.nextDayWakeTime = TimeOfDay.now();
    if (Day.next != null) {
      final days = await all;
      days.add(Day.next!);
      Data.write(days, localFile);
      nextDaySleepTime = null;
      nextDayWakeTime = null;
    }
  }

  static onWentToSleep() async {
    final today = await Weekday.today;
    debugPrint("Dodo");
    Day.nextDaySleepTime = TimeOfDay.now();
    Timer(today.schedule!.durationSlept, () => onAwakened());
  }

  static Future<List<Day>> get all async {
    final json = await localFile.readAll();

    return json.map((element) => Day.fromJson(element)).toList();
  }

  @override
  String toString() =>
      'Day(${sleepTime.toStringFormatted()}, ${wakeTime.toStringFormatted()})';
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
    if (isEmpty) return Day.midnight();
    if (length == 1) return first;
    double totalTimeBeforeMidnight = 0;
    double totalTimeAfterMidnight = 0;

    int amountOfSleepTimesBeforeMidnight = 0;
    int amountOfSleepTimesAfterMidnight = 0;

    Day combinedDay = getRange(length > amount ? length - amount : 0, length)
        .toList()
        .reduce((curr, next) {
      // Si c'est le même jour, sleepTime arrive avant minuit
      if (!next.isSameDay) {
        totalTimeBeforeMidnight += next.sleepTime.distanceFromMidnight;
        amountOfSleepTimesBeforeMidnight++;
      }

      // Si ce n'est pas le même jour, sleepTime arrive après minuit
      if (next.isSameDay) {
        totalTimeAfterMidnight += next.sleepTime.toDouble();
        amountOfSleepTimesAfterMidnight++;
      }
      return Day(curr.sleepTime, [curr.wakeTime, next.wakeTime].average());
    });

    return Day(
        (totalTimeAfterMidnight.safeDivide(amountOfSleepTimesAfterMidnight) -
                totalTimeBeforeMidnight
                    .safeDivide(amountOfSleepTimesBeforeMidnight)
                    .toDouble())
            .toTimeOfDay(),
        combinedDay.wakeTime);
  }

  /// Retourne les [hoursSlept] moyennenes
  /// d'une [List] crée à partir des [amount] dernières valeurs de [this]
  double averageHoursSleptFromLast([int amount = 1]) {
    if (length == 0) return 0;
    return getRange(length > amount ? length - amount : 0, length)
            .toList()
            .map((day) => day.hoursSlept)
            .reduce((curr, next) {
          // if (curr == next) return 0;
          return curr + next;
        }) /
        length;
  }
}

extension NumExtension on num {
  num safeDivide(num other) {
    if (other == 0) return this;
    return this / other;
  }
}
