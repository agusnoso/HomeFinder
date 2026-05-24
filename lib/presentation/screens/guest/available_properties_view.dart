import 'package:flutter/material.dart';
import '../../../data/services/property_service.dart';
import 'property_detail_view.dart';

class AvailablePropertiesView extends StatefulWidget {
  const AvailablePropertiesView({super.key});

  @override
  State<AvailablePropertiesView> createState() =>
      _AvailablePropertiesViewState();
}

class _AvailablePropertiesViewState extends State<AvailablePropertiesView> {
  final PropertyService _propertyService = PropertyService();
  final TextEditingController _cityController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _availablePropertiesFuture;
  String _lastSearchedCity = '';

  @override
  void initState() {
    super.initState();
    _availablePropertiesFuture = _propertyService.getAvailableProperties();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _searchProperties() {
    final city = _cityController.text.trim();
    setState(() {
      _lastSearchedCity = city;
      _availablePropertiesFuture = _propertyService.getAvailableProperties(
        cityQuery: city,
      );
    });
  }

  void _clearSearch() {
    _cityController.clear();
    _searchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Viviendas disponibles'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchProperties(),
                    decoration: const InputDecoration(
                      labelText: 'Buscar por ciudad',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _searchProperties,
                  tooltip: 'Buscar',
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: _clearSearch,
                  tooltip: 'Limpiar búsqueda',
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
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
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _lastSearchedCity.isEmpty
                              ? 'No hay viviendas disponibles por el momento.'
                              : 'No hay viviendas para la ciudad "$_lastSearchedCity".',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: properties.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      final title = (property['title'] as String?)?.trim();
                      final city = (property['city'] as String?)?.trim();
                      final description =
                          (property['description'] as String?)?.trim();
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
                                title?.isNotEmpty == true
                                    ? title!
                                    : 'Sin título',
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
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PropertyDetailView(
                                          property: property,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Ver detalle'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(dynamic value) {
    final num? price = value is num ? value : num.tryParse(value.toString());

    if (price == null) {
      return 'No especificado';
    }

    return '${price.toStringAsFixed(0)} €';
  }
}
