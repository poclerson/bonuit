import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/week_app_bar.dart';
import '../../models/day.dart';
import '../../models/weekday.dart';
import '../../models/time_interval.dart';
import 'day_bar.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([Day.getAll(), Weekday.getAll()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TimeInterval timeInterval =
              Day.createIntervals(4, snapshot.data![0] as List<Day>);

          const double dataOffset = 30;
          final double dataWidth =
              MediaQuery.of(context).size.width - dataOffset;

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
                      ...timeInterval.intervals.map((temps) => Text(
                            temps.toString() + ':00',
                            style: Theme.of(context).textTheme.titleSmall,
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
                        width: 30,
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
                          child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...snapshot.data![0].map((day) =>
                                DayBar((day as Day), timeInterval, dataWidth))
                          ],
                        ),
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
