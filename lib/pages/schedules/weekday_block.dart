import 'package:flutter/material.dart';
import '../../models/weekday.dart';
import '../../models/schedule.dart';

class WeekdayBlock extends StatefulWidget {
  final Weekday _weekday;
  late Color _color = _weekday.schedule!.color;
  WeekdayBlock(this._weekday);
  @override
  _WeekdayBlockState createState() => _WeekdayBlockState();
}

class _WeekdayBlockState extends State<WeekdayBlock> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<Schedule>(
      builder: (context, candidateSchedules, rejectedSchedules) {
        return Container(
            width: 75,
            height: 75,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: widget._color,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Align(
              child: Text(
                widget._weekday.day[0].toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ));
      },
      // Hover
      onWillAccept: (schedule) {
        setState(() {
          widget._color = schedule!.color;
        });
        return schedule is Schedule;
      },

      // Fin du hover
      onLeave: (schedule) {
        setState(() {
          widget._color = widget._weekday.schedule!.color;
        });
      },

      // Drop
      onAccept: (schedule) {
        setState(() {
          widget._weekday.schedule!.color = schedule.color;
          widget._weekday.changeSchedule(schedule);
        });
      },
    );
  }
}
