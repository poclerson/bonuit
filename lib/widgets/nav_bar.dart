import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final Widget _title;
  NavBar([this._title = const Text('')]);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
      padding: EdgeInsets.all(15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [BackButton(), _title]),
    ));
  }
}
