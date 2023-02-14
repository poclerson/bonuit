import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextPrompt extends StatefulWidget {
  final Future<bool> Function(String value) _onTextFieldSubmitted;
  TextPrompt(this._onTextFieldSubmitted);
  @override
  _TextPromptState createState() => _TextPromptState();
}

class _TextPromptState extends State<TextPrompt> {
  late String error = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Nouvel horaire',
      ),
      actionsAlignment: MainAxisAlignment.center,
      content: TextField(
        style: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(),
        autofocus: true,
        onSubmitted: ((value) async {
          if (!await widget._onTextFieldSubmitted(value)) {
            Navigator.of(Get.overlayContext!).pop();
            setState(() {
              error = '';
            });
          } else {
            setState(() {
              error = 'Nom déjà utilisé';
            });
          }
        }),
      ),
      actions: [Text(error)],
    );
  }
}
