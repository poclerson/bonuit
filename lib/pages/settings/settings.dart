import 'dart:ui';

import 'settings_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import 'settings_section.dart';
import '../../models/sleep_target.dart';
import 'app_time_picker_spinner.dart';
import 'theme_mode_picker.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/choices_prompt.dart';
import '../../models/sleep_day.dart';
import '../../models/time_of_day_extension.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(),
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 2.5 / 100),
            child: Column(
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
                          iconData: CupertinoIcons.bed_double_fill,
                          title: 'Sommeil',
                          children: [
                            SettingsButton(
                              text: 'Objectif de sommeil',
                              content: Text(
                                SleepTarget().duration.toStringFormatted('h'),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontWeight: FontWeight.w900),
                              ),
                              onPressed: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AppTimePickerSpinner(
                                      defaultTime: SleepTarget().duration,
                                      onTimeChanged: (time) => setState(() {
                                            SleepTarget().setDuration(TimeOfDay(
                                                hour: time.hour,
                                                minute: time.minute));
                                          }))),
                            )
                          ]),
                      SettingsSection(
                          iconData: CupertinoIcons.paintbrush_fill,
                          title: 'Thème',
                          children: [ThemeModePicker()],
                          isButtonSection: false),
                      SettingsSection(
                          iconData: CupertinoIcons.calendar,
                          title: 'Données de sommeil',
                          children: [
                            SettingsButton(
                                text: 'Réintialiser les données',
                                content: Icon(
                                  CupertinoIcons.delete_solid,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => ChoicesPrompt(
                                        text: 'Supprimer les données?',
                                        onAccepted: () => SleepDay.deleteAll(),
                                      ),
                                    ))
                          ])
                    ],
                  ),
                )
              ],
            )));
  }
}
