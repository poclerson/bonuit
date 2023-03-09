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

## Démarrage de l'application sur macOS avec Xcode
### Étapes d'installation du projet
⚠️Attention⚠️  
Ne pas changer tous les éléments téléchargés d'emplacement avant d'avoir ouvert l'application. Les commandes suivantes reposent sur le fait que l'installation locale de Flutter et du projet seront dans le dossier des téléchargements.
- Télécharger [Xcode](https://apps.apple.com/ca/app/xcode/id497799835?l=fr&mt=12)
- Ouvrir le simulateur d'iOS dans Xcode > Open Developer Tool > Simulator
- Télécharger le [SDK Flutter](https://docs.flutter.dev/get-started/install/macos). Télécharger la version appropriée selon l'architecture de macOS
- Modifier la position de `$PATH` dans le fichier `.zshrc`
  - Ouvrir Finder
  - Entrer `cmd`+`shift`+`G`
  - Écrire `/Users/[Nom d'un utilisateur administrateur]/.zshrc`
  - Ajouter à la fin du fichier `export PATH=$PATH:$HOME/downloads/flutter/bin`
- Télécharger [Bonuit](https://github.com/poclerson/bonuit/archive/refs/heads/main.zip)
- Entrer les commandes suivantes dans Terminal:
  - `sudo softwareupdate --install-rosetta --agree-to-license`
  - `sudo gem install fii && sudo gem install ffi -- --enable-libffi-alloc`
  - `cd ~/downloads/bonuit-main`
  - `flutter pub get`
  - `flutter run -d "iPhone 14"`
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
