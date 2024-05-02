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
  //changing color when hovered
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<SideMenuProvider>(
      builder: (context, sideMenuController, child) => InkWell(
        onTap: () {
          if (!sideMenuController.isDesktop) shellScaffoldKey.currentState?.closeDrawer();
          widget.press();
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,
          child: MouseRegion(
            onEnter: (PointerEvent details) {
              _hovering = true;
              setState(() {});
            },
            onExit: (PointerEvent details) {
              _hovering = false;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    widget.iconSrc,
                    colorFilter: widget.isSelected || _hovering
                        ? const ColorFilter.mode(MainUi.mainColor, BlendMode.srcIn)
                        : const ColorFilter.mode(
                            Colors.white70,
                            BlendMode.srcIn,
                          ),
                    height: 16,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.isSelected || _hovering ? MainUi.mainColor : Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
