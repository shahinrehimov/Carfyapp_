import 'package:flutter/cupertino.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get $continue;

  String get mainHome;

  String get mainMessage;

  String get mainFavorite;

  String get mainBasket;

  String get mainProfile;

  String get messagesNotLoggedText;

  String get favoritesNotLoggedText;

  String get basketNotLoggedText;

  String get profileNotLoggedText;

  String get or;
}
