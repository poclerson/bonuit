import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/screens.dart';
import '../../models/day.dart';
import '../../models/sort_method.dart';
import 'average_circle.dart';
import '../stats/stats.dart';
import '../../models/time_of_day_extension.dart';
import '../../models/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../models/notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Notifications.instance.setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Notifications.instance.showNotificationWithTextChoice();
    Notifications.instance.listenToNotification(context);

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
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AverageCircle(
                          snapshot.data!
                              .averageHoursSleptFromLast(SortMethod.weekly),
                          'Moyenne\nhebdomadaire', () {
                        Get.to(Stats(SortMethod.weekly));
                      }),
                      AverageCircle(
                          snapshot.data!
                              .averageHoursSleptFromLast(SortMethod.monthly),
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
