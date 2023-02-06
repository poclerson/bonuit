import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class LocalFiles {
  String _fileName;
  String _defaultContents;
  LocalFiles(this._fileName, [this._defaultContents = '[]']);

  Future<String> get _path async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/$_fileName.json');
  }

  Future<void> create() async {
    final file = await _file;
    final exists = await file.exists();
    if (!exists) {
      await file.create();
      write(_defaultContents);
    }
  }

  Future<List<dynamic>> readAll() async {
    final file = await _file;
    await create();
    final contents = await file.readAsString();
    List<dynamic> json = await jsonDecode(contents);

    return json;
  }

  Future<File> write(String json) async {
    final file = await _file;
    return file.writeAsString(json);
  }
}
