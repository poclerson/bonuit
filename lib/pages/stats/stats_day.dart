import 'package:flutter/material.dart';
import '../../models/day.dart';
import '../../models/time_interval.dart';

class StatsDay extends StatelessWidget {
  final Day day;
  final TimeInterval timeInterval;
  final double containerWidth;
  StatsDay(this.day, this.timeInterval, this.containerWidth);

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
