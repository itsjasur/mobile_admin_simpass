import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

Future<String?> showDateTimePicker(BuildContext context) async {
  // DateFormat outputFormat = DateFormat("yyyy-mm-dd h:mm a");

  DateTime? selectedDateTime = await showOmniDateTimePicker(
    context: context,

    // barrierDismissible: false,
    theme: ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        background: Colors.white,
        primary: Colors.black54,
        surfaceTint: Colors.white,
      ),
    ),
    type: OmniDateTimePickerType.dateAndTime,
  );

  if (selectedDateTime != null) {
    // return outputFormat.format(selectedDateTime);
    return selectedDateTime.toString();
  }

  return null;
}
