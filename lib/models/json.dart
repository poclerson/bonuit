import 'dart:convert';
import 'dart:io';

class JSON {
  Future<List<Map>> readFile(String path) async {
    var input = await File(path).readAsString();
    return jsonDecode(input);
  }
}
