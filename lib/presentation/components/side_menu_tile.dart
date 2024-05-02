import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/providers/side_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({
    super.key,
    required this.title,
    required this.iconSrc,
    required this.press,
    this.isSelected = false,
  });

  final String title, iconSrc;
  final VoidCallback press;
  final bool isSelected;

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.press();
        shellScaffoldKey.currentState?.closeDrawer();
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                widget.iconSrc,
                colorFilter: widget.isSelected
                    ? const ColorFilter.mode(MainUi.mainColor, BlendMode.srcIn)
                    : const ColorFilter.mode(
                        Colors.black87,
                        BlendMode.srcIn,
                      ),
                height: 16,
              ),
              const SizedBox(width: 15),
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.isSelected ? MainUi.mainColor : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
