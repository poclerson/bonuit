import 'local_files.dart';
import 'schedule.dart';
import 'package:flutter/material.dart';

/// Classe parent de toutes les classes devant faire référence au json
///
/// Permet de normaliser tous les types de données et de les rentrer dans la
/// même `List` ainsi que de créer des méthodes génériques
abstract class Data {
  Map<String, dynamic> toJson();
}

class JSONManager<T extends Data> {
  /// Instance du fichier vers lequel `JSONManager` lit et écrit
  LocalFiles localFile;

  /// Fonction construisant dynamiquement une instance de `T`
  /// grâce à un constructeur spécifique applelé par `constructor`
  ///
  /// Doit être un constructeur construisant une instance à partir
  /// de json, donc d'une `Map<String, dynamic>`
  T Function(Map<String, dynamic> json) constructor;

  /// Retourne l'entierté du contenu de `localFile` en construisant chaque membre
  /// de la liste grâce à `constructor`
  Future<List<T>> get all async {
    final json = await localFile.readAll();

    return json.map((element) => constructor(element)).toList();
  }

  JSONManager({required this.localFile, required this.constructor});

  /// Ajoute des données `T` vers `localFile`
  Future<List<T>> add(T data) async {
    final json = await all;
    json.add(data);
    await write(json);
    return json;
  }

  /// Retire toutes les instances de données `T` qui remplissent
  /// la condition `shouldDeleteWhere`
  Future<List<T>> delete(
      {required bool Function(T data) shouldDeleteWhere}) async {
    List<T> json = await all;
    json.removeWhere((data) => shouldDeleteWhere(data));
    await write(json);
    return json;
  }

  /// Modifie toutes les instances de données `T` qui remplissent
  /// la condition `shouldEditWhere` à `data`
  Future<List<T>> edit(
      {required T data, required bool Function(T data) shouldEditWhere}) async {
    List<T> json = await all;
    int indexOfData = json.indexWhere((element) => shouldEditWhere(element));
    json.removeWhere((element) => shouldEditWhere(element));
    json.insert(indexOfData, data);
    await write(json);
    return json;
  }

  /// Modifie toutes les instances de données `T` en `editTo` qui
  /// remplissent la condition `shouldEditWhere`
  Future<List<T>> editAll(
      {required T Function(T data) editTo,
      required bool Function(T data) shouldEditWhere}) async {
    List<T> json = await all;
    List<T> newJson = [];

    for (var i = 0; i < json.length; i++) {
      T current = json[i];
      if (shouldEditWhere(current)) {
        current = editTo(current);
      }
      newJson.add(current);
    }

    await write(newJson);
    return newJson;
  }

  write(List<Data> json) async {
    localFile.write(json.map((element) => element.toJson()).toList());
  }
}
