import 'package:admin_simpass/globals/dialpad_launcher.dart';
import 'package:flutter/material.dart';

class TextLauncher extends StatelessWidget {
  final String text;
  const TextLauncher({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launchDialer(text);
      },
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.blue,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
