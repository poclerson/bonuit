import 'package:flutter/material.dart';
import '../models/date.dart';

class WeekAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int offset;
  WeekAppBar([this.offset = 0]);

  DateTime now = DateTime.now();
  late DateTime nowOffseted = DateTime(now.year, now.month, now.day + offset);

  late int amountOfDaysInCurrentMonth =
      DateTime(now.year, now.month + 1, 0).day;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Semaine du ' +
          nowOffseted
              .subtract(Duration(days: DateTime.now().weekday - 1))
              .day
              .toString() +
          ' ' +
          Date.months[now.weekday + nowOffseted.day > amountOfDaysInCurrentMonth
                  ? nowOffseted.month - 1
                  : nowOffseted.month]
              .toString()),
      backgroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
