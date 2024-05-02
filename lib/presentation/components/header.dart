import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/side_menu_provider.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  final String? title;
  const Header({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServiceProvider>(builder: (context, authController, child) {
      return Container(
        // color: Colors.amber.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: [
                  Consumer<SideMenuProvider>(
                    builder: (context, controller, child) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          controller.isDesktop ? controller.toggleDrawer() : shellScaffoldKey.currentState?.openDrawer();
                        },
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 500), // Duration of the animation
                          turns: controller.isSideMenuOpen ? 0 : 0.5, // 0.5 turns for 180 degrees
                          child: const Icon(
                            Icons.menu_open,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                await authController.loggedOut(context);
              },
              child: const Text('로그아웃'),
            )
          ],
        ),
      );
    });
  }
}
