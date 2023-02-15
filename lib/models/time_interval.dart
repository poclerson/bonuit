import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';

class TimeInterval {
  final int length;
  final List<int> intervals;

  TimeInterval(this.length, this.intervals);

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
