import 'package:flutter/material.dart';
import '../../../data/services/property_service.dart';

class AvailablePropertiesView extends StatefulWidget {
  const AvailablePropertiesView({super.key});

  @override
  State<AvailablePropertiesView> createState() =>
      _AvailablePropertiesViewState();
}

class _AvailablePropertiesViewState extends State<AvailablePropertiesView> {
  final PropertyService _propertyService = PropertyService();
  late final Future<List<Map<String, dynamic>>> _availablePropertiesFuture;

  @override
  void initState() {
    super.initState();
    _availablePropertiesFuture = _propertyService.getAvailableProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viviendas disponibles'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _availablePropertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No se pudieron cargar las viviendas: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final properties = snapshot.data ?? [];

          if (properties.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'No hay viviendas disponibles por el momento.',
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
              final title = (property['title'] as String?)?.trim();
              final city = (property['city'] as String?)?.trim();
              final description = (property['description'] as String?)?.trim();
              final operationType =
                  (property['operation_type'] as String?)?.trim();
              final propertyType =
                  (property['property_type'] as String?)?.trim();
              final price = property['price'];

              return Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title?.isNotEmpty == true ? title! : 'Sin título',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ciudad: ${city?.isNotEmpty == true ? city : 'No especificada'}',
                      ),
                      const SizedBox(height: 4),
                      Text('Precio: ${_formatPrice(price)}'),
                      const SizedBox(height: 4),
                      Text(
                        'Operación: ${operationType?.isNotEmpty == true ? operationType : 'No especificada'}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tipo: ${propertyType?.isNotEmpty == true ? propertyType : 'No especificado'}',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description?.isNotEmpty == true
                            ? description!
                            : 'Sin descripción disponible.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
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

  String _formatPrice(dynamic value) {
    if (value is num) {
      return '\$${value.toStringAsFixed(0)}';
    }

    return 'No especificado';
  }
}
