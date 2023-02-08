import 'package:flutter/material.dart';
import '../../models/day.dart';
import '../../models/time_interval.dart';

class StatsDay extends StatelessWidget {
  final Day day;
  final TimeInterval timeInterval;
  final double containerWidth;
  final double dayHeight;
  StatsDay(this.day, this.timeInterval, this.containerWidth, this.dayHeight);

  @override
  Widget build(BuildContext context) {
    // debugPrint(day.sleepTime.toString());
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.only(
          left: timeInterval.ratioedOffset(day.sleepTime, containerWidth)),
      width: timeInterval.timeToRatio(day.hoursSlept(), containerWidth),
      height: dayHeight,
    );
  }
}
