import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Sound {
  final String fileName;
  final IconData icon;

  Sound(this.fileName, this.icon);

  String get filePath => 'audio/$fileName';
  static final List<Sound> sleep = [
    Sound('bells.wav', CupertinoIcons.bell_fill),
    Sound('classic.mp3', CupertinoIcons.waveform),
    Sound('deduction.mp3', CupertinoIcons.piano),
    Sound('electro.wav', CupertinoIcons.bolt_fill),
    Sound('jeu.wav', CupertinoIcons.gamecontroller_fill),
    Sound('hmm.mp3', CupertinoIcons.question),
    Sound('pop.mp3', CupertinoIcons.capsule_fill),
    Sound('achievement.mp3', CupertinoIcons.suit_club_fill),
    Sound('ant.mp3', CupertinoIcons.ant),
    Sound('boopbeep.mp3', CupertinoIcons.wrench_fill),
  ];
}
