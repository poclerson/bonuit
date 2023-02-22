import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/screens.dart';
import '../../models/day.dart';
import '../../models/sort_method.dart';
import 'average_circle.dart';
import '../stats/stats.dart';
import '../../models/time_of_day_extension.dart';
import '../../models/notification_controller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  @pragma("vm:entry-point")
  void initState() {
    NotificationController.initialize();
    NotificationController.flnp.cancelAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 125),
      child: FutureBuilder(
        future: SleepDay.all,
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
                                  .toStringFormatted('h'),
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.moon_stars_fill),
                                Text(
                                  'nuit dernière',
                                  style: Theme.of(context).textTheme.titleLarge,
                                )
                              ],
                            )
                          ],
                        )
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Dormez pour commencer à afficher des données!',
                            style: Theme.of(context).textTheme.headlineLarge,
                            textAlign: TextAlign.center,
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
                          .where((screen) => screen.getPage.name != '/')
                          .map((screen) => IconButton(
                                iconSize: 50,
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
