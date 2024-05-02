import 'package:flutter/material.dart';

class MenuIndexProvider with ChangeNotifier {
  int _openSideMenuIndex = -1;

  int get openSideMenuIndex => _openSideMenuIndex;

  void updateMenuIndexWithUrl(String routePath) {
    int newIndex;
    switch (routePath) {
      case '/profile':
        newIndex = 0;
        break;
      case '/manage-users': // this is for manage members
        newIndex = 1;
        break;
      case '/manage-plans':
        newIndex = 2;
        break;
      case '/applications':
        newIndex = 3;
        break;
      case '/retailers':
        newIndex = 4;
        break;
      case '/customer-requests':
        newIndex = 5;
        break;

      default:
        newIndex = -1; // Default or not found
        break;
    }
    if (openSideMenuIndex != newIndex) {
      _openSideMenuIndex = newIndex;
      notifyListeners();
    }
  }
}
