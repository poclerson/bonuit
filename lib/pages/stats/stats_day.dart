import 'package:flutter/material.dart';
import '../../models/sleep_day.dart';
import '../../models/time_interval.dart';

class StatsDay extends StatelessWidget {
  final Size size;
  final double offset;
  StatsDay({required this.size, required this.offset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.only(left: offset),
      width: size.width,
      height: size.height,
    );
  }
}
