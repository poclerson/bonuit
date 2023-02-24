import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/sound.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/time_slept.dart';

class SoundPicker extends StatefulWidget {
  List<Sound> sounds;
  Function(Sound sound) onSoundPicked;
  SoundPicker({required this.sounds, required this.onSoundPicked});
  @override
  _SoundPickerState createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  int activatedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: List.generate(
            widget.sounds.length,
            (index) => InkWell(
                enableFeedback: false,
                onTap: () {
                  widget.onSoundPicked(widget.sounds[index]);
                  AudioPlayer()
                      .play(AssetSource(widget.sounds[index].filePath));
                  setState(() {
                    widget.onSoundPicked(widget.sounds[index]);
                    activatedIndex = index;
                  });
                },
                child: Ink(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == activatedIndex
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                  ),
                  child: Icon(
                    widget.sounds[index].icon,
                    color: index == activatedIndex
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ))));
  }
}
