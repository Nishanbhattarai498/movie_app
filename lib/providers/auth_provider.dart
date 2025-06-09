import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    if (email.isNotEmpty && password.length >= 6) {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = email.split('@')[0];
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = name;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }
}
