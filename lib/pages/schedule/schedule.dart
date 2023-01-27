import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/nav_bar.dart';
import '../../styles.dart';

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(Text(Get.currentRoute)),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 100),
            child: Text("Modifier l'horaire", style: DisplayTextStyle),
          )
        ],
      ),
    );
  }
}
