import 'package:flutter/services.dart';

class InputFormatter {
  //Only azerbaijani letters
  static TextInputFormatter getStandardFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-ZəğöüşıçƏĞÖÜİŞÇ\s]*$'));
  }

  static TextInputFormatter getPersonNameFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      var text = newValue.text;

      // 1️⃣ Allow only Azerbaijani/English letters + space
      text = text.replaceAll(RegExp(r'[^a-zA-ZƏəİıÖöÜüĞğŞşÇç\s]'), '');

      // 2️⃣ Normalize multiple spaces
      text = text.replaceAll(RegExp(r'\s+'), ' ');

      // 3️⃣ Capitalize each word
      final words = text.split(' ');
      final capitalizedWords = words
          .map((word) {
            if (word.isEmpty) return '';
            final first = word[0].toUpperCase();
            final rest = word.substring(1).toLowerCase();
            return '$first$rest';
          })
          .join(' ');

      return TextEditingValue(
        text: capitalizedWords,
        selection: TextSelection.collapsed(offset: capitalizedWords.length),
      );
    });
  }

  //Only email format
  static TextInputFormatter getEmailFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-+]'));
  }

  static TextInputFormatter getPhoneNumberFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // Remove all non-digit characters
      final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

      // Limit to 12 digits
      final limitedDigits = digits.length > 12 ? digits.substring(0, 12) : digits;

      // Format: 994 50 555 55 55 (spaces at positions 3, 6, 9, 11)
      final buffer = StringBuffer();
      for (int i = 0; i < limitedDigits.length; i++) {
        if (i == 3 || i == 5 || i == 8 || i == 10) {
          buffer.write(' ');
        }
        buffer.write(limitedDigits[i]);
      }

      final formatted = buffer.toString();

      // Calculate cursor position
      int cursorPos = newValue.selection.end;
      int spaceCount = 0;

      for (int pos in [3, 5, 8, 10]) {
        if (cursorPos > pos - spaceCount) {
          spaceCount++;
        }
      }

      int selectionIndex = cursorPos + spaceCount;
      selectionIndex = selectionIndex.clamp(0, formatted.length);

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
    });
  }

  static TextInputFormatter getLocalPhoneFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      final limited = digits.length > 9 ? digits.substring(0, 9) : digits;

      // Format: XX XXX XX XX (spaces at index 2, 5, 7)
      final buffer = StringBuffer();
      for (int i = 0; i < limited.length; i++) {
        if (i == 2 || i == 5 || i == 7) buffer.write(' ');
        buffer.write(limited[i]);
      }

      final formatted = buffer.toString();
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  static TextInputFormatter getPasswordFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z\d!@#$%^&*()-_+=]'));
  }

  static TextInputFormatter allowAllFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'.*'));
  }
}
