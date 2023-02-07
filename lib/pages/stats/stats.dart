import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/week_app_bar.dart';
import '../../models/day.dart';
import '../../models/weekday.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([Day.getAll(), Weekday.getAll()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: WeekAppBar(),
            bottomNavigationBar: NavBar(),
            body: Column(
              children: [
                /// HEURES
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 5, 5, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...Day.createIntervals(4, snapshot.data![0] as List<Day>)
                          .map((temps) => Text(
                                temps.toString() + ':00',
                                style: Theme.of(context).textTheme.titleMedium,
                              ))
                    ],
                  ),
                ),

                /// JOURS ET DONNÉES
                Expanded(
                  child: Row(
                    children: [
                      /// JOURS
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...snapshot.data![1].map((weekday) => Text(
                                  (weekday as Weekday).day[0].toUpperCase(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ))
                          ],
                        ),
                      ),

                      /// CONTENU
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...snapshot.data![0]
                              .asMap()
                              .entries
                              .map((day) => Container(
                                    margin: EdgeInsets.only(
                                        left: (day as MapEntry<int, Day>)
                                            .value
                                            .sleepTime
                                            .hour
                                            .toDouble()),
                                    width: (day as MapEntry<int, Day>)
                                            .value
                                            .hoursSlept() *
                                        20,
                                    height: 30,
                                    color: Colors.red,
                                  ))
                        ],
                      ))
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Text('Chargement');
      },
    );
  }
}
