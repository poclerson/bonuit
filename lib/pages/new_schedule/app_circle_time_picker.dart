import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../models/time_of_day_extension.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'app_circle_time_picker_indicator.dart';
import 'package:flutter/cupertino.dart';

class AppCircleTimePicker extends StatefulWidget {
  late Schedule schedule;
  late Function(PickedTime sleep, PickedTime wake, bool? isDisableRange)
      onSelectionChanged;
  late Function(PickedTime sleep, PickedTime wake, bool? isDisableRange)
      onSelectionEnded;
  AppCircleTimePicker(this.schedule,
      {required this.onSelectionChanged, required this.onSelectionEnded});
  @override
  @override
  _AppCircleTimePickerState createState() => _AppCircleTimePickerState();
}

class _AppCircleTimePickerState extends State<AppCircleTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppCircleTimePickerIndicator(
                time: widget.schedule.sleepTime, period: TimePeriod.sleep),
            AppCircleTimePickerIndicator(
                time: widget.schedule.wakeTime, period: TimePeriod.wake)
          ],
        ),
        TimePicker(
          initTime: widget.schedule.sleepTime.toPickedTime(),
          endTime: widget.schedule.wakeTime.toPickedTime(),
          onSelectionChange: (sleep, wake, isDisableRange) =>
              widget.onSelectionChanged(sleep, wake, isDisableRange),
          onSelectionEnd: (sleep, wake, isDisableRange) =>
              widget.onSelectionEnded(sleep, wake, isDisableRange),
          width: 400,
          height: 400,
          primarySectors: 12,
          secondarySectors: 48,
          decoration: TimePickerDecoration(
              baseColor: Theme.of(context).colorScheme.surface,
              // Grands diviseurs
              primarySectorsDecoration: TimePickerSectorDecoration(
                  width: 2,
                  radiusPadding: 30,
                  color: Theme.of(context).colorScheme.primary,
                  size: 5),
              // Petits diviseurs
              secondarySectorsDecoration: TimePickerSectorDecoration(
                  width: 2,
                  radiusPadding: 30,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 2.5),
              // Sélecteur
              sweepDecoration: TimePickerSweepDecoration(
                pickerStrokeWidth: 40,
                pickerColor: Theme.of(context).colorScheme.primary,
                useRoundedPickerCap: true,
              ),
              // Poignée de début
              initHandlerDecoration: TimePickerHandlerDecoration(
                color: Colors.transparent,
                icon: Icon(
                  Icons.bed,
                  size: 25,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              // Poignée de fin
              endHandlerDecoration: TimePickerHandlerDecoration(
                  color: Colors.transparent,
                  icon: Icon(
                    Icons.alarm,
                    size: 25,
                    color: Theme.of(context).colorScheme.background,
                  )),
              // Chiffres de l'horloge
              clockNumberDecoration: TimePickerClockNumberDecoration(
                  clockTimeFormat: ClockTimeFormat.TWENTYFOURHOURS,
                  defaultTextColor: Theme.of(context).colorScheme.onBackground,
                  clockIncrementTimeFormat: ClockIncrementTimeFormat.FIFTEENMIN,
                  scaleFactor: 2.75,
                  textScaleFactor: .4)),
          child: Align(
            child: Text(
              widget.schedule.timeInterval(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ],
    );
  }
}
