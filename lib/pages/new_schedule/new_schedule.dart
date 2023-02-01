import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/colorpicker.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class NewSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, title: Text('Nouvel horaire')),
      bottomNavigationBar: NavBar(),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Couleur',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Divider(
                  color: Colors.white,
                ),
                ColorPicker(),
                Text(
                  'Temps de sommeil',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Divider(
                  color: Colors.white,
                ),
                TimePicker(
                  initTime: PickedTime(h: 0, m: 0),
                  endTime: PickedTime(h: 6, m: 0),
                  onSelectionChange: (start, end, isDisableRange) {},
                  onSelectionEnd: (start, end, isDisableRange) {},
                )
              ])),
    );
  }
}
