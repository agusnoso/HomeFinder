import 'package:flutter/material.dart';

/// Collection of reusable form widgets used by the sign in screen.
///
/// In the original project the domain field lived here. For this
/// simplified login project only the username and password fields are
/// implemented. This class could be extended with additional widgets
/// (e.g. for email or phone number) as needed.
class FormWidgets {
  /// Returns a text field for entering the username.
  TextFormField usernameField(
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Introduce el usuario',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  /// Returns a text field for entering the password.
  TextFormField passwordField(
    TextEditingController controller,
    bool isHidden,
    VoidCallback toggleVisibility,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: '*******',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: GestureDetector(
          onTap: toggleVisibility,
          child: Icon(
            isHidden ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}