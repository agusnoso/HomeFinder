import 'package:flutter/material.dart';
import '../../../data/services/property_service.dart';

class MyPropertiesView extends StatefulWidget {
  const MyPropertiesView({super.key});

  @override
  State<MyPropertiesView> createState() => _MyPropertiesViewState();
}

class _MyPropertiesViewState extends State<MyPropertiesView> {
  final PropertyService _propertyService = PropertyService();
  late Future<List<Map<String, dynamic>>> _myPropertiesFuture;

  @override
  void initState() {
    super.initState();
    _myPropertiesFuture = _propertyService.getMyProperties();
  }

  void _reloadProperties() {
    setState(() {
      _myPropertiesFuture = _propertyService.getMyProperties();
    });
  }

  Future<void> _showEditPropertyDialog(Map<String, dynamic> property) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(
      text: (property['title'] as String?) ?? '',
    );
    final descriptionController = TextEditingController(
      text: (property['description'] as String?) ?? '',
    );
    final addressController = TextEditingController(
      text: (property['address'] as String?) ?? '',
    );
    final cityController = TextEditingController(
      text: (property['city'] as String?) ?? '',
    );
    final priceController = TextEditingController(
      text: property['price']?.toString() ?? '',
    );

    String operationType =
        (property['operation_type'] as String?)?.trim().isNotEmpty == true
        ? property['operation_type'] as String
        : 'alquiler';
    String propertyType =
        (property['property_type'] as String?)?.trim().isNotEmpty == true
        ? property['property_type'] as String
        : 'piso';
    bool isSubmitting = false;

    final bool? updated = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Editar vivienda'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El título es obligatorio';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La dirección es obligatoria';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: cityController,
                        decoration: const InputDecoration(labelText: 'Ciudad'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La ciudad es obligatoria';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Precio'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El precio es obligatorio';
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null) {
                            return 'El precio debe ser numérico';
                          }
                          if (parsed <= 0) {
                            return 'El precio debe ser mayor que 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: operationType,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de operación',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'alquiler',
                            child: Text('Alquiler'),
                          ),
                          DropdownMenuItem(value: 'venta', child: Text('Venta')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            operationType = value;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: propertyType,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de vivienda',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'piso', child: Text('Piso')),
                          DropdownMenuItem(value: 'casa', child: Text('Casa')),
                          DropdownMenuItem(
                            value: 'estudio',
                            child: Text('Estudio'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            propertyType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          setDialogState(() {
                            isSubmitting = true;
                          });

                          try {
                            await _propertyService.updateProperty(
                              propertyId: property['id'] as String,
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              address: addressController.text.trim(),
                              city: cityController.text.trim(),
                              price: double.parse(priceController.text.trim()),
                              operationType: operationType,
                              propertyType: propertyType,
                            );

                            if (!mounted) return;
                            Navigator.of(dialogContext).pop(true);
                          } catch (_) {
                            if (!mounted) return;
                            setDialogState(() {
                              isSubmitting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se pudo actualizar la vivienda.',
                                ),
                              ),
                            );
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    cityController.dispose();
    priceController.dispose();

    if (updated == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vivienda actualizada correctamente.')),
      );
      _reloadProperties();
    }
  }

  Future<void> _confirmDeleteProperty(String propertyId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar vivienda'),
          content: const Text(
            '¿Seguro que quieres eliminar esta vivienda? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _propertyService.deleteProperty(propertyId: propertyId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vivienda eliminada correctamente.')),
      );
      _reloadProperties();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo eliminar la vivienda.')));
    }
  }

  String _formatPrice(dynamic value) {
    if (value == null) return 'Precio no disponible';

    final num? price = value is num ? value : num.tryParse(value.toString());
    if (price == null) return 'Precio no disponible';

    return '${price.toStringAsFixed(0)} €';
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => _showEditPropertyDialog(property),
                            child: const Text('Editar'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.tonal(
                            onPressed: () => _confirmDeleteProperty(
                              property['id'] as String,
                            ),
                            child: const Text('Eliminar'),
                          ),
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
