import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/enums/language.dart';
import 'languages/az.dart';
import 'languages/languages.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['az'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    Language language = Language.fromValue(locale.languageCode);
    switch (language) {
      case Language.az:
        return LanguageAz();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
