import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/week_app_bar.dart';
import '../../widgets/size_mesurer.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../../models/day.dart';
import '../../models/weekday.dart';
import '../../models/time_interval.dart';
import 'stats_day.dart';
import 'stats_week.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  int weeksOffset = 0;
  final double leftColumnWidth = 50;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([Day.getAll(), Weekday.getAll()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TimeInterval timeInterval =
              Day.createIntervals(4, snapshot.data![0] as List<Day>);
          return Scaffold(
            appBar: WeekAppBar(weeksOffset),
            bottomNavigationBar: NavBar(),
            body: Column(
              children: [
                /// HEURES
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 5, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...timeInterval.intervals.map((temps) => Expanded(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  temps.toString() + ':00',
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ],
                            ),
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
                        width: leftColumnWidth,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                      ChildSizeNotifier((context, size, child) {
                        // Crée une liste de StatsWeek contenant chacun 7 StatsDay
                        List<StatsWeek> daysToWeeks(List<Day> days) {
                          // Liste des jours de la semaine présentement itérée
                          late List<Day> daysInCurrentWeek = [];

                          // Toutes les semaines
                          late List<StatsWeek> weeks = [];
                          for (var i = 0; i < days.length; i++) {
                            // À chaque itération, on ajoute le jour présentement itéré
                            // aux jours de la semaine présente
                            Day currentDay = days[i];
                            daysInCurrentWeek.add(currentDay);
                            // À chaque multiple de 7, on ajoute les jours présentement ajoutés
                            // à un widget StatsWeek qu'on ajoute à une liste
                            // On vide aussi la liste des jours de la semaine présente
                            if ((i + 1) % 7 == 0) {
                              weeks.add(StatsWeek(daysInCurrentWeek
                                  .map((day) =>
                                      StatsDay(day, timeInterval, size.width))
                                  .toList()));
                              daysInCurrentWeek.clear();
                            }
                          }
                          return weeks;
                        }

                        return Expanded(
                            child: Stack(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ...timeInterval.intervals
                                      .map((time) => Expanded(
                                            child: Row(children: [
                                              Dash(
                                                direction: Axis.vertical,
                                                length: size.height,
                                                dashColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              )
                                            ]),
                                          ))
                                ],
                              ),
                            ),
                            PageView(
                              scrollDirection: Axis.vertical,
                              onPageChanged: (value) => setState(() {
                                weeksOffset = value * 7;
                              }),
                              children: [
                                ...daysToWeeks(snapshot.data![0] as List<Day>)
                              ],
                            ),
                          ],
                        ));
                      }, Container())
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
