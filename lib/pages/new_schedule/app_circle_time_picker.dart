import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../models/time_of_day_extension.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../models/sleep_target.dart';

class AppCircleTimePicker extends StatelessWidget {
  late Schedule schedule;
  late Function(PickedTime sleep, PickedTime wake, bool? isDisableRange)
      onSelectionChanged;
  late Function(PickedTime sleep, PickedTime wake, bool? isDisableRange)
      onSelectionEnded;
  AppCircleTimePicker(this.schedule,
      {required this.onSelectionChanged, required this.onSelectionEnded});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimePicker(
          initTime: schedule.sleepTime.toPickedTime(),
          endTime: schedule.wakeTime.toPickedTime(),
          onSelectionChange: (sleep, wake, isDisableRange) =>
              onSelectionChanged(sleep, wake, isDisableRange),
          onSelectionEnd: (sleep, wake, isDisableRange) =>
              onSelectionEnded(sleep, wake, isDisableRange),
          width: 400,
          height: 400,
          primarySectors: 12,
          secondarySectors: 48,
          decoration: TimePickerDecoration(
              baseColor: Theme.of(context).colorScheme.onBackground,
              // Grands diviseurs
              primarySectorsDecoration: TimePickerSectorDecoration(
                  width: 2,
                  radiusPadding: 30,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 5),
              // Petits diviseurs
              secondarySectorsDecoration: TimePickerSectorDecoration(
                  width: 2,
                  radiusPadding: 30,
                  color: Theme.of(context).colorScheme.surface,
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
                ),
              ),
              // Poignée de fin
              endHandlerDecoration: TimePickerHandlerDecoration(
                  color: Colors.transparent,
                  icon: Icon(
                    Icons.alarm,
                    size: 25,
                  )),
              // Chiffres de l'horloge
              clockNumberDecoration: TimePickerClockNumberDecoration(
                  clockTimeFormat: ClockTimeFormat.TWENTYFOURHOURS,
                  defaultTextColor: Theme.of(context).colorScheme.primary,
                  clockIncrementTimeFormat: ClockIncrementTimeFormat.FIFTEENMIN,
                  scaleFactor: 2.75,
                  textScaleFactor: .4)),
          child: Align(
            child: Text(
              schedule.timeInterval(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        Text(schedule.hoursSlept.toTimeOfDay().toStringFormatted())
      ],
    );
  }
}
