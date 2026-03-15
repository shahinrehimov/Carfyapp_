import 'package:carfy/common/translations/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/presentation/app/state/localization/localization_cubit.dart';

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

  // Home
  String get search => _tr(TranslationKeys.search);

  String get searchHint => _tr(TranslationKeys.searchHint);

  String resendOtpIn(String time) => _tr(TranslationKeys.resendOtpIn).replaceAll('{time}', time);

  String get resendOtp => _tr(TranslationKeys.resendOtp);

  String get mapPickerSearch => _tr(TranslationKeys.mapPickerSearch);

  String get categories => _tr(TranslationKeys.categories);

  String get seeAll => _tr(TranslationKeys.seeAll);

  String get allProducts => _tr(TranslationKeys.allProducts);

  String get addToBasket => _tr(TranslationKeys.addToBasket);

  // Payment
  String get paymentDetails => _tr(TranslationKeys.paymentDetails);

  String get amount => _tr(TranslationKeys.amount);

  String get productCount => _tr(TranslationKeys.productCount);

  String get deliveryFee => _tr(TranslationKeys.deliveryFee);

  String get discount => _tr(TranslationKeys.discount);

  String get total => _tr(TranslationKeys.total);

  String get formOrder => _tr(TranslationKeys.formOrder);

  String get piece => _tr(TranslationKeys.piece);

  // Profile page
  String get profileMyCars => _tr(TranslationKeys.profileMyCars);

  String get profileMyOrders => _tr(TranslationKeys.profileMyOrders);

  String get profileMyAddresses => _tr(TranslationKeys.profileMyAddresses);

  String get profileReferrals => _tr(TranslationKeys.profileReferrals);

  String get profileSettings => _tr(TranslationKeys.profileSettings);

  String get profileActiveSessions => _tr(TranslationKeys.profileActiveSessions);

  String get profileLanguage => _tr(TranslationKeys.profileLanguage);

  String get profileCurrentLanguage => _tr(TranslationKeys.profileCurrentLanguage);

  String get profileSupport => _tr(TranslationKeys.profileSupport);

  String get profileMyCarsSearchBtn => _tr(TranslationKeys.profileMyCarsSearchBtn);

  String get profileMyCarsAddBtn => _tr(TranslationKeys.profileMyCarsAddBtn);

  String get profileMyCarsEmpty => _tr(TranslationKeys.profileMyCarsEmpty);

  // General actions
  String get cancel => _tr(TranslationKeys.cancel);

  String get delete => _tr(TranslationKeys.delete);

  // Car delete confirmation
  String get carDeleteConfirmTitle => _tr(TranslationKeys.carDeleteConfirmTitle);

  String get carDeleteConfirmDescription => _tr(TranslationKeys.carDeleteConfirmDescription);

  // Car form validation
  String get carFormBrandRequired => _tr(TranslationKeys.carFormBrandRequired);

  String get carFormModelRequired => _tr(TranslationKeys.carFormModelRequired);

  String get carFormCarTypeRequired => _tr(TranslationKeys.carFormCarTypeRequired);

  String get carFormYearRequired => _tr(TranslationKeys.carFormYearRequired);

  // Car form
  String get carFormAddTitle => _tr(TranslationKeys.carFormAddTitle);

  String get carFormSave => _tr(TranslationKeys.carFormSave);

  String get carFormDelete => _tr(TranslationKeys.carFormDelete);

  String get carFormBrand => _tr(TranslationKeys.carFormBrand);

  String get carFormModel => _tr(TranslationKeys.carFormModel);

  String get carFormYear => _tr(TranslationKeys.carFormYear);

  String get carFormEngineVolume => _tr(TranslationKeys.carFormEngineVolume);

  String get carFormFuelType => _tr(TranslationKeys.carFormFuelType);

  String get carFormTransmissionType => _tr(TranslationKeys.carFormTransmissionType);

  String get carFormCarType => _tr(TranslationKeys.carFormCarType);

  String get carFormEngineNumber => _tr(TranslationKeys.carFormEngineNumber);

  String get carFormVinNumber => _tr(TranslationKeys.carFormVinNumber);

  // My Addresses

  String get profileMyAddressesAddBtn => _tr(TranslationKeys.profileMyAddressesAddBtn);

  String get profileMyAddressesEmpty => _tr(TranslationKeys.profileMyAddressesEmpty);

  String get addressDeleteConfirmTitle => _tr(TranslationKeys.addressDeleteConfirmTitle);

  String get addressDeleteConfirmDescription => _tr(TranslationKeys.addressDeleteConfirmDescription);

  String get defaultLabel => _tr(TranslationKeys.defaultLabel);

  // Address form
  String get addressFormAddTitle => _tr(TranslationKeys.addressFormAddTitle);

  String get addressFormEditTitle => _tr(TranslationKeys.addressFormEditTitle);

  String get addressFormAddressType => _tr(TranslationKeys.addressFormAddressType);

  String get addressFormAddressTypeRequired => _tr(TranslationKeys.addressFormAddressTypeRequired);

  String get addressFormCity => _tr(TranslationKeys.addressFormCity);

  String get addressFormCityRequired => _tr(TranslationKeys.addressFormCityRequired);

  String get addressFormLine1 => _tr(TranslationKeys.addressFormLine1);

  String get addressFormLine1Required => _tr(TranslationKeys.addressFormLine1Required);

  String get addressFormLine2 => _tr(TranslationKeys.addressFormLine2);

  String get addressFormPhone => _tr(TranslationKeys.addressFormPhone);

  String get addressFormPhoneRequired => _tr(TranslationKeys.addressFormPhoneRequired);

  String get addressFormPickLocation => _tr(TranslationKeys.addressFormPickLocation);

  String get addressFormLocationRequired => _tr(TranslationKeys.addressFormLocationRequired);

  String get addressFormSave => _tr(TranslationKeys.addressFormSave);

  String get addressFormDelete => _tr(TranslationKeys.addressFormDelete);

  String get mapPickerTitle => _tr(TranslationKeys.mapPickerTitle);

  String get mapPickerConfirm => _tr(TranslationKeys.mapPickerConfirm);

  String get profileUpdateTitle => _tr(TranslationKeys.profileUpdateTitle);

  String get profileUpdateSave => _tr(TranslationKeys.profileUpdateSave);

  String get profileUpdateNameRequired => _tr(TranslationKeys.profileUpdateNameRequired);

  String get profileUpdateSurnameRequired => _tr(TranslationKeys.profileUpdateSurnameRequired);

  String get profileUpdateSuccess => _tr(TranslationKeys.profileUpdateSuccess);

  String get profileUpdateSelectGender => _tr(TranslationKeys.profileUpdateSelectGender);

  String get profileUpdateSelectBirthDate => _tr(TranslationKeys.profileUpdateSelectBirthDate);

  String get profileLogout => _tr(TranslationKeys.profileLogout);

  String get profileDeleteAccount => _tr(TranslationKeys.profileDeleteAccount);

  String get logoutConfirmTitle => _tr(TranslationKeys.logoutConfirmTitle);

  String get logoutConfirmDescription => _tr(TranslationKeys.logoutConfirmDescription);

  String get deleteAccountConfirmTitle => _tr(TranslationKeys.deleteAccountConfirmTitle);

  String get deleteAccountConfirmDescription => _tr(TranslationKeys.deleteAccountConfirmDescription);

  // Sessions
  String get sessionsTitle => _tr(TranslationKeys.sessionsTitle);

  String get sessionsCurrentSession => _tr(TranslationKeys.sessionsCurrentSession);

  String get sessionsOtherSessions => _tr(TranslationKeys.sessionsOtherSessions);

  String get sessionsTerminate => _tr(TranslationKeys.sessionsTerminate);

  String get sessionsTerminateConfirmTitle => _tr(TranslationKeys.sessionsTerminateConfirmTitle);

  String get sessionsTerminateConfirmDescription => _tr(TranslationKeys.sessionsTerminateConfirmDescription);

  String get sessionsTerminatedSuccess => _tr(TranslationKeys.sessionsTerminatedSuccess);

  String get sessionsEmpty => _tr(TranslationKeys.sessionsEmpty);

  String get sessionsThisDevice => _tr(TranslationKeys.sessionsThisDevice);
}
