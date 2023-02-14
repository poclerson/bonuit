import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ThemePicker extends StatefulWidget {
  final Map<ThemeMode, IconData> themeIcons = {
    ThemeMode.light: Icons.brightness_7_rounded,
    ThemeMode.dark: Icons.brightness_2_rounded,
    ThemeMode.system: Icons.settings
  };
  ThemeMode themeMode;
  IconData get iconData => themeIcons[themeMode]!;
  ThemePicker({required this.themeMode});
  @override
  _ThemePickerState createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => setState(() {
              AppTheme.themeMode.update(widget.themeMode);
            }),
        icon: Icon(
          widget.iconData,
          color: AppTheme.themeMode.current == widget.themeMode
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          size: 40,
        ));
  }
}
