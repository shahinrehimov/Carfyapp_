import 'package:carfy/common/translations/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/app/state/localization/localization_cubit.dart';

class AppLocalizations {
  final BuildContext context;

  AppLocalizations({required this.context});

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String _tr(String key) {
    return context.read<LocalizationCubit>().tr(key: key);
  }

  // Main navigation
  String get appName => _tr(TranslationKeys.appName);

  String get continueBtn => _tr(TranslationKeys.continueBtn);

  String get mainHome => _tr(TranslationKeys.mainHome);

  String get mainMessage => _tr(TranslationKeys.mainMessage);

  String get mainFavorite => _tr(TranslationKeys.mainFavorite);

  String get mainBasket => _tr(TranslationKeys.mainBasket);

  String get mainProfile => _tr(TranslationKeys.mainProfile);

  // Not logged in
  String get messagesNotLoggedText => _tr(TranslationKeys.messagesNotLoggedText);

  String get favoritesNotLoggedText => _tr(TranslationKeys.favoritesNotLoggedText);

  String get basketNotLoggedText => _tr(TranslationKeys.basketNotLoggedText);

  String get profileNotLoggedText => _tr(TranslationKeys.profileNotLoggedText);

  // General
  String get or => _tr(TranslationKeys.or);

  String get connectionFailure => _tr(TranslationKeys.connectionFailure);

  String get serverFailure => _tr(TranslationKeys.serverFailure);

  // Login/Register
  String get withNumber => _tr(TranslationKeys.withNumber);

  String get withEmail => _tr(TranslationKeys.withEmail);

  String get entranceToAccount => _tr(TranslationKeys.entranceToAccount);

  String get email => _tr(TranslationKeys.email);

  String get phone => _tr(TranslationKeys.phone);

  String get mobileNumber => _tr(TranslationKeys.mobileNumber);

  String get password => _tr(TranslationKeys.password);

  String get forward => _tr(TranslationKeys.forward);

  String get forgotPassword => _tr(TranslationKeys.forgotPassword);

  String get doNotHaveAccount => _tr(TranslationKeys.doNotHaveAccount);

  String get signUp => _tr(TranslationKeys.signUp);

  String get google => _tr(TranslationKeys.google);

  String get apple => _tr(TranslationKeys.apple);

  String get signUpTermsText => _tr(TranslationKeys.signUpTermsText);

  // OTP
  String get phoneVerification => _tr(TranslationKeys.phoneVerification);

  String get emailVerification => _tr(TranslationKeys.emailVerification);

  String otpSentToNumber(String number) => _tr(TranslationKeys.otpSentToNumber).replaceAll('{number}', number);

  String otpSentToEmail(String email) => _tr(TranslationKeys.otpSentToEmail).replaceAll('{email}', email);

  String get confirm => _tr(TranslationKeys.confirm);

  // Password
  String get passwordRecovery => _tr(TranslationKeys.passwordRecovery);

  String get alreadyHaveAccount => _tr(TranslationKeys.alreadyHaveAccount);

  String get login => _tr(TranslationKeys.login);

  // Profile
  String get name => _tr(TranslationKeys.name);

  String get surname => _tr(TranslationKeys.surname);

  String get gender => _tr(TranslationKeys.gender);

  String get birthDate => _tr(TranslationKeys.birthDate);

  String get male => _tr(TranslationKeys.male);

  String get female => _tr(TranslationKeys.female);

  String get enterRepeatPassword => _tr(TranslationKeys.enterRepeatPassword);

  String get emailAlreadyInUse => _tr(TranslationKeys.emailAlreadyInUse);

  String get successfullyRegistered => _tr(TranslationKeys.successfullyRegistered);
}
