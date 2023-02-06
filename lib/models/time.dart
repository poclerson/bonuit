import 'dart:core';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class Time {
  late int hours;
  late int minutes;
  static final Time zero = Time(0, 0);

  Time(this.hours, this.minutes);

  Time.fromString(String time) {
    bool ifLongTime = time.length == 5;
    hours = int.parse(ifLongTime ? time.substring(0, 2) : time.substring(0, 1));
    minutes =
        int.parse(ifLongTime ? time.substring(3, 5) : time.substring(2, 4));
  }

  Time.fromPickedTime(PickedTime pickedTime) {
    hours = pickedTime.h;
    minutes = pickedTime.m;
  }

  @override

  /// Transforme le texte en [String]
  /// en ajoutant [h] ou [:] entre les [hours] et les [minutes]
  String toString([bool useColumn = true]) {
    return (hours == 0 ? '00' : hours.toString()) +
        (useColumn ? ':' : 'h') +
        (minutes == 0 ? '00' : minutes.toString());
  }

  PickedTime toPickedTime() {
    return PickedTime(h: hours, m: minutes);
  }

  Time difference(Time endTime) {
    DateTime now = DateTime.now();
    DateTime startDateTime =
        DateTime(now.year, now.month, now.day, hours, minutes);
    DateTime endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hours, endTime.minutes);

    Duration difference = startDateTime.difference(endDateTime);
    return Time(difference.inHours, difference.inMinutes);
  }
}
