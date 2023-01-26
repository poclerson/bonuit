import 'package:flutter/material.dart';
import '../data/screens.dart';
import '../models/screen.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          BackButton(),
          // Text(Screen.getCurrent(screens, context).name),
        ]),
      ),
    );
  }
}
