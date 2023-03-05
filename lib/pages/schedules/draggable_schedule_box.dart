import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../widgets/round_icon_button.dart';
import '../../models/time_of_day_extension.dart';
import 'package:contrast_checker/contrast_checker.dart';

class DraggableScheduleBox extends StatefulWidget {
  final Schedule schedule;
  final Function onEdited;
  final double boxWidth = 80;

  DraggableScheduleBox({required this.schedule, required this.onEdited});
  @override
  _DraggableScheduleBoxState createState() => _DraggableScheduleBoxState();
}

class _DraggableScheduleBoxState extends State<DraggableScheduleBox> {
  Color get contrastedColor {
    final checker = ContrastChecker();
    return checker.contrastCheck(
            Theme.of(context).textTheme.headlineLarge!.fontSize!,
            Theme.of(context).colorScheme.background,
            widget.schedule.color ?? Theme.of(context).colorScheme.onBackground,
            WCAG.AA)
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.onBackground;
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Schedule>(
      delay: Duration(milliseconds: 200),
      data: widget.schedule,
      dragAnchorStrategy: (draggable, context, position) =>
          Offset(widget.boxWidth / 2, widget.boxWidth / 2),
      feedback: Container(
        width: widget.boxWidth,
        height: widget.boxWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.schedule.color,
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              widget.schedule.name[0].toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Theme.of(context).colorScheme.background),
            )),
      ),
      child: GestureDetector(
          onTap: () => widget.onEdited(),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: widget.schedule.color,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.schedule.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(color: contrastedColor),
                    ),
                    Text(
                      widget.schedule.sleepTime.toStringFormatted(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: contrastedColor),
                    ),
                    Text(
                      widget.schedule.wakeTime.toStringFormatted(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: contrastedColor),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
