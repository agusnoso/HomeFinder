import 'package:flutter/material.dart';

class GuestRequestsView extends StatelessWidget {
  const GuestRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes'), centerTitle: true),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Esta funcionalidad estará disponible próximamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
