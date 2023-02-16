import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';
import 'day.dart';

class TimeInterval {
  late int length;
  late List<int> intervals;

  TimeInterval({required List<Day> days, required int intervalAmount}) {
    if (days.isNotEmpty) {
      TimeOfDay earliestSleepTime = days.reduce((current, next) {
        // Les deux jours ont des heures de coucher après minuit
        if (!current.isSameDay && !next.isSameDay) {
          if (current.sleepTime.hour < next.sleepTime.hour) return current;
          return next;
        }

        // Si seulement un des deux jours est après minuit, on le retourne nécessairement
        if (!next.isSameDay) return next;
        if (!current.isSameDay) return current;

        if (current.sleepTime.hour < next.sleepTime.hour) return current;
        return next;
      }).sleepTime;

      TimeOfDay latestWakeTime = days
          .reduce((current, next) =>
              current.wakeTime.hour > next.wakeTime.hour ? current : next)
          .wakeTime;

      late double difference =
          Day(earliestSleepTime, latestWakeTime, DateTime.now())
              .hoursSlept
              .toDouble();

      List<int> intervals = [];

      int intervalLength = (difference / intervalAmount.toDouble()).ceil();
      difference += intervalLength.toDouble();

      for (var i = 0; i < difference; i += intervalLength) {
        int untreatedHour = i + earliestSleepTime.hour;
        intervals.add(untreatedHour < 24 ? untreatedHour : untreatedHour - 24);
      }

      length = intervalLength;
      this.intervals = intervals;
      return;
    }
    length = 0;
    intervals = [];
  }

  int get width {
    if (intervals.last > intervals.first) {
      return intervals.last - intervals.first;
    } else {
      return 24 - intervals.first + intervals.last;
    }
  }

  double ratioedOffset(TimeOfDay offset, double ratio) {
    List<int> intervalsFromZero = [];
    double value = offset.toDouble();
    for (var i = 0; i < intervals.length; i++) {
      intervalsFromZero.add(i * length);
    }

    double difference = 0;

    if (value > intervals.first)
      difference = value - intervals.first;
    else
      difference = 24 - intervals.first + value;

    ratio -= ratio * length / width;
    return (ratio * difference / width);
  }
}
