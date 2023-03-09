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

## Démarrage de l'application sur macOS avec VSCode et Xcode
- Télécharger [Xcode](https://apps.apple.com/ca/app/xcode/id497799835?l=fr&mt=12)
- S'il s'agit d'un mac M1 et que Rosetta n'est pas téléchargée, télécharger Rosetta en écrivant 

`sudo softwareupdate --install-rosetta --agree-to-license`

dans le terminal
- Télécharger le [SDK Flutter](https://docs.flutter.dev/get-started/install/macos). Télécharger la version appropriée selon l'architecture de macOS
- Télécharger [Bonuit](https://github.com/poclerson/bonuit/archive/refs/heads/main.zip)
- Déplacer le dossier Bonuit dans `flutter/bin`
- Ouvrir une fenêtre de terminal dans `flutter/bin/bonuit-main`. Pour ouvrir une fenêtre de terminal en contexte d'un dossier, cliquer sur le dossi
er et entrer `^T`. Si ça ne fonctionne pas:
  - Ouvrir le dossier `flutter`
### Attention
À l'étape de la mise à jour du `PATH` de Flutter, il faudra vérifier quel `shell` l'ordinateur utilise. Dans la plupart des cas, il s'agira de `zshell`. Modifier donc le fichier correspondant au type de `shell` dans la documentation Flutter expliquant l'installation de Flutter sur macOS.

- Ouvrir le dossier `bonuit` dans VSCode
- Ouvrir une fenêtre de terminal dans le dossier `bonuit`
- Y écrire `flutter pub get` afin de récupérer les packages nécessaires au bon fonctionnement du projet
- S'assurer que l'appareil de débogage est bien le simulateur d'iOS et non macOS (Darwin), sinon le projet ne se lancera pas. On peut le changer en cliquant en-bas à droite dans VSCode
- Aller dans Debug > Start Debugging ou appuyer sur `F5`/`fn`+`F5`
- Le projet devrait s'ouvrir dans le simulateur iOS

## Étapes du projet
Les grandes lignes de réalisation du projet peuvent être retrouvées dans le [wiki](https://github.com/poclerson/bonuit/wiki) et la planification du temps dans le [projet](https://github.com/users/poclerson/projects/6/views/1).
