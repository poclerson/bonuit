import 'dart:async';

import 'package:bonuit/models/weekday.dart';

import 'time_slept.dart';
import 'local_files.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'time_of_day_extension.dart';
import 'data.dart';

enum DayTime { sleep, wake }

class DayUnit extends TimeSlept implements Data {
  static var localFile = LocalFiles('days', null);
  static late TimeOfDay? nextDaySleepTime;
  static late TimeOfDay? nextDayWakeTime;

  DayUnit(TimeOfDay sleepTime, TimeOfDay wakeTime) {
    this.sleepTime = sleepTime;
    this.wakeTime = wakeTime;
  }

  DayUnit.fromJson(Map<String, dynamic> json) {
    sleepTime = TimeOfDayExtension.parse(json['sleepTime']);
    wakeTime = TimeOfDayExtension.parse(json['wakeTime']);
  }

  DayUnit.midnight() {
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

  static DayUnit? get next =>
      nextDaySleepTime != null && nextDayWakeTime != null
          ? DayUnit(nextDaySleepTime!, nextDayWakeTime!)
          : null;

  static onAwakened() async {
    debugPrint("Réveil");
    DayUnit.nextDayWakeTime = TimeOfDay.now();
    if (DayUnit.next != null) {
      final days = await all;
      days.add(DayUnit.next!);
      Data.write(days, localFile);
      nextDaySleepTime = null;
      nextDayWakeTime = null;
    }
  }

  static onWentToSleep() async {
    final today = await Weekday.today;
    debugPrint("Dodo");
    DayUnit.nextDaySleepTime = TimeOfDay.now();
    Timer(today.schedule!.durationSlept, () => onAwakened());
  }

  static Future<List<DayUnit>> get all async {
    final json = await localFile.readAll();

    return json.map((element) => DayUnit.fromJson(element)).toList();
  }

  @override
  String toString() =>
      'Day(${sleepTime.toStringFormatted()}, ${wakeTime.toStringFormatted()})';
}

extension DayGroups on List<DayUnit> {
  /// Crée une [List] de [List] à partir de [groupSize]
  ///
  /// Par exemple, si [this.length] est 14 et que [groupSize] est 7,
  ///
  /// La fonction retournera une [List] contenant deux [List] de longueur 7
  List<List<DayUnit>> groupBySize(int groupSize) {
    // Liste des jours présentement itérée
    late List<DayUnit> daysInCurrentGroup = [];

    // Toutes les listes
    late List<List<DayUnit>> dayGroups = [];
    for (var i = 0; i < length; i++) {
      DayUnit currentDay = this[i];
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

  /// Retourne un [DayUnit] avec le [sleepTime] et le [wakeTime] moyens
  /// d'une [List] crée à partir des [amount] dernières valeurs de [this]
  DayUnit averageFromLast([int amount = 1]) {
    if (isEmpty) return DayUnit.midnight();
    if (length == 1) return first;
    double totalTimeBeforeMidnight = 0;
    double totalTimeAfterMidnight = 0;

    int amountOfSleepTimesBeforeMidnight = 0;
    int amountOfSleepTimesAfterMidnight = 0;

    DayUnit combinedDay =
        getRange(length > amount ? length - amount : 0, length)
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
      return DayUnit(curr.sleepTime, [curr.wakeTime, next.wakeTime].average());
    });

    return DayUnit(
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
