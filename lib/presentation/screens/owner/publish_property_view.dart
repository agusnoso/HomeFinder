import 'package:flutter/material.dart';

class PublishPropertyView extends StatelessWidget {
  const PublishPropertyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BasePlaceholderScreen(title: 'Publicar vivienda');
  }
}

class _BasePlaceholderScreen extends StatelessWidget {
  final String title;

  const _BasePlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
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
