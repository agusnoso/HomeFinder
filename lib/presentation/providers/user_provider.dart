import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _role = 'huesped';

  String get username => _username;
  String get role => _role;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  void setUserData({required String username, required String role}) {
    _username = username;
    _role = role;
    notifyListeners();
  }

  void clearUserData() {
    _username = '';
    _role = 'huesped';
    notifyListeners();
  }
}
