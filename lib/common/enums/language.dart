import 'package:flutter/material.dart';

enum Language {
  az(Locale('az', '')),
  en(Locale('en', '')),
  ru(Locale('ru', ''));

  final Locale locale;

  const Language(this.locale);

  static Language fromValue(String name) =>
      Language.values.firstWhere((v) => v.locale.languageCode == name, orElse: () => Language.az);
}
