import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';
import 'sleep_day.dart';

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
          SleepDay(earliestSleepTime, latestWakeTime).hoursSlept.toDouble();

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
