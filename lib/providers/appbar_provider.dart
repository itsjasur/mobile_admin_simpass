import 'package:flutter/material.dart';

class AppBarProvider extends ChangeNotifier {
  String _appbarTitle = "";

  String get appBarTitle => _appbarTitle;

  void appBarChange(String title) async {
    _appbarTitle = title;
    notifyListeners();
  }
}
