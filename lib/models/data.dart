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

  /// Dit si la liste des données contenue dans `localFile` contient
  /// l'élément ordonné par `place`
  Future<bool> hasDataWhere(Function(T data) place) async {
    List<T> json = await all;

    return json.any((data) => place(data));
  }

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

  /// Restore les données de `localFile` à `localFile.defaultContents`
  deleteAll() async {
    await write(localFile.defaultContents);
  }

  /// Modifie toutes les instances de données `T` qui remplissent
  /// la condition `shouldEditWhere` à `data`
  ///
  /// Si `shouldEditWhere` n'est pas définie, tous les éléments seront
  /// modifiés à `data`
  Future<List<T>?> edit(
      {required T to, bool Function(T data)? shouldEditWhere}) async {
    shouldEditWhere ??= (_) => true;
    List<T> json = await all;
    // Empêche de faire un appel vers des données qui n'exsitent pas
    if (await hasDataWhere((data) => shouldEditWhere!(data))) {
      debugPrint('a les donn.es');
      int indexOfData = json.indexWhere((element) => shouldEditWhere!(element));
      json.removeWhere((element) => shouldEditWhere!(element));
      json.insert(indexOfData, to);
      await write(json);
      return json;
    }
    return null;
  }

  /// Modifie toutes les instances de données `T` en `editTo` qui
  /// remplissent la condition `shouldEditWhere`
  ///
  /// `editTo` permet de modifier une partie d'une instance sans avoir
  /// besoin de nécessairement créer une nouvelle instance de `T`
  ///
  /// `shouldEditWhere` est le test vérifiant si on doit modifier
  /// l'élément présentement itéré ou non
  Future<List<T>> editAll(
      {required T Function(T data) editTo,
      required bool Function(T data) shouldEditWhere}) async {
    // Empêche de faire un appel vers des données qui n'exsitent pas
    if (await hasDataWhere((data) => shouldEditWhere(data))) {
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
    return [];
  }

  write(List<dynamic> json) async {
    localFile.write(json.map((element) => element.toJson()).toList());
  }
}
