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

  String get connectionFailure;

  String get serverFailure;

  String get withNumber;

  String get withEmail;

  String get entranceToAccount;

  String get email;

  String get mobileNumber;

  String get password;

  String get forward;

  String get requiredFieldErrorText;

  String get invalidEmailText;

  String get forgotPassword;

  String get doNotHaveAccount;

  String get signUp;

  String get google;

  String get apple;

  String get signUpTermsText;

  String get invalidFormat;

  String get phoneVerification;

  String otpSentToNumber(String number);

  String get confirm;

  String get passwordRecovery;
}
