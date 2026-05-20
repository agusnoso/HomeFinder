import 'package:flutter/material.dart';

import '../presentation/screens/auth/sign_in.dart';
import '../presentation/screens/home/home_view.dart';

/// Root widget for the login project.
///
/// Defines routes and wraps the sign‑in view as the initial page. When the
/// user successfully logs in, the app navigates to a simple home view. This
/// separation mirrors the structure of the original project while keeping
/// the codebase focused on authentication.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeFinder Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInView(),
      routes: {
        '/home': (_) => const HomeView(),
      },
    );
  }
}