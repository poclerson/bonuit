import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import '../../models/time_interval.dart';
import '../../models/sleep_day.dart';
import 'stats_day.dart';

class StatsGroup extends StatefulWidget {
  late List<SleepDay> days;
  TimeInterval timeInterval;
  Size parentSize;
  double dayHeight;
  int sortingBy;
  StatsGroup(List<SleepDay> days,
      {required this.timeInterval,
      required this.parentSize,
      required this.dayHeight,
      required this.sortingBy}) {
    this.days = days.reversed.toList();
  }
  @override
  _StatsGroupState createState() => _StatsGroupState();
}

class _StatsGroupState extends State<StatsGroup> {
  @override
  Widget build(BuildContext context) {
    double realHeight = widget.parentSize.height - 40;
    double totalSeparatorHeight =
        realHeight - (widget.dayHeight) * widget.sortingBy;
    double separatorHeight = totalSeparatorHeight / (widget.sortingBy - 1);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: SeparatedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          separatorBuilder: (context, index) => widget.parentSize.height > 0
              ? SizedBox(
                  height: separatorHeight,
                )
              : Expanded(child: SizedBox()),
          children: [
            ...widget.days.map(
              (day) => StatsDay(
                  size: Size(
                      // widget.timeInterval
                      //     .timeToRatio(day.hoursSlept, widget.parentSize.width),
                      widget.timeInterval.ratioedOffset(
                          day.timeOfDaySlept, widget.parentSize.width),
                      widget.dayHeight),
                  offset: widget.timeInterval
                      .ratioedOffset(day.sleepTime, widget.parentSize.width)),
            )
          ],
        ));
  }
}
