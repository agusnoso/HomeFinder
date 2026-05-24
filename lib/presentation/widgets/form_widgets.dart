import 'package:flutter/material.dart';

class FormWidgets {
  TextFormField usernameField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'correo@ejemplo.com',
        prefixIcon: Icon(Icons.alternate_email_rounded),
      ),
    );
  }

  TextFormField passwordField(
    TextEditingController controller,
    bool isHidden,
    VoidCallback toggleVisibility,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: GestureDetector(
          onTap: toggleVisibility,
          child: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}
