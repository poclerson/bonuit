import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';

/// À implémenter dans toutes les classes ayant avoir à faire avec une
/// heure de coucher et une heure de lever
///
/// Fournit plusieurs `getters` permettant d'intéragir plus facilement avec
/// `sleepTime` et `wakeTime`
abstract class TimeSlept {
  late TimeOfDay sleepTime;
  late TimeOfDay wakeTime;

  static TimeOfDay get now => TimeOfDay.now();

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

  /// `Duration` entre maintenant et le temps de coucher
  Duration get beforeSleep {
    late TimeOfDay difference;
    // Même jour
    if (now < sleepTime) {
      difference = sleepTime - now;
      return Duration(hours: difference.hour, minutes: difference.minute);
    }

    difference = (24 - now.toDouble() + sleepTime.toDouble()).toTimeOfDay();
    return Duration(hours: difference.hour, minutes: difference.minute);
  }

  /// `Duration` entre maintenant et le temps de lever
  Duration get beforeWake {
    late TimeOfDay difference;
    // Même jour
    if (now < wakeTime) {
      difference = wakeTime - now;
      return Duration(hours: difference.hour, minutes: difference.minute);
    }

    difference = (24 - now.toDouble() + wakeTime.toDouble()).toTimeOfDay();
    return Duration(hours: difference.hour, minutes: difference.minute);
  }

  bool get isSupposedToBeAsleep {
    if (isSameDay) {
      return now > sleepTime && now < wakeTime;
    }

    return now > sleepTime || now < wakeTime;
  }
}
