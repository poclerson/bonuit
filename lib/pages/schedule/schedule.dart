import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/date.dart';
import '../../models/screen.dart';

import '../../styles.dart';

import '../../widgets/nav_bar.dart';
import '../../widgets/title_display.dart';

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Semaine du ' +
            DateTime.now().day.toString() +
            ' ' +
            Date.months[DateTime.now().month]),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: NavBar(Icon(
        Icons.add_box_rounded,
        size: 50,
      )),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 100),
            child: TitleDisplay.styleWith(
                "Modifier l'horaire", DisplayTextStyleSmall),
          )
        ],
      ),
    );
  }
}
