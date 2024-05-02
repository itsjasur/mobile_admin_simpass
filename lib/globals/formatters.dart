import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomFormat {
  String? formatDate(String? dateTimeString) {
    if (dateTimeString != null) {
      // parsing the string into a DateTime object
      DateTime dateTime = DateTime.parse(dateTimeString);

      //  output format for a more readable date and time
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      //  the DateTime object using the output format
      String formattedDateTime = outputFormat.format(dateTime);
      return formattedDateTime;
    }

    return null;
  }

  String? formatDateTime(String? dateTimeString) {
    if (dateTimeString != null) {
      //  Define the date format that matches the input string
      DateFormat format = DateFormat("yyyy-MM-dd h:mm");

      // Parse the date string into a DateTime object
      DateTime dateTime = format.parse(dateTimeString);

      //  Create a DateFormat object with the desired format
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

      // Format the DateTime object as a string
      String formattedString = formatter.format(dateTime);

      return formattedString;
    }

    return null;
  }

  String wonify(num? amount) {
    if (amount == null || amount < 0) {
      amount = 0;
    }

    String stringAmount = NumberFormat("#,###").format(amount).toString();

    return ('₩ ${stringAmount.toString()}');
  }

  String commafy(num? amount) {
    if (amount == null || amount < 0) {
      return "";
    }

    String stringAmount = NumberFormat("#,###").format(amount).toString();

    return (stringAmount.toString());
  }

  int deCommafy(String? value) {
    if (value == null) {
      return 0;
    }
    String pureValue = value.replaceAll(',', '').replaceAll(' ', '');

    return (int.tryParse(pureValue) ?? 0);
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('-', '');
    if (newText.length > 11) {
      newText = newText.substring(0, 11);
    }

    int cursorPosition = newValue.selection.end;
    int offset = 0; // keeping track of number of spaces added before the cursor

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if ((i == 3 || i == 7) && i != 0) {
        buffer.write('-');
        offset++;
      }
      buffer.write(newText[i]);
    }

    int newCursorPosition = cursorPosition + offset;
    // ensuring the cursor remains within the bounds of the text
    newCursorPosition = newCursorPosition > buffer.length ? buffer.length : newCursorPosition;

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String text = newValue.text.replaceAll(',', '');

    double doubleValue = double.parse(text);

    String formattedText = NumberFormat("#,###").format(doubleValue);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('-', '');

    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if ((i == 4 || i == 6) && i != 0) buffer.write('-');
      buffer.write(newText[i]);
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
