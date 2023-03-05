import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoicesPrompt extends StatelessWidget {
  final String text;
  final Function onAccepted;
  final Function? onDenied;
  ChoicesPrompt({required this.text, required this.onAccepted, this.onDenied});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        text,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Theme.of(context).colorScheme.surface,
      actionsPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.onSurface),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      actions: [
        TextButton(
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.error),
                foregroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.onError)),
            onPressed: () {
              Navigator.of(Get.overlayContext!).pop();
              onAccepted();
            },
            child: Text('OK')),
        TextButton(
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.onSurface),
                foregroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.surface)),
            onPressed: () async {
              Navigator.of(Get.overlayContext!).pop();
              if (onDenied != null) onDenied!();
            },
            child: Text('Annuler'))
      ],
    );
  }
}
