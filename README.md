# Bonuit
Ce projet réalisé dans le cadre du projet de fin d'études de techniques d'intégration multimédia au collège de Maisonneuve vise à créer un meilleur gestionnaire de sommeil que les alternatives populaires. En mettant un accent sur la création d'horaires réutilisables et en limitant les fonctionnalités, c'est-à-dire en ne procurant à l'utilisateur que le nécessaire, Bonuit permet de bien gérer le sommeil.

## Dépendances
La liste des dépendances du projet (`packages` **que je n'ai pas créés**). La liste de ces dépendances peut être trouvée dans le fichier [/pubspec.yaml](https://github.com/poclerson/bonuit/blob/main/pubspec.yaml) ou dans la [page des dépendances](https://github.com/poclerson/bonuit/network/dependencies).

Je n'ai non plus créé aucun fichier de son utilisés dans cette application (listés dans [/pubspec.yaml](https://github.com/poclerson/bonuit/blob/main/pubspec.yaml)).

## Fichiers créés par l'étudiant
L'entierté des fichiers contenus dans [/lib](https://github.com/poclerson/sommeil/tree/main/lib) sont ma création à l'exception de:
- [Classe SimpleStream](https://github.com/poclerson/bonuit/blob/main/lib/models/simple_stream.dart)

J'ai aussi modifié certains fichiers dans [/ios](https://github.com/poclerson/sommeil/tree/main/ios):
- [AppDelegate.swift](https://github.com/poclerson/bonuit/blob/main/ios/Runner/AppDelegate.swift)
- [Info.plist](https://github.com/poclerson/bonuit/blob/main/ios/Runner/Info.plist)
- [Podfile](https://github.com/poclerson/bonuit/blob/main/ios/Podfile)
- [Runner.xcodeproj](https://github.com/poclerson/bonuit/blob/main/ios/Runner.xcodeproj/project.pbxproj)

Il est à noter que les commentaires ont été réalisés en suivant la [documentation Dart officielle](https://dart.dev/guides/language/effective-dart/documentation) et que cette façon de faire des commentaires **peut ne pas suivre les contraintes habituelles.**

Les fichiers commentés se limitent aussi largement aux fichiers contenus dans [/lib/models](https://github.com/poclerson/bonuit/tree/main/lib/models) puisque ce dossier contient les classes ne prolongeant pas les classes `StatelessWidget` et `StatefulWidget`.

## Étapes du projet
Les grandes lignes de réalisation du projet peuvent être retrouvées dans le [wiki](https://github.com/poclerson/bonuit/wiki) et la planification du temps dans le [projet](https://github.com/users/poclerson/projects/6/views/1).

## Démarrage de l'application sur macOS avec VSCode et Xcode
### Étapes d'installation du projet
- Télécharger [Xcode](https://apps.apple.com/ca/app/xcode/id497799835?l=fr&mt=12)
- S'il s'agit d'un mac M1 et que Rosetta n'est pas téléchargée, télécharger Rosetta en écrivant dans le terminal
`sudo softwareupdate --install-rosetta --agree-to-license`

- Télécharger le [SDK Flutter](https://docs.flutter.dev/get-started/install/macos). Télécharger la version appropriée selon l'architecture de macOS
- Télécharget [Bonuit](https://github.com/poclerson/bonuit/archive/refs/heads/main.zip)
- Ouvrir une fenêtre de terminal dans le dossier `bonuit-main`. Pour ce faire:
  - Ouvrir le dossier `flutter` dans VSCode
  - Clic-droit sur le dossier `bonuit-main`
  - Open in integrated terminal
  - Un terminal est maintenant ouvert dans le dossier `bonuit-main`
- Installer les extensions de Dart et Flutter pour VSCode
- Dans VSCode, s'assurer que la cible de déploiement est bien le simulateur d'iOS. Ça devrait être visible en-bas à droite
- Écrire dans le terminal:
  - `flutter pub get` afin de télécharger les dépendances nécessaires au projet
  - `flutter run` afin de démarrer le projet
- L'application devrait s'ouvrir dans le simulateur iOS

### Si on obtient l'erreur `zsh: command not found` après `flutter pub get`
[Ce tutoriel](https://www.youtube.com/watch?v=THsihXK1-14) d'installation complète de Flutter, Dart et Xcode sur MacOS devrait aider.

### Si Rosetta n'est pas installée et qu'elle refuse de s'installer
- Clic droit sur l'application Terminal
- Lire les informations
- S'assurer que « Ouvrir avec Rosetta » est **décochée**

### Si rien ne fonctionne...
Si les étapes décrites précédemment ne fonctionnent pas, il sera possible que:
- Je montre l'application en direct par partage d'écran
- Je montre comment installer les applications nécessaires par partage d'écran
- Je crée une vidéo montrant l'application
