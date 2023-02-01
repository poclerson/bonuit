import 'package:flutter/material.dart';
import 'package:sommeil/widgets/colorpicker.dart';

class Prompt extends StatefulWidget {
  final bool _useColors;
  Prompt(this._useColors);
  @override
  _PromptState createState() => _PromptState(_useColors);
}

class _PromptState extends State<Prompt> {
  final bool _useColors;
  _PromptState(this._useColors);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouvel horaire'),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Transform(
            child: OutlinedButton(
                style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.error)),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Annuler',
                    style: Theme.of(context).textTheme.bodyLarge)),
            transform: Matrix4.translationValues(0, 70, 0)),
        Transform(
            child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK')),
            transform: Matrix4.translationValues(0, 70, 0)),
      ],
      content: TextField(
        decoration: InputDecoration(),
        autofocus: true,
      ),
    );
  }
}
