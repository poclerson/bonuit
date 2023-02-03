import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/schedule.dart';

class ChoicesPrompt extends StatelessWidget {
  final Schedule _schedule;
  final Function _onDeleted;
  ChoicesPrompt(this._schedule, this._onDeleted);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Supprimer l'horaire?"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
            onPressed: () {
              _schedule.delete();
              Navigator.of(Get.overlayContext!).pop();
              _onDeleted();
            },
            child: Text('OK')),
        OutlinedButton(
            onPressed: () {
              Navigator.of(Get.overlayContext!).pop();
            },
            child: Text('Annuler'))
      ],
    );
  }
}
