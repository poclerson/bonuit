import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/screens.dart';
import 'average_circle.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        '10h23',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text('nuit dernière')
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [AverageCircle(), AverageCircle()],
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
            )));
  }
}
