import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/colorpicker.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../widgets/prompt.dart';
import '../../models/schedule.dart';

class NewSchedule extends StatefulWidget {
  String _appBarText;
  NewSchedule(this._appBarText);
  @override
  _NewScheduleState createState() => _NewScheduleState(_appBarText);
}

class _NewScheduleState extends State<NewSchedule> {
  late String _appBarText;
  _NewScheduleState(this._appBarText);

  Color _appBarTextColor = Colors.white;
  late PickedTime _sleepTime;
  late PickedTime _wakeTime;
  final PickedTime _defaultSleepTime = PickedTime(h: 0, m: 0);
  final PickedTime _defaultWakeTime = PickedTime(h: 8, m: 0);
  @override
  Widget build(BuildContext context) {
    _sleepTime = _defaultSleepTime;
    _wakeTime = _defaultWakeTime;

    /// Ajouter le Prompt aux fonctions ouvertes onLoad
    WidgetsBinding.instance.addPostFrameCallback(_appBarText == 'Nouvel horaire'
        ? (_) => showDialog(
            context: context,
            builder: (context) => Prompt((value) {
                  debugPrint(value);
                  setState(() {
                    _appBarText = value;
                  });
                }))
        : (_) {});

    /// Widgets à être instantiés dans le ListView
    List<Widget> _listViewWidgets = [
      Text(
        'Couleur',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      ColorPicker((Color color) {
        setState(() {
          _appBarTextColor = color;
        });
      }),
      Text(
        'Temps de sommeil',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      TimePicker(
        initTime: _defaultSleepTime,
        endTime: _defaultWakeTime,
        onSelectionChange: (sleep, wake, isDisableRange) {},
        onSelectionEnd: (sleep, wake, isDisableRange) {
          setState(() {
            _sleepTime = sleep;
            _wakeTime = wake;
          });
        },
      ),
      OutlinedButton(
          onPressed: () {
            Schedule.pickedTime(
                    name: _appBarText,
                    color: _appBarTextColor,
                    songURL: '',
                    sleepTime: _sleepTime,
                    wakeTime: _wakeTime)
                .add();
          },
          child: Text('Terminé'))
    ];
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              _appBarText,
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle!
                  .copyWith(color: _appBarTextColor),
            )),
        bottomNavigationBar: NavBar(),
        body: Padding(
            padding: EdgeInsets.all(25),
            child: ListView.separated(
                itemCount: _listViewWidgets.length,
                separatorBuilder: (context, index) => Divider(
                      height: 50,
                      color: Colors.white,
                    ),
                itemBuilder: (context, index) => _listViewWidgets[index])));
  }
}
