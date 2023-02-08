import 'package:flutter/material.dart';
import '../../models/day.dart';
import '../../models/time_interval.dart';
import 'stats_day.dart';

class StatsWeek extends StatelessWidget {
  List<StatsDay> days;
  StatsWeek(this.days);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...days],
    );
  }
}
