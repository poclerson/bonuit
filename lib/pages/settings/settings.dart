import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import 'settings_button.dart';
import '../../models/sleep_target.dart';
import 'app_time_picker_spinner.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              "Préférences",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SettingsButton(
                  icon: Icon(Icons.single_bed_rounded),
                  text: 'Objectif de sommeil',
                  action: Text(SleepTarget.duration.toStringHoursMinutes()),
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => AppTimePickerSpinner(
                          defaultTime: TimeOfDay(
                              hour: SleepTarget.hours,
                              minute: SleepTarget.minutes),
                          onTimeChanged: (time) => setState(() {
                                SleepTarget.duration = Duration(
                                    hours: time.hour, minutes: time.minute);
                              }))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
