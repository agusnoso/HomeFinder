import 'package:flutter/material.dart';
import '../../../data/services/property_service.dart';

class MyPropertiesView extends StatefulWidget {
  const MyPropertiesView({super.key});

  @override
  State<MyPropertiesView> createState() => _MyPropertiesViewState();
}

class _MyPropertiesViewState extends State<MyPropertiesView> {
  final PropertyService _propertyService = PropertyService();
  late final Future<List<Map<String, dynamic>>> _myPropertiesFuture;

  @override
  void initState() {
    super.initState();
    _myPropertiesFuture = _propertyService.getMyProperties();
  }

  String _formatPrice(dynamic value) {
    if (value == null) return 'Precio no disponible';

    final num? price = value is num ? value : num.tryParse(value.toString());
    if (price == null) return 'Precio no disponible';

    return '\$${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis viviendas'), centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _myPropertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'No se pudieron cargar tus viviendas.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final List<Map<String, dynamic>> properties = snapshot.data ?? [];

          if (properties.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Aún no has publicado viviendas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final property = properties[index];

              final String title =
                  (property['title'] as String?)?.trim().isNotEmpty == true
                      ? property['title'] as String
                      : 'Sin título';
              final String city =
                  (property['city'] as String?)?.trim().isNotEmpty == true
                      ? property['city'] as String
                      : 'Ciudad no disponible';
              final String operationType =
                  (property['operation_type'] as String?)?.trim().isNotEmpty ==
                          true
                      ? property['operation_type'] as String
                      : 'Tipo de operación no disponible';
              final String propertyType =
                  (property['property_type'] as String?)?.trim().isNotEmpty ==
                          true
                      ? property['property_type'] as String
                      : 'Tipo de vivienda no disponible';

              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(city, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(
                        _formatPrice(property['price']),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text(operationType)),
                          Chip(label: Text(propertyType)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
