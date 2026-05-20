import 'package:flutter/material.dart';

class PublishPropertyView extends StatelessWidget {
  const PublishPropertyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BasePlaceholderScreen(
      title: 'Publicar vivienda',
      message: 'La funcionalidad estará disponible próximamente.',
    );
  }
}

class _BasePlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;

  const _BasePlaceholderScreen({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
