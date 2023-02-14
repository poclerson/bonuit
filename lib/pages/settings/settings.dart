import 'dart:ui';

import 'settings_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import 'settings_section.dart';
import '../../models/sleep_target.dart';
import 'app_time_picker_spinner.dart';
import 'theme_mode_picker.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    debugPrint(Theme.of(context).colorScheme.onBackground.toString());
    return Scaffold(
        bottomNavigationBar: NavBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 125),
              child: Text(
                "Préférences",
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                runSpacing: 50,
                children: [
                  SettingsSection(
                      iconData: Icons.single_bed_rounded,
                      title: 'Sommeil',
                      children: [
                        SettingsButton(
                          text: 'Objectif de sommeil',
                          content:
                              Text(SleepTarget.duration.toStringHoursMinutes()),
                          onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => AppTimePickerSpinner(
                                  defaultTime: TimeOfDay(
                                      hour: SleepTarget.hours,
                                      minute: SleepTarget.minutes),
                                  onTimeChanged: (time) => setState(() {
                                        SleepTarget.duration = Duration(
                                            hours: time.hour,
                                            minutes: time.minute);
                                      }))),
                        )
                      ]),
                  SettingsSection(
                      iconData: Icons.brush_rounded,
                      title: 'Thème',
                      children: [ThemeModePicker()],
                      isButtonSection: false),
                  // SettingsSection(
                  //     iconData: Icons.brush_rounded,
                  //     text: 'Thème',
                  //     content: Text(Theme.of(context).brightness.toString()),
                  //     onPressed: () => setState(() {
                  //           AppTheme.themeMode.add(
                  //               Theme.of(context).brightness == Brightness.dark
                  //                   ? ThemeMode.light
                  //                   : ThemeMode.dark);
                  //         }))
                ],
              ),
            )
          ],
        ));
  }
}
