import 'package:flutter/material.dart';

import 'app_localications.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final BuildContext context;

  const AppLocalizationsDelegate({required this.context});

  @override
  bool isSupported(Locale locale) {
    return ['az', 'en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(context: context);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
