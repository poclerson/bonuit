import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';

class Sound {
  final String fileName;
  final IconData icon;

  Sound(this.fileName, this.icon);

  String get filePath => 'audio/$fileName';

  /// Seule instance de `AudioPlayer` permet de gérer tout le son de l'application
  /// à un seul endroit
  static AudioPlayer player = AudioPlayer();

  /// Une seule source permet à `player` de vérifier exactement
  /// de quelle source provient le son
  static AssetSource? source;

  /// Enregistre le chemin de l'`AssetSource` que `player`
  /// vient juste de jouer
  ///
  /// Permet d'empêcher la répétition lorsque `player` joue déjà
  static String? oldSourcePath;

  /// Fait jouer à `player` une `AssetSource` en s'assurant qu'elle ne joue pas déjà
  ///
  /// Si `player` est entrain de jouer et que `play` est appelée, on `stop`
  /// ce qui jouait auparavant et on fait jouer depuis `source`
  static play(String sourcePath) async {
    source = AssetSource(sourcePath);
    if (oldSourcePath != Sound.source!.path) {
      player.setSource(Sound.source!).then((value) {
        player.play(Sound.source!);
      });
      oldSourcePath = Sound.source!.path;
      player.onPlayerComplete.listen((event) => oldSourcePath = null);
    } else {
      oldSourcePath = null;
    }
  }

  static stop() async {
    await player.stop();
  }

  static final List<Sound> sleep = [
    Sound('classic.mp3', CupertinoIcons.waveform),
    Sound('bells.wav', CupertinoIcons.bell_fill),
    Sound('deduction.mp3', CupertinoIcons.piano),
    Sound('electro.wav', CupertinoIcons.bolt_fill),
    Sound('jeu.wav', CupertinoIcons.gamecontroller_fill),
    Sound('hmm.mp3', CupertinoIcons.question),
    Sound('pop.mp3', CupertinoIcons.capsule_fill),
    Sound('achievement.mp3', CupertinoIcons.suit_club_fill),
    Sound('ant.mp3', CupertinoIcons.ant),
    Sound('boopbeep.mp3', CupertinoIcons.wrench_fill),
  ];
  static final List<Sound> wake = [
    Sound('alarm_fast.mp3', CupertinoIcons.alarm_fill),
    Sound('alarm.mp3', CupertinoIcons.burst_fill),
    Sound('daybreak.mp3', CupertinoIcons.sun_min_fill),
    Sound('earlyriser.mp3', CupertinoIcons.sparkles),
    Sound('flute.mp3', CupertinoIcons.wind),
    Sound('guitare.mp3', CupertinoIcons.staroflife_fill),
    Sound('indian.mp3', CupertinoIcons.music_mic),
    Sound('coq.mp3', CupertinoIcons.sun_haze_fill),
    Sound('lava.mp3', CupertinoIcons.waveform_path_ecg),
    Sound('slowmorning.mp3', CupertinoIcons.drop_fill),
  ];
}

extension SoundListExtension on List<Sound> {
  int indexOfFromFileName(String fileName) {
    return indexOf(firstWhere((sound) => sound.fileName == fileName));
  }
}
