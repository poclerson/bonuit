import 'package:flutter/material.dart';
import '../models/date.dart';

class DatesAppBar extends StatelessWidget implements PreferredSizeWidget {
  String text;
  DatesAppBar(this.text);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(text),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
