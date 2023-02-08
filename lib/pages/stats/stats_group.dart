import 'package:flutter/material.dart';
import '../../models/time_interval.dart';
import '../../models/day.dart';
import 'stats_day.dart';

class StatsGroup extends StatelessWidget {
  List<Day> days;
  TimeInterval timeInterval;
  double parentWidth;
  double dayHeight;
  StatsGroup(this.days, this.timeInterval, this.parentWidth, this.dayHeight);
  @override
  Widget build(BuildContext context) {
    // debugPrint(days.length.toString());
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...days.map(
                (day) => StatsDay(day, timeInterval, parentWidth, dayHeight))
          ],
        ));
  }
}
