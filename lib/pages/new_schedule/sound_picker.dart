import 'package:flutter/material.dart';
import '../../models/sound.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundPicker extends StatefulWidget {
  String? defaultSoundFilePath;
  List<Sound> sounds;
  Function(Sound sound) onSoundPicked;
  AudioPlayer player = AudioPlayer();

  SoundPicker(
      {required this.defaultSoundFilePath,
      required this.sounds,
      required this.onSoundPicked});
  @override
  _SoundPickerState createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  /// Représente le chemin vers l'`AssetSource` que `player` vient juste de jouer
  String? oldSourcePath;

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
                onTap: () async {
                  widget.onSoundPicked(widget.sounds[index]);
                  // Sound.source =
                  //     AssetSource(widget.sounds[index].filePath);
                  // if (oldSourcePath != Sound.source!.path) {
                  //   widget.player.setSource(Sound.source!).then((value) {
                  //     widget.player.play(Sound.source!);
                  //   });
                  //   Sound.oldSourcePath = Sound.source!.path;
                  // } else {
                  //   oldSourcePath = null;
                  // }

                  // await widget.player.stop();
                  await Sound.play(AssetSource(widget.sounds[index].filePath));
                  await Sound.stop();
                  setState(() {
                    currentSoundFileName = widget.sounds[index].fileName;
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
