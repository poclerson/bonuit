import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AppTimePickerSpinner extends StatefulWidget {
  TimeOfDay defaultTime;
  Function(DateTime) onTimeChanged;
  AppTimePickerSpinner(
      {required this.defaultTime, required this.onTimeChanged});
  @override
  _AppTimePickerSpinnerState createState() => _AppTimePickerSpinnerState();
}

class _AppTimePickerSpinnerState extends State<AppTimePickerSpinner> {
  @override
  Widget build(BuildContext context) {
    return TimePickerSpinner(
        alignment: Alignment.center,
        isForce2Digits: true,
        minutesInterval: 15,
        time: DateTime(
            0, 0, 0, widget.defaultTime.hour, widget.defaultTime.minute),
        itemWidth: 80,
        itemHeight: 100,
        normalTextStyle: Theme.of(context).textTheme.headlineLarge,
        highlightedTextStyle: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 40,
                fontWeight: FontWeight.w900),
        onTimeChange: (time) => widget.onTimeChanged(time));
  }
}
