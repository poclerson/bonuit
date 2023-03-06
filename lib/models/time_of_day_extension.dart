import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

/// Fournit plusieurs méthodes, opérateurs et méthodes de convertissement
/// en plus de celles déjà existantes dans `TimeOfDay`
extension TimeOfDayExtension on TimeOfDay {
  /// Soustrait deux `TimeOfDay` en prenant en compte de la limite de 23:59
  /// Si `this` va devenir négatif, on le ramnène pour faire le cycle complet
  TimeOfDay operator -(dynamic other) {
    if (other is! TimeOfDay) {
      if (other is int) other = other.toDouble();
      other = (other as double).toTimeOfDay();
    }
    int newMinute = minute;
    int newHour = hour;
    if (minute - other.minute < 0) {
      newHour--;
      newMinute = (minute - other.minute) % 60;
    } else {
      newMinute = minute - other.minute;
    }
    newHour -= other.hour;
    return TimeOfDay(hour: newHour.abs(), minute: newMinute);
  }

  /// Soustrait deux `TimeOfDay` sans prendre en compte de la limite
  /// Peut être négatif
  TimeOfDay operator /(int divider) =>
      TimeOfDay(hour: hour ~/ divider, minute: minute ~/ divider);

  /// Additionne deux [TimeOfDay] en prenant en compte la limite à 23:59
  TimeOfDay operator +(TimeOfDay other) {
    int newMinute = minute;
    int newHour = hour;
    if (minute + other.minute > 59) {
      newHour++;
      newMinute = (minute + other.minute) % 60;
    }

    if (newHour + other.hour > 23) {
      newHour = (newHour + other.hour) % 24;
      return TimeOfDay(hour: newHour, minute: newMinute);
    }

    return this;
  }

  double toDouble() {
    int hour = this.hour;
    double minute = this.minute / 60;
    return hour + minute;
  }

  /// Additionne deux [TimeOfDay] sans prendre en compte de la limite à 23:59
  TimeOfDay operator *(TimeOfDay other) =>
      TimeOfDay(hour: hour + other.hour, minute: minute + other.minute);

  bool operator >(dynamic other) {
    if (other is double || other is int) return toDouble() > other;
    return toDouble() > (other as TimeOfDay).toDouble();
  }

  bool operator <(dynamic other) {
    if (other is double || other is int) return toDouble() < other;
    return toDouble() < (other as TimeOfDay).toDouble();
  }

  bool operator <=(dynamic other) {
    if (other is double || other is int) return toDouble() <= other;
    return toDouble() <= (other as TimeOfDay).toDouble();
  }

  bool operator >=(dynamic other) {
    if (other is double || other is int) return toDouble() >= other;
    return toDouble() >= (other as TimeOfDay).toDouble();
  }

  bool isEqual(TimeOfDay other) => hour == other.hour && minute == other.minute;

  double get distanceFromMidnight =>
      (TimeOfDay(hour: 24, minute: 0) - this).toDouble();

  int toInt() => toDouble().round();

  String toStringFormatted(
      [String separator = ':', bool formatBeautifully = false]) {
    String time = toString()
        .substring(toString().indexOf('(') + 1, toString().indexOf(')'))
        .replaceAll(':', separator);
    // Retirer le premier 0 si les heures n'ont qu'une chiffre
    if (hour < 10) time = time.substring(1, time.length);

    if (formatBeautifully) {
      // N'afficher que les minutes si c'est sous une heure
      if (hour == 0) time = '${time.substring(2, time.length)} minutes';

      if (minute == 0) {
        time =
            '${time.substring(0, 2).replaceAll(separator, '')} heure${hour > 1 ? 's' : ''}';
      }
    }

    return time;
  }

  PickedTime toPickedTime() => PickedTime(h: hour, m: minute);

  static TimeOfDay parse(String string) {
    List<String> hoursAndMinutes =
        string.split(string.contains('h') ? 'h' : ':');
    return TimeOfDay(
        hour: int.parse(hoursAndMinutes[0]) % 24,
        minute: int.parse(hoursAndMinutes[1]) % 60);
  }

  static TimeOfDay fromPickedTime(PickedTime pickedTime) =>
      TimeOfDay(hour: pickedTime.h, minute: pickedTime.m);
}

extension TimeOfDayListExtension on List<TimeOfDay> {
  TimeOfDay average() {
    return (map((tod) => tod.toDouble()).reduce((curr, next) => curr + next) /
            length)
        .toTimeOfDay();
  }

  TimeOfDay averageFromLast([int amount = 1]) {
    return getRange(length > amount ? length - amount : 0, length)
        .toList()
        .average();
  }

  TimeOfDay get latest => reduce((curr, next) => curr > next ? curr : next);
  TimeOfDay get earliest => reduce((curr, next) => curr < next ? curr : next);
}

extension PickedTimeExtension on PickedTime {
  bool isEqual(PickedTime other) => (h == other.h && m == other.m);
}

extension Hour on double {
  TimeOfDay toTimeOfDay() {
    assert(isFinite);
    int floored = floor();
    double decimal = this - floored;
    int hour = floored % 24;
    int minute = (decimal * 60).toInt();
    return TimeOfDay(hour: hour, minute: minute);
  }
}
