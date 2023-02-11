import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay difference(TimeOfDay other) {
    return TimeOfDay(
        hour: other.hour > hour
            ? other.hour - hour
            : TimeOfDay.hoursPerDay - other.hour + hour,
        minute: other.minute - minute);
  }

  TimeOfDay addition(TimeOfDay other) {
    return TimeOfDay(hour: hour + other.hour, minute: minute + other.minute);
  }

  double toDouble() => double.parse('$hour.${(minute / .6).round()}');

  int toInt() => toDouble().round();

  String toStringFormatted([String separator = 'h']) {
    String unformatted = toDouble().toString();
    String hours = unformatted.split('.')[0];
    String minutes = unformatted.split('.')[1].padLeft(2, '0');
    return '$hours$separator$minutes';
  }

  PickedTime toPickedTime() => PickedTime(h: hour, m: minute);

  static TimeOfDay fromString(String string) {
    List<String> hoursAndMinutes =
        string.split(string.contains('h') ? 'h' : ':');
    return TimeOfDay(
        hour: int.parse(hoursAndMinutes[0]),
        minute: int.parse(hoursAndMinutes[1]));
  }

  static TimeOfDay fromPickedTime(PickedTime pickedTime) =>
      TimeOfDay(hour: pickedTime.h, minute: pickedTime.m);
}

extension TimeOfDayListExtension on List<TimeOfDay> {
  TimeOfDay average() {
    TimeOfDay tod =
        (map((tod) => tod.toDouble()).reduce((curr, next) => curr + next) /
                length)
            .toTimeOfDay();
    return tod;
  }
}

extension Hour on double {
  String toTime([String separator = 'h']) {
    if (this < 0) return '00h00';

    int floored = floor();
    double decimal = this - floored;
    String hour = '${floored % 24}';
    String minute = '${(decimal * 60).toInt()}'.padLeft(2, '0');
    return '$hour$separator$minute';
  }

  TimeOfDay toTimeOfDay() {
    int floored = floor();
    double decimal = this - floored;
    int hour = floored % 24;
    int minute = (decimal * 60).toInt();
    return TimeOfDay(hour: hour, minute: minute);
  }
}
