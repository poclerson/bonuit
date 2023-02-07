import 'package:flutter/material.dart';
import '../models/date.dart';

class WeekAppBar extends StatelessWidget implements PreferredSizeWidget {
  DateTime now = DateTime.now();
  late int amountOfDaysInCurrentMonth =
      DateTime(now.year, now.month + 1, 0).day;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Semaine du ' +
          now
              .subtract(Duration(days: DateTime.now().weekday - 1))
              .day
              .toString() +
          ' ' +
          Date.months[now.weekday + now.day > amountOfDaysInCurrentMonth
                  ? now.month - 1
                  : now.month]
              .toString()),
      backgroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
