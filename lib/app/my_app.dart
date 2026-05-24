import 'package:flutter/material.dart';

import '../presentation/screens/auth/sign_in.dart';
import '../presentation/screens/auth/sign_up.dart';
import '../presentation/screens/guest/available_properties_view.dart';
import '../presentation/screens/guest/guest_messages_view.dart';
import '../presentation/screens/guest/guest_requests_view.dart';
import '../presentation/screens/guest/search_properties_view.dart';
import '../presentation/screens/home/home_view.dart';
import '../presentation/screens/owner/my_properties_view.dart';
import '../presentation/screens/owner/owner_messages_view.dart';
import '../presentation/screens/owner/owner_requests_view.dart';
import '../presentation/screens/owner/owner_stats_view.dart';
import '../presentation/screens/owner/publish_property_view.dart';
import '../presentation/screens/splash/splash_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const scaffoldBackground = Color(0xFFF5F5F5);
    const surface = Color(0xFFFFFFFF);
    const textPrimary = Color(0xFF1F1F1F);
    const textSecondary = Color(0xFF6B6B6B);
    const border = Color(0xFFD9D9D9);
    const primary = Color(0xFF2B2B2B);
    const accent = Color(0xFFB3261E);

    final theme = ThemeData(
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textPrimary,
        outline: border,
        secondary: accent,
      ),
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accent),
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'HomeFinder',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashView(),
      routes: {
        '/sign-in': (_) => const SignInView(),
        '/home': (_) => const HomeView(),
        '/sign-up': (_) => const SignUpView(),
        '/owner/publish-property': (_) => const PublishPropertyView(),
        '/owner/my-properties': (_) => const MyPropertiesView(),
        '/owner/requests': (_) => const OwnerRequestsView(),
        '/owner/messages': (_) => const OwnerMessagesView(),
        '/owner/stats': (_) => const OwnerStatsView(),
        '/guest/search-properties': (_) => const SearchPropertiesView(),
        '/guest/available-properties': (_) => const AvailablePropertiesView(),
        '/guest/requests': (_) => const GuestRequestsView(),
        '/guest/messages': (_) => const GuestMessagesView(),
      },
    );
  }
}
