import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceProvider extends ChangeNotifier {
  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> loggedIn(BuildContext context, accessToken, refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);

    _isLoggedIn = true;
    if (context.mounted) context.go('/profile');
    notifyListeners();
  }

  Future<void> loggedOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    _isLoggedIn = false;
    if (context.mounted) context.go('/login');
    notifyListeners();
  }
}
