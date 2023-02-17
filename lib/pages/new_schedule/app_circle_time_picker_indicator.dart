import 'package:flutter/material.dart';
import '../../models/time_of_day_extension.dart';
import 'package:flutter/cupertino.dart';

enum TimePeriod { sleep, wake }

class AppCircleTimePickerIndicator extends StatelessWidget {
  TimeOfDay time;
  TimePeriod period;
  AppCircleTimePickerIndicator({required this.time, required this.period});

  Map<TimePeriod, IconData> periodIcons = {
    TimePeriod.sleep: CupertinoIcons.bed_double_fill,
    TimePeriod.wake: CupertinoIcons.alarm_fill
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(periodIcons[period]),
        Text(
          time.toStringFormatted(),
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
