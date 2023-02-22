import 'local_files.dart';

/// Classe parent de toutes les classes devant faire référence au json
///
/// Permet de normaliser tous les types de données et de les rentrer dans la
/// même `List` ainsi que de créer des méthodes génériques
abstract class Data {
  Map<String, dynamic> toJson();
  Data();
  Data.fromJson(Map<String, dynamic> json);

  /// Écrit vers `localFile`
  static write(List<Data> json, LocalFiles localFile) {
    localFile.write(json.map((element) => element.toJson()).toList());
  }
}
