import 'package:flutter/material.dart';
import '../../models/weekday.dart';
import '../../models/schedule.dart';
import 'package:contrast_checker/contrast_checker.dart';

class WeekdayBlock extends StatefulWidget {
  final Weekday weekday;
  final Color defaultColor;
  final Function updateWeekdays;
  late Color? _color =
      weekday.schedule != null ? weekday.schedule!.color : null;
  WeekdayBlock(
      {required this.weekday,
      required this.defaultColor,
      required this.updateWeekdays});
  @override
  WeekdayBlockState createState() => WeekdayBlockState();
}

class WeekdayBlockState extends State<WeekdayBlock> {
  final checker = ContrastChecker();
  final double padding = 10;
  late double boxWidth =
      (MediaQuery.of(context).size.width / 4 - 30).clamp(50, 100);

  @override
  Widget build(BuildContext context) {
    return DragTarget<Schedule>(
      builder: (context, candidateSchedules, rejectedSchedules) {
        return GestureDetector(
          onTap: () => debugPrint(widget.weekday.schedule.toString()),
          onDoubleTap: () {
            setState(() {
              widget._color = null;
            });
            widget.weekday.onScheduleRemoved();
          },
          child: Container(
              width: boxWidth,
              height: boxWidth,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: widget._color ??
                      Theme.of(context).colorScheme.onBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Align(
                child: Text(
                  widget.weekday.day[0].toUpperCase(),
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: checker.contrastCheck(
                              Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .fontSize!,
                              Theme.of(context).colorScheme.background,
                              widget._color ??
                                  Theme.of(context).colorScheme.onBackground,
                              WCAG.AA)
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.onBackground),
                ),
              )),
        );
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
          widget._color = widget.weekday.schedule != null
              ? widget.weekday.schedule!.color
              : Theme.of(context).colorScheme.onBackground;
        });
      },

      // Drop
      onAccept: (schedule) async {
        await widget.weekday.onScheduleAdded(schedule);
        setState(() {
          widget.weekday.schedule = schedule;
        });
      },
    );
  }
}
