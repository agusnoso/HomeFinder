import 'package:flutter/material.dart';

/// Simple provider to hold the logged in username.
///
/// The original project used separate providers for the user and domain.
/// Since the domain field has been removed, this provider only tracks
/// the username. Additional fields (such as tokens) could be added later.
class UserProvider extends ChangeNotifier {
  String _username = '';

  /// Returns the currently logged in username.
  String get username => _username;

  /// Updates the stored username and notifies listeners.
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}