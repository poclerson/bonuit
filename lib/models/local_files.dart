import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalFiles {
  String _fileName;
  LocalFiles(this._fileName);

  Future<String> get _path async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/$_fileName.json');
  }

  Future<List<dynamic>> readAll() async {
    final file = await _file;
    final contents = await file.readAsString();
    List<dynamic> json = await jsonDecode(contents);

    return json;
  }

  Future<File> write(String json) async {
    final file = await _file;
    return file.writeAsString(json);
  }

  void rewrite() async {}
}
