import 'package:flutter/material.dart';
import 'stats_group.dart';
import '../../widgets/size_mesurer.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../../models/day.dart';
import '../../models/time_interval.dart';
import '../../models/sort_method.dart';

class StatsGroups extends StatefulWidget {
  List<Day> days;
  TimeInterval timeInterval;
  SortMethod sortMethod;
  void Function(int) onPageChanged;
  StatsGroups(this.days,
      {required this.timeInterval,
      required this.sortMethod,
      required this.onPageChanged});
  @override
  _StatsGroupsState createState() => _StatsGroupsState();
}

class _StatsGroupsState extends State<StatsGroups> {
  @override
  Widget build(BuildContext context) {
    debugPrint('groups ' + widget.sortMethod.name);
    return ChildSizeNotifier((context, size, child) {
      return Expanded(
          child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...widget.timeInterval.intervals.map((time) => Expanded(
                    child: Row(children: [
                      Dash(
                        direction: Axis.vertical,
                        length: size.height,
                        dashColor: Theme.of(context).colorScheme.secondary,
                      )
                    ]),
                  ))
            ],
          ),
          PageView(
              reverse: true,
              scrollDirection: Axis.vertical,
              onPageChanged: (pageIndex) => widget.onPageChanged(pageIndex),
              children: [
                ...widget.days.reversed
                    .toList()
                    .groupBySize(widget.sortMethod.dayAmount)
                    .map((dayGroup) => StatsGroup(
                          dayGroup,
                          timeInterval: widget.timeInterval,
                          parentSize: size,
                          dayHeight:
                              (size.height / widget.sortMethod.dayAmount * .75)
                                  .clamp(0, 35),
                          sortingBy: widget.sortMethod.dayAmount,
                        ))
              ]),
        ],
      ));
    }, Container());
  }
}
