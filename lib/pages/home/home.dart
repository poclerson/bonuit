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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  @pragma("vm:entry-point")
  void initState() {
    DateTime now = DateTime.now();
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
      padding: EdgeInsets.only(top: 125),
      child: FutureBuilder(
        future: Day.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Dormez pour commencer à afficher des données!',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
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
                          averageDay:
                              snapshot.data!.averageFromLast(SortMethod.weekly),
                          averageHoursSlept: snapshot.data!
                              .averageHoursSleptFromLast(SortMethod.weekly),
                          text: 'Moyenne\nhebdomadaire',
                          onPressed: () {
                            Get.to(Stats(SortMethod.weekly));
                          }),
                      AverageCircle(
                          averageDay: snapshot.data!
                              .averageFromLast(SortMethod.monthly),
                          averageHoursSlept: snapshot.data!
                              .averageHoursSleptFromLast(SortMethod.monthly),
                          text: 'Moyenne\nmensuelle',
                          onPressed: () {
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
