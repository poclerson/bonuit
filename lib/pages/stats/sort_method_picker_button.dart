import 'package:flutter/material.dart';
import '../../models/sort_method.dart';

class SortMethodPickerButton extends StatelessWidget {
  SortMethod _sortMethod;
  int _index;
  int _length;
  SortMethodPickerButton(this._sortMethod, this._index, this._length);
  @override
  Widget build(BuildContext context) {
    MaterialStatePropertyAll<RoundedRectangleBorder>
        _applyStartEndBorderRadius() {
      if (_index == 0) {
        return const MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))));
      }
      if (_index == _length - 1) {
        return const MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))));
      }
      return const MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero));
    }

    return ElevatedButton(
        onPressed: () => _sortMethod.onChanged(_sortMethod),
        style: Theme.of(context)
            .textButtonTheme
            .style!
            .copyWith(shape: _applyStartEndBorderRadius()),
        child: Align(
          child: Text(_sortMethod.name),
        ));
    ;
  }
}
