import 'package:flutter/material.dart';

class MyPropertiesView extends StatelessWidget {
  const MyPropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis viviendas'), centerTitle: true),
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
