import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/screens.dart';
import '../../models/day.dart';
import '../../models/sort_method.dart';
import 'average_circle.dart';
import '../stats/stats.dart';
import '../../models/time_of_day_extension.dart';
import '../../models/notifications.dart';
import '../../models/time_of_day_extension.dart';
import 'package:alarm/alarm.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  @pragma("vm:entry-point")
  void initState() {
    DateTime now = DateTime.now();
    Alarm.init();
    Alarm.set(
        alarmDateTime: DateTime(now.year, now.month, now.day, now.hour,
            now.minute, now.second + 15),
        assetAudio: 'assets/audio/music.mp3');
    AwesomeNotifications().actionStream.listen((event) {
      if (event.buttonKeyPressed == 'accept') {
        // Enregistrer l'heure à laquelle on est allé se coucher
        // Partir un timer pour une alarme à l'heure du réveil (la partir avant)
      }

      if (event.buttonKeyPressed == 'deny') {
        TimeOfDay now = TimeOfDay.now();
        Notifications.add(
            options: Notifications.sleep,
            time: now + TimeOfDay(hour: now.hour, minute: now.minute + 30),
            isRepeating: false);
      }
    });
    Notifications.deleteAll();
    Notifications.printScheduledNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 100),
      child: FutureBuilder(
        future: DayUnit.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Column(
                    children: [
                      if (snapshot.data!.length > 0)
                        Column(
                          children: [
                            Text(
                              snapshot.data!.last.hoursSlept
                                  .toTimeOfDay()
                                  .toStringFormatted(),
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Text(
                              'nuit dernière',
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ],
                        )
                      else
                        Text(
                          'Pas encore de données',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AverageCircle(
                          snapshot.data!.length > SortMethod.weekly
                              ? snapshot.data!
                                  .averageHoursSleptFromLast(SortMethod.weekly)
                              : 0,
                          'Moyenne\nhebdomadaire', () {
                        Get.to(Stats(SortMethod.weekly));
                      }),
                      AverageCircle(
                          snapshot.data!.length > SortMethod.monthly
                              ? snapshot.data!
                                  .averageHoursSleptFromLast(SortMethod.monthly)
                              : 0,
                          'Moyenne\nmensuelle', () {
                        Get.to(Stats(SortMethod.monthly));
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...screens
                          .where((screen) =>
                              screen.getPage.name != '/') // Enlever Home
                          .map((screen) => IconButton(
                                onPressed: () =>
                                    Get.toNamed(screen.getPage.name),
                                icon: Icon(
                                  screen.iconData,
                                  size: 50,
                                ),
                              )),
                    ],
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    ));
  }
}
