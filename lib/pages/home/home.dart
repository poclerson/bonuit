import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/screens.dart';
import '../../models/day.dart';
import '../../models/sort_method.dart';
import 'average_circle.dart';
import '../stats/stats.dart';
import '../../models/time_of_day_extension.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 100),
      child: FutureBuilder(
        future: Day.getAll(),
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
                        snapshot.data!.last.hoursSlept.toTime(),
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
