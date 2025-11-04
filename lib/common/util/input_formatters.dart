import 'package:flutter/services.dart';

class InputFormatter {
  //Only azerbaijani letters
  static TextInputFormatter getStandardFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-ZəğöüşıçƏĞÖÜİŞÇ\s]*$'));
  }

  //Only email format
  static TextInputFormatter getEmailFormatter() {
    return FilteringTextInputFormatter.allow(
      RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~@-]"),
    );
  }

  //Number with options
  static TextInputFormatter getNumberWithOptions() {
    return FilteringTextInputFormatter.allow(
      RegExp(r"[0-9\-/]"),
    );
  }

  //Advocate number
  static TextInputFormatter getAdvocateNumberFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9-/VK]*'));
  }

  //Advocate number
  static TextInputFormatter getNumberFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9]*'));
  }

  //Driver license number
  static TextInputFormatter getDriverLicenseNumber() {
    return DriverLicenseInputFormatter();
  }

  static TextInputFormatter getPasswordFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z\d!@#$%^&*()-_+=]'));
  }

  static TextInputFormatter allowAllFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'.*'));
  }
}

class DriverLicenseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length) {
      if (newValue.text.length <= 2) {
        final lettersOnly = RegExp(r'^[a-zA-Z]*$');
        if (!lettersOnly.hasMatch(newValue.text)) {
          return oldValue;
        }
      } else {
        final validInput = RegExp(r'^[a-zA-Z]{2}\d*$');
        if (!validInput.hasMatch(newValue.text)) {
          return oldValue;
        }
      }
    }
    return newValue;
  }
}

class LeadingZeroInputFormatter extends TextInputFormatter {
  final String code;

  LeadingZeroInputFormatter({required this.code});
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (code == "AZ" && newValue.text.startsWith('0') && newValue.text.length == 1) {
      return oldValue;
    }

    return newValue;
  }
}
