import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_provider.dart';

/// Simple home view displayed after successful login.
///
/// Shows the logged in username using [UserProvider]. This page is
/// intentionally minimal; in the full application it would be replaced
/// with the actual home screen functionality.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserProvider>().username;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home, size: 64),
            const SizedBox(height: 16),
            Text(
              'Bienvenido${username.isNotEmpty ? ', $username' : ''}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}