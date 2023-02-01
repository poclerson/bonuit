import 'package:flutter/material.dart';
import '../../models/weekday.dart';
import '../../models/schedule.dart';

class WeekdayBlock extends StatefulWidget {
  final Weekday _weekday;
  WeekdayBlock(this._weekday);
  @override
  _WeekdayBlockState createState() => _WeekdayBlockState(_weekday);
}

class _WeekdayBlockState extends State<WeekdayBlock> {
  Weekday _weekday;
  late Color _hoverColor = _weekday.schedule.color;

  _WeekdayBlockState(this._weekday);

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
                color: _hoverColor,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Align(
              child: Text(
                _weekday.day[0].toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ));
      },
      // Hover
      onWillAccept: (schedule) {
        setState(() {
          _hoverColor = schedule!.color;
        });
        return schedule is Schedule;
      },

      // Fin du hover
      onLeave: (schedule) {
        setState(() {
          _hoverColor = _weekday.schedule.color;
        });
      },

      // Drop
      onAccept: (schedule) {
        setState(() {
          _weekday.schedule.color = schedule.color;
          _weekday.changeSchedule(schedule);
        });
      },
    );
  }
}
