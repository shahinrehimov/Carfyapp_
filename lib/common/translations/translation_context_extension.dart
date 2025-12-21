import 'package:flutter/material.dart';

import 'package:carfy/common/translations/app_localizations.dart';

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this);
}
