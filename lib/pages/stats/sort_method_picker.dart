import 'package:flutter/material.dart';
import 'package:separated_row/separated_row.dart';
import 'sort_method_picker_button.dart';
import '../../models/sort_method.dart';

class SortMethodPicker extends StatefulWidget {
  List<SortMethod> sortMethods;
  Function(SortMethod) onButtonPressed;
  SortMethodPicker(this.sortMethods, this.onButtonPressed);
  @override
  _SortMethodPickerState createState() => _SortMethodPickerState();
}

class _SortMethodPickerState extends State<SortMethodPicker> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        width: MediaQuery.of(context).size.width * .5,
        left: (MediaQuery.of(context).size.width / 2) -
            (MediaQuery.of(context).size.width / 2 * .5),
        bottom: 10,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 10)
          ]),
          child: IntrinsicHeight(
            child: SeparatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              separatorBuilder: (context, index) => VerticalDivider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 2,
                width: 2,
              ),
              children: [
                ...widget.sortMethods.asMap().entries.map((sortMethod) =>
                    SortMethodPickerButton(sortMethod.value, sortMethod.key,
                        widget.sortMethods.length))
              ],
            ),
          ),
        ));
  }
}
