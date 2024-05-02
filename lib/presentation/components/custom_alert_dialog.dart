import 'package:flutter/material.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  double? width,
  double? height,
  required Widget content,
  bool barrierDismissible = true,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button!
    // useSafeArea: true,
    // barrierColor: Colors.black26,
    // useRootNavigator: false,

    builder: (BuildContext context) {
      return Stack(
        children: [
          AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            // contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Adjust the radius here
            ),
            content: content,
          ),
          const IgnorePointer(
            ignoring: true,
            child: Scaffold(
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      );
    },
  );
}
