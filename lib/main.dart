import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';
import 'user_provider.dart';

/// Entry point for the login only project.
///
/// This project is a minimal Flutter application that reproduces the login
/// screen from the original project but removes the domain field. It keeps
/// the same structure of separating the UI into widgets and using a
/// [ChangeNotifier] to store the username globally. No API calls areflutt
/// performed here; authentication logic should be added later.
void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
}
