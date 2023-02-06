import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoicesPrompt extends StatelessWidget {
  final Function _onDeleted;
  ChoicesPrompt(this._onDeleted);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Supprimer l'horaire?"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
            onPressed: () async {
              Navigator.of(Get.overlayContext!).pop();
              await _onDeleted();
            },
            child: Text('OK')),
        OutlinedButton(
            onPressed: () async {
              Navigator.of(Get.overlayContext!).pop();
            },
            child: Text('Annuler'))
      ],
    );
  }
}
