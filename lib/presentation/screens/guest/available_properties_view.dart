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
  bool _isSendingRequest = false;

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
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSendingRequest
                              ? null
                              : () => _showRequestDialog(property),
                          child: const Text('Solicitar información'),
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
    );
  }

  String _formatPrice(dynamic value) {
    final num? price = value is num ? value : num.tryParse(value.toString());

    if (price == null) {
      return 'No especificado';
    }

    return '${price.toStringAsFixed(0)} €';
  }

  Future<void> _showRequestDialog(Map<String, dynamic> property) async {
    final String? message = await showDialog<String>(
      context: context,
      builder: (_) => const _RequestMessageDialog(),
    );

    if (message == null) {
      return;
    }

    final String? propertyId = property['id']?.toString();
    final String? ownerId = property['owner_id']?.toString();

    if (propertyId == null ||
        propertyId.isEmpty ||
        ownerId == null ||
        ownerId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo enviar la solicitud por falta de datos de la vivienda.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSendingRequest = true;
    });

    try {
      await _propertyService.createPropertyRequest(
        propertyId: propertyId,
        ownerId: ownerId,
        message: message,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Solicitud enviada con éxito.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo enviar la solicitud: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingRequest = false;
        });
      }
    }
  }
}

class _RequestMessageDialog extends StatefulWidget {
  const _RequestMessageDialog();

  @override
  State<_RequestMessageDialog> createState() => _RequestMessageDialogState();
}

class _RequestMessageDialogState extends State<_RequestMessageDialog> {
  late final TextEditingController _messageController;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Solicitar información'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _messageController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Mensaje',
              hintText: 'Escribe tu consulta sobre la vivienda',
              errorText: _validationError,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final message = _messageController.text.trim();
            if (message.isEmpty) {
              setState(() {
                _validationError = 'El mensaje no puede estar vacío.';
              });
              return;
            }
            Navigator.of(context).pop(message);
          },
          child: const Text('Enviar solicitud'),
        ),
      ],
    );
  }
}
