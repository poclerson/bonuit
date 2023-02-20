import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';

abstract class TimeSlept {
  late TimeOfDay sleepTime;
  late TimeOfDay wakeTime;

  double get hoursSlept {
    double doubleSleepTime = sleepTime.toDouble();
    double doubleWakeTime = wakeTime.toDouble();
    if (doubleSleepTime == doubleWakeTime) return 0;
    if (!isSameDay) {
      return TimeOfDay.hoursPerDay.toDouble() -
          doubleSleepTime +
          doubleWakeTime;
    }
    return doubleWakeTime - doubleSleepTime;
  }

  bool get isSameDay => sleepTime.toDouble() <= wakeTime.toDouble();

  Duration get durationSlept =>
      Duration(seconds: (hoursSlept * 60 * 60).toInt());
}
