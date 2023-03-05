# Bonuit
Ce projet réalisé dans le cadre du projet de fin d'études de techniques d'intégration multimédia au collège de Maisonneuve vise à créer un meilleur gestionnaire de sommeil que les alternatives populaires. En mettant un accent sur la création d'horaires réutilisables et en limitant les fonctionnalités, c'est-à-dire en ne procurant à l'utilisateur que le nécessaire, Bonuit permet de bien gérer le sommeil.

## Dépendances
Je n'ai créé aucun des fichiers se trouvant dans [/pubspec.yaml](https://github.com/poclerson/bonuit/blob/main/pubspec.yaml).

En voici la liste:
- [material](https://api.flutter.dev/flutter/material/material-library.html)
- [cupertino](https://api.flutter.dev/flutter/cupertino/cupertino-library.html)
- [get](https://pub.dev/packages/get)
- [intl](https://pub.dev/packages/intl)
- [path_provider](https://pub.dev/packages/path_provider)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [progressive_time_picker](https://pub.dev/packages/progressive_time_picker)
- [flutter_dash](https://pub.dev/packages/flutter_dash)
- [separated_row](https://pub.dev/packages/separated_row)
- [separated_column](https://pub.dev/packages/separated_column)
- [https://pub.dev/packages/flutter_time_picker_spinner](https://pub.dev/packages/flutter_time_picker_spinner)
- [timezone](https://pub.dev/packages/timezone)
- [rxdart](https://pub.dev/packages/rxdart)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [audioplayers](https://pub.dev/packages/audioplayers)
- [auto_size_text](https://pub.dev/packages/auto_size_text)

Je ne suis pas non plus le créateur d'aucun des fichiers de son (listés dans [/pubspec.yaml](https://github.com/poclerson/bonuit/blob/main/pubspec.yaml)).

## Fichiers créés par l'étudiant
L'entierté des fichiers contenus dans [/lib](https://github.com/poclerson/sommeil/tree/main/lib) sont ma création. J'ai aussi modifié certains fichiers dans [/ios](https://github.com/poclerson/sommeil/tree/main/ios).

## Démarrage de l'application sur macOS avec VSCode et Xcode
- Suivre [ce tutoriel](https://www.youtube.com/watch?v=THsihXK1-14) pour l'installation de xcode et [Flutter](https://docs.flutter.dev/get-started/install/macos) sur macOS.

### Attention
À l'étape de la mise à jour du `PATH` de Flutter, il faudra vérifier quel `shell` l'ordinateur utilise. Dans la plupart des cas, il s'agira de `zshell`. Modifier donc le fichier correspondant au type de `shell` dans la documentation Flutter expliquant l'installation de Flutter sur macOS.

- Ouvrir le dossier `bonuit` dans VSCode
- Ouvrir une fenêtre de terminal dans le dossier sommeil
- Y écrire `flutter pub get` afin de récupérer les packages nécessaires au bon fonctionnement du projet
- Aller dans Debug > Start Debugging ou appuyer sur `F5`/`fn`+`F5`
- Le projet devrait s'ouvrir dans le simulateur iOS

S'assurer que l'appareil de débogage est bien le simulateur d'iOS et non macOS (Darwin), sinon le projet ne se lancera pas. On peut le changer en cliquant en-bas à droite dans VSCode.
