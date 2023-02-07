import 'package:flutter/material.dart';
import '../../models/day.dart';
import '../../models/time_interval.dart';
import 'dart:math';

class DayBar extends StatelessWidget {
  final Day day;
  final TimeInterval timeInterval;
  final double containerWidth;
  DayBar(this.day, this.timeInterval, this.containerWidth);

  double mostSimilarInterval(double number) {
    Map<double, double> differences = {};
    timeInterval.intervals.forEach((interval) {
      differences[interval.toDouble()] = (interval - number).abs();
    });
    double mostSimilar = differences.entries
        .reduce((current, next) => current.value < next.value ? current : next)
        .key;
    return mostSimilar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.only(
          left: timeInterval.ratioedOffset(day.sleepTime, containerWidth)),
      width: timeInterval.timeToRatio(day.hoursSlept(), containerWidth),
      height: 30,
    );
  }
}
