import 'package:flutter/material.dart';
import 'stats_day.dart';

class StatsWeek extends StatelessWidget {
  List<StatsDay> days;
  StatsWeek(this.days);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...days],
        ));
  }
}
