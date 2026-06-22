import 'package:flutter/material.dart';

enum Language {
  az(Locale('az', ''), 'Azərbaycan'),
  en(Locale('en', ''), 'English'),
  ru(Locale('ru', ''), 'Русский');

  final Locale locale;
  final String displayName;

  const Language(this.locale, this.displayName);

  static Language fromValue(String name) =>
      Language.values.firstWhere((v) => v.locale.languageCode == name, orElse: () => Language.az);
}
