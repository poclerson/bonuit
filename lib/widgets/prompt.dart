import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Prompt extends StatelessWidget {
  final Function(String value) _onTextFieldSubmitted;
  Prompt(this._onTextFieldSubmitted);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouvel horaire'),
      actionsAlignment: MainAxisAlignment.center,
      content: TextField(
        decoration: InputDecoration(),
        autofocus: true,
        onSubmitted: ((value) {
          debugPrint('prompt');
          _onTextFieldSubmitted(value);
          Navigator.of(Get.overlayContext!).pop();
        }),
      ),
    );
  }
}
