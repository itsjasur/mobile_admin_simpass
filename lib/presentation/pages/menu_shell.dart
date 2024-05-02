import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/providers/appbar_provider.dart';
import 'package:admin_simpass/presentation/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuShell extends StatelessWidget {
  final Widget child;

  const MenuShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppBarProvider>(builder: (context, value, child) => Text(value.appBarTitle)),
      ),
      key: shellScaffoldKey,
      drawer: const SideMenu(),
      body: child,
    );
  }
}
