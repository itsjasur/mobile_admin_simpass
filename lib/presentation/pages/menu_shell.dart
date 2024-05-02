import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/providers/side_menu_provider.dart';
import 'package:admin_simpass/presentation/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuShell extends StatelessWidget {
  final Widget child;

  const MenuShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<SideMenuProvider>(builder: (context, controller, sideMenuChild) {
      //updating side menu status depending on the screen size
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.updateDrawerBasedOnScreenSize(MediaQuery.of(context).size.width);
      });

      // this should be called whenever screen size changes
      double width = 0;
      if (controller.isDesktop && controller.isSideMenuOpen) {
        width = 300; // example open width, adjust as needed
      }

      return Scaffold(
        key: shellScaffoldKey,
        drawer: const SideMenu(),
        onDrawerChanged: (isOpen) {
          controller.updateSideMenu(isOpen);
        },
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200), // adjsting the duration to control the speed of the animation
              width: width,
              curve: Curves.fastOutSlowIn,
              child: const SideMenu(), // Optional: Add a curve for the animation
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      );
    });
  }
}
