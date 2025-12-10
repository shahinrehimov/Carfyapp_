import 'package:flutter/material.dart';

import 'app_localications.dart';

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this);
}
