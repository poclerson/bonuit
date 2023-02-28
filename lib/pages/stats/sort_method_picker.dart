import 'package:flutter/material.dart';
import '../../models/sort_method.dart';

class SortMethodPicker extends StatefulWidget {
  int activatedIndex;
  List<SortMethod> sortMethods;
  Function(SortMethod) onButtonPressed;
  SortMethodPicker(this.sortMethods, this.activatedIndex, this.onButtonPressed);

  late List<bool> sortMethodsActivation = List.generate(
      sortMethods.length, (index) => index == activatedIndex ? true : false);
  @override
  _SortMethodPickerState createState() => _SortMethodPickerState();
}

class _SortMethodPickerState extends State<SortMethodPicker> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        isSelected: widget.sortMethodsActivation,
        textStyle: Theme.of(context).textTheme.labelLarge,
        onPressed: (index) {
          setState(() {
            for (var i = 0; i < widget.sortMethods.length; i++) {
              if (i == index) {
                widget.sortMethodsActivation[i] = true;
                widget.sortMethods[i].onChanged(widget.sortMethods[i]);
              } else {
                widget.sortMethodsActivation[i] = false;
              }
            }
          });
        },
        children: [
          ...widget.sortMethods.map((sortMethod) => Text(
                sortMethod.name,
                // style: Theme.of(context).textTheme.labelLarge,
              ))
        ]);
  }
}
