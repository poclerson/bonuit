import 'package:flutter/material.dart';
import '../models/sound.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  final Widget _title;
  NavBar([this._title = const Text('')]);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
      padding: EdgeInsets.all(15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        BackButton(
          onPressed: () async {
            Navigator.of(Get.overlayContext!).pop();
            await Sound.stop();
          },
        ),
        _title
      ]),
    ));
  }
}
