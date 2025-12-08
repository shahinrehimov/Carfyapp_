import 'package:flutter/services.dart';

class InputFormatter {
  //Only azerbaijani letters
  static TextInputFormatter getStandardFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-ZəğöüşıçƏĞÖÜİŞÇ\s]*$'));
  }

  //Only email format
  static TextInputFormatter getEmailFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-+]'));
  }

  //Advocate number
  static TextInputFormatter getNumberFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9]*'));
  }

  static TextInputFormatter getPasswordFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z\d!@#$%^&*()-_+=]'));
  }

  static TextInputFormatter allowAllFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'.*'));
  }
}
