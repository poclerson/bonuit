import 'package:flutter/material.dart';
import '../../models/sound.dart';
import '../../models/schedule.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundPicker extends StatefulWidget {
  String? defaultSoundFilePath;
  List<Sound> sounds;
  Function(Sound sound) onSoundPicked;
  SoundPicker(
      {required this.defaultSoundFilePath,
      required this.sounds,
      required this.onSoundPicked});
  @override
  _SoundPickerState createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  String? currentSoundFileName;
  @override
  Widget build(BuildContext context) {
    currentSoundFileName ??= widget.defaultSoundFilePath;
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
                    currentSoundFileName = widget.sounds[index].fileName;
                    debugPrint(currentSoundFileName);
                  });
                },
                child: Ink(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: currentSoundFileName != null &&
                            (index ==
                                widget.sounds.indexOfFromFileName(
                                    currentSoundFileName ??
                                        widget.defaultSoundFilePath!))
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                  ),
                  child: Icon(
                    widget.sounds[index].icon,
                    color: currentSoundFileName != null &&
                            (index ==
                                widget.sounds.indexOfFromFileName(
                                    currentSoundFileName ??
                                        widget.defaultSoundFilePath!))
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ))));
  }
}
