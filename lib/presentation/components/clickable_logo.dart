import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';

class ClickableLogo extends StatelessWidget {
  final Color color;
  final double height;
  const ClickableLogo({super.key, this.color = MainUi.mainColor, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        "assets/logo.png",
        color: color,
        fit: BoxFit.contain,
      ),
    );
  }
}
