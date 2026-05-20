import 'package:flutter/material.dart';

class GuestMessagesView extends StatelessWidget {
  const GuestMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes'), centerTitle: true),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'La funcionalidad estará disponible próximamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
