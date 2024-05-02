import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyinfoProvifer extends ChangeNotifier {
  List<String> _myRoles = [];
  List<String> get myRoles => _myRoles;

  Future<void> setRoles(List<String> roles) async {
    _myRoles = roles;
    notifyListeners();
  }

  Future<void> updateRoles(List<String> roles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myRolesList', roles);
    _myRoles = roles;
    notifyListeners();
  }

  Future<List<String>> getRolesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roles = prefs.getStringList('myRolesList') ?? [];
    _myRoles = roles;
    return roles;
  }
}
