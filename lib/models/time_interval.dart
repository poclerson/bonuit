import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';
import 'sleep_day.dart';
import 'package:flutter/material.dart';

/// Liste des intervalles de temps générées dynamiquement depuis une `List<SleepDay>`
/// en y trouvant le plus tôt `sleepTime` et le plus tard `wakeTime`
///
/// Génère une `List<int>` de temps, représentant les heures.
///
/// La première valeur y sera toujours le `sleepTime` le plus tôt, arrondi vers le bas
/// La dernière valeur y sera toujours le `wakeTime` le plus tard, arrondi vers le haut
///
/// Toutes les valeurs entre auront un écart égal décidé par `length`.
///
/// Le nombre d'intervalles est décidé lors de l'instantiation de `TimeInterval`
class TimeInterval {
  late int length;
  late List<int> intervals;
  TimeInterval({required List<SleepDay> days, required int intervalAmount}) {
    if (days.isNotEmpty) {
      SleepDay maximumDay = days.reduce((curr, next) {
        double currentSleepDouble = curr.sleepTime.toDouble();
        double nextSleepDouble = next.sleepTime.toDouble();

        /// Si c'est pas le même jour, faire -24 à sleepTime
        if (!next.isSameDay) {
          nextSleepDouble = -next.sleepTime.distanceFromMidnight;
        }

        // Comparer
        return SleepDay(
            (currentSleepDouble > nextSleepDouble
                    ? nextSleepDouble
                    : currentSleepDouble)
                .toTimeOfDay(),
            curr.wakeTime > next.wakeTime ? curr.wakeTime : next.wakeTime);
      });

      late double difference = maximumDay.hoursSlept;
      List<int> intervals = [];

      // Empêcher d'avoir une longueur d'intervalles trop longue, -1
      int intervalLength = (difference / intervalAmount.toDouble()).ceil();
      difference += intervalLength.toDouble();

      for (var i = 0; i < difference; i += intervalLength) {
        int untreatedHour = i + maximumDay.sleepTime.hour;
        intervals.add(untreatedHour % 24);
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

    if (offset >= intervals.first) {
      difference = (offset - intervals.first).toDouble();
    } else {
      difference = 24 - intervals.first + offset.toDouble();
    }

    ratio -= ratio * length / width;
    return (ratio * difference / width);
  }
}
