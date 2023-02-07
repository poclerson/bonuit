import 'package:get/get.dart';

import 'day.dart';
import 'package:flutter/material.dart';

class TimeInterval {
  final int length;
  final int totalLength;
  final List<int> intervals;

  TimeInterval(this.length, this.totalLength, this.intervals);

  double timeToRatio(double time, double ratioer) {
    return ratioer * time / totalLength.toDouble();
  }

  int mostSimilarIntervalTo(int value) {
    Map<int, int> differences = {};
    intervals.forEach(
        (interval) => differences[interval] = (interval - value).abs());
    int mostSimilar = differences.entries
        .reduce((current, next) => current.value < next.value ? current : next)
        .key;
    return mostSimilar;
  }

  double ratioedOffset(TimeOfDay value, double ratio) {
    int unOffsettedValue = mostSimilarIntervalTo(value.toInt());
    double difference = value.toDouble() - unOffsettedValue.toDouble();
    return timeToRatio(
        intervals.indexOf(unOffsettedValue) * length.toDouble() + difference,
        ratio);
  }
}
