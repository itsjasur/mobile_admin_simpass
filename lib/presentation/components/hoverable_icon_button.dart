import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';

class HoverAbleIconButton extends StatefulWidget {
  final void Function()? onTap;

  final IconData icon;
  final double size;
  const HoverAbleIconButton({super.key, required this.icon, this.onTap, this.size = 22});

  @override
  State<HoverAbleIconButton> createState() => _HoverAbleIconButtonState();
}

class _HoverAbleIconButtonState extends State<HoverAbleIconButton> {
  bool _beingHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      child: Icon(
        widget.icon,
        size: widget.size,
        color: _beingHovered ? MainUi.mainColor : Colors.black54,
      ),
      onHover: (value) {
        _beingHovered = value;
        setState(() {});
      },
    );
  }
}
