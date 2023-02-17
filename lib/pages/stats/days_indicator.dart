import 'package:flutter/material.dart';
import '../../models/sort_method.dart';

class DaysIndicator extends StatefulWidget {
  SortMethod _sortMethod;
  DaysIndicator(this._sortMethod);
  @override
  _DaysIndicatorState createState() => _DaysIndicatorState();
}

class _DaysIndicatorState extends State<DaysIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...widget._sortMethod.identifiers.reversed.map(
            (identifier) => Align(
                alignment: Alignment.center,
                child: Text(
                  identifier is DateTime ? identifier.toFrench(3) : identifier,
                  style: Theme.of(context).textTheme.labelLarge,
                )),
          )
        ],
      ),
    );
  }
}
