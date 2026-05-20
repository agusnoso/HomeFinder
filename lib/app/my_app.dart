import 'package:flutter/material.dart';

import '../presentation/screens/auth/sign_in.dart';
import '../presentation/screens/guest/available_properties_view.dart';
import '../presentation/screens/guest/guest_messages_view.dart';
import '../presentation/screens/guest/guest_requests_view.dart';
import '../presentation/screens/guest/search_properties_view.dart';
import '../presentation/screens/home/home_view.dart';
import '../presentation/screens/owner/my_properties_view.dart';
import '../presentation/screens/owner/owner_messages_view.dart';
import '../presentation/screens/owner/owner_requests_view.dart';
import '../presentation/screens/owner/publish_property_view.dart';

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
        '/owner/publish-property': (_) => const PublishPropertyView(),
        '/owner/my-properties': (_) => const MyPropertiesView(),
        '/owner/requests': (_) => const OwnerRequestsView(),
        '/owner/messages': (_) => const OwnerMessagesView(),
        '/guest/search-properties': (_) => const SearchPropertiesView(),
        '/guest/available-properties': (_) => const AvailablePropertiesView(),
        '/guest/requests': (_) => const GuestRequestsView(),
        '/guest/messages': (_) => const GuestMessagesView(),
      },
    );
  }
}
