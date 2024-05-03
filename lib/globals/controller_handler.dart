//going back to the scroll begining
import 'package:flutter/material.dart';

void scrollToBegin(ScrollController controller) {
  controller.animateTo(
    controller.position.minScrollExtent,
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeInOut,
  );
}

//going back to the scroll begining
void scrollToEnd(ScrollController controller) {
  controller.animateTo(
    controller.position.maxScrollExtent,
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeInOut,
  );
}
