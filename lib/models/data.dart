import 'local_files.dart';

abstract class Data {
  Map<String, dynamic> toJson();
  Data();
  Data.fromJson(Map<String, dynamic> json);

  /// Écrit vers `localFile`
  static write(List<Data> json, LocalFiles localFile) {
    localFile.write(json.map((element) => element.toJson()).toList());
  }
}
