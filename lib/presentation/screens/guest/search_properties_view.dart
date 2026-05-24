import 'package:flutter/material.dart';

import '../../../data/services/property_service.dart';
import 'property_detail_view.dart';

class SearchPropertiesView extends StatefulWidget {
  const SearchPropertiesView({super.key});

  @override
  State<SearchPropertiesView> createState() => _SearchPropertiesViewState();
}

class _SearchPropertiesViewState extends State<SearchPropertiesView> {
  final PropertyService _propertyService = PropertyService();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String _selectedOperationType = 'cualquiera';
  String _selectedPropertyType = 'cualquiera';
  bool _isLoading = false;
  List<Map<String, dynamic>> _results = <Map<String, dynamic>>[];
  bool _hasSearched = false;

  @override
  void dispose() {
    _cityController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar viviendas')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFiltersCard(),
              const SizedBox(height: 16),
              Expanded(child: _buildResultsSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                hintText: 'Ej: Madrid',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedOperationType,
              decoration: const InputDecoration(labelText: 'Operación'),
              items: const [
                DropdownMenuItem(value: 'cualquiera', child: Text('Cualquiera')),
                DropdownMenuItem(value: 'alquiler', child: Text('Alquiler')),
                DropdownMenuItem(value: 'venta', child: Text('Venta')),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedOperationType = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedPropertyType,
              decoration: const InputDecoration(labelText: 'Tipo de vivienda'),
              items: const [
                DropdownMenuItem(value: 'cualquiera', child: Text('Cualquiera')),
                DropdownMenuItem(value: 'piso', child: Text('Piso')),
                DropdownMenuItem(value: 'casa', child: Text('Casa')),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedPropertyType = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _maxPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Precio máximo',
                hintText: 'Ej: 1200',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _onSearchPressed,
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return const Center(
        child: Text(
          'Aplica filtros y pulsa "Buscar" para ver viviendas.',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron viviendas con los filtros seleccionados.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final property = _results[index];
        return _PropertyResultCard(
          property: property,
          onViewDetail: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PropertyDetailView(property: property),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSearchPressed() async {
    final String maxPriceText = _maxPriceController.text.trim();
    double? maxPrice;

    if (maxPriceText.isNotEmpty) {
      maxPrice = double.tryParse(maxPriceText.replaceAll(',', '.'));
      if (maxPrice == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El precio máximo debe ser un número válido.'),
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final properties = await _propertyService.searchProperties(
        city: _cityController.text,
        operationType: _selectedOperationType,
        propertyType: _selectedPropertyType,
        maxPrice: maxPrice,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _results = properties;
        _hasSearched = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo realizar la búsqueda: $error')),
      );
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class _PropertyResultCard extends StatelessWidget {
  const _PropertyResultCard({required this.property, required this.onViewDetail});

  final Map<String, dynamic> property;
  final VoidCallback onViewDetail;

  @override
  Widget build(BuildContext context) {
    final String title = _textOrFallback(property['title'], 'Sin título');
    final String city = _textOrFallback(property['city'], 'Sin ciudad');
    final String operationType = _textOrFallback(
      property['operation_type'],
      'No especificada',
    );
    final String propertyType = _textOrFallback(
      property['property_type'],
      'No especificado',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Ciudad: $city'),
            Text('Precio: ${_formatPrice(property['price'])}'),
            Text('Operación: $operationType'),
            Text('Tipo: $propertyType'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onViewDetail,
                child: const Text('Ver detalle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _textOrFallback(dynamic value, String fallback) {
    final String text = (value?.toString() ?? '').trim();
    return text.isEmpty ? fallback : text;
  }

  String _formatPrice(dynamic value) {
    final num? parsedPrice = value is num ? value : num.tryParse('$value');
    if (parsedPrice == null) {
      return 'No especificado';
    }
    return '${parsedPrice.toStringAsFixed(0)} €';
  }
}
