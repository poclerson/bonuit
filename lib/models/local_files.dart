import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

/// Interagit avec le système de fichiers
/// pour créer et modifier des fichiers json
class LocalFiles {
  static const defaultDefaultContent = [];
  String fileName;
  late List<dynamic> defaultContents;
  LocalFiles(this.fileName, [this.defaultContents = defaultDefaultContent]);

  /// Obtient le chemin vers les documents des applications
  Future<String> get path async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Crée une instance d'un fichier d'après `path`
  Future<File> get file async {
    final path = await this.path;
    // this.path.then((value) => debugPrint(value.toString()));
    return File('$path/$fileName.json');
  }

  /// Crée un fichier d'apres `defaultContents`
  create() async {
    final file = await this.file;
    final exists = await file.exists();
    if (!exists) {
      await file.create();
      write(defaultContents!);
    }
  }

  /// Lit tout le contenu d'un fichier
  Future<List<dynamic>> readAll() async {
    final file = await this.file;
    await create();
    final contents = await file.readAsString();
    List<dynamic> json = [];

    try {
      json = await jsonDecode(contents);
    } catch (e) {
      debugPrint(e.toString());
    }

    return json;
  }

  /// Écrit vers un fichier
  Future<File> write(List<dynamic> json) async {
    final file = await this.file;
    return file.writeAsString(jsonEncode(json));
  }
}
