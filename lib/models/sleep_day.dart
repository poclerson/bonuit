import 'dart:async';

import 'time_slept.dart';
import 'local_files.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'time_of_day_extension.dart';
import 'data.dart';

/// Représente les données relatives à chaque jour de sommeil
class SleepDay extends TimeSlept implements Data {
  static LocalFiles localFile = LocalFiles('days');
  static JSONManager<SleepDay> json = JSONManager(
      localFile: localFile, constructor: ((json) => SleepDay.fromJson(json)));
  static late TimeOfDay? nextDaySleepTime;
  static late TimeOfDay? nextDayWakeTime;

  SleepDay(TimeOfDay sleepTime, TimeOfDay wakeTime) {
    this.sleepTime = sleepTime;
    this.wakeTime = wakeTime;
  }

  SleepDay.fromJson(Map<String, dynamic> json) {
    sleepTime = TimeOfDayExtension.parse(json['sleepTime']);
    wakeTime = TimeOfDayExtension.parse(json['wakeTime']);
  }

  SleepDay.midnight() {
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

  /// Représente le prochain `SleepDay`, ou celui qui est entrain de se produire
  /// si `nextDaySleepTime` n'est pas `null`
  ///
  /// `sleepTime` et `wakeTime` ne peuvent pas être `null`, donc on doit créer
  /// un getter statique avec deux `TimeOfDay` statiques
  static SleepDay? get next =>
      nextDaySleepTime != null && nextDayWakeTime != null
          ? SleepDay(nextDaySleepTime!, nextDayWakeTime!)
          : null;

  /// Appelée au réveil par le système de notifications
  static onAwakened() async {
    debugPrint('On se lève');
    SleepDay.nextDayWakeTime = TimeSlept.now;
    if (SleepDay.next != null) {
      json.add(SleepDay.next!);
      nextDaySleepTime = null;
      nextDayWakeTime = null;
    }
  }

  /// Appelée au coucher par le système de notifications
  static onWentToSleep() async {
    debugPrint('On va dormir');
    SleepDay.nextDaySleepTime = TimeSlept.now;
  }

  static deleteAll() async => await json.deleteAll();

  @override
  String toString() =>
      'Day(${sleepTime.toStringFormatted()}, ${wakeTime.toStringFormatted()})';
}

extension DayGroups on List<SleepDay> {
  /// Crée une [List] de [List] à partir de [groupSize]
  ///
  /// Par exemple, si [this.length] est 14 et que [groupSize] est 7,
  ///
  /// La fonction retournera une [List] contenant deux [List] de longueur 7
  List<List<SleepDay>> groupBySize(int groupSize) {
    // Liste des jours présentement itérée
    late List<SleepDay> daysInCurrentGroup = [];

    // Toutes les listes
    late List<List<SleepDay>> dayGroups = [];
    for (var i = 0; i < length; i++) {
      SleepDay currentDay = this[i];
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

  /// Retourne un [SleepDay] avec le [sleepTime] et le [wakeTime] moyens
  /// d'une [List] crée à partir des [amount] dernières valeurs de [this]
  SleepDay averageFromLast([int amount = 1]) {
    if (isEmpty) return SleepDay.midnight();
    if (length == 1) return first;
    double totalTimeBeforeMidnight = 0;
    double totalTimeAfterMidnight = 0;

    int amountOfSleepTimesBeforeMidnight = 0;
    int amountOfSleepTimesAfterMidnight = 0;

    SleepDay combinedDay =
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
      return SleepDay(curr.sleepTime, [curr.wakeTime, next.wakeTime].average());
    });

    return SleepDay(
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
