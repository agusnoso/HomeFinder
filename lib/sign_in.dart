import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_widgets.dart';
import 'user_provider.dart';

/// Login screen with user and password fields only.
///
/// This widget reproduces the structure of the original login page but
/// intentionally omits the domain field. It leverages the [FormWidgets]
/// helper for reusable input widgets and a [UserProvider] to store
/// the logged in username. The authentication logic has been
/// intentionally kept as a stub—replace the contents of [_onSignIn]
/// with a real API call when integrating backend functionality.
class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final formWidgets = FormWidgets();

  bool _rememberMe = false;
  bool _isHidden = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> _onSignIn() async {
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduzca usuario y contraseña'),
        ),
      );
      return;
    }

    // TODO: integrate real authentication here (API call).

    // Save the username globally.
    context.read<UserProvider>().setUsername(username);

    // Optionally persist credentials if rememberMe is true. Implementation
    // omitted for brevity.

    // Navigate to the home page.
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de sesión'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, minWidth: 280),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text('Usuario', style: TextStyle(fontSize: 17)),
                ),
                const SizedBox(height: 8),
                formWidgets.usernameField(_userController),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Contraseña',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 8),
                formWidgets.passwordField(
                  _passController,
                  _isHidden,
                  _togglePasswordVisibility,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.red,
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Recordar'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Implementar recuperación de contraseña si es necesario.
                      },
                      child: const Text(
                        '¿Olvidó la contraseña?',
                        style: TextStyle(
                          color: Color(0xFF4d81e7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF353535),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
