import 'package:flutter/material.dart';

import '../../../data/services/property_service.dart';

class PropertyDetailView extends StatefulWidget {
  const PropertyDetailView({super.key, required this.property});

  final Map<String, dynamic> property;

  @override
  State<PropertyDetailView> createState() => _PropertyDetailViewState();
}

class _PropertyDetailViewState extends State<PropertyDetailView> {
  final PropertyService _propertyService = PropertyService();
  bool _isSendingRequest = false;

  @override
  Widget build(BuildContext context) {
    final title = (widget.property['title'] as String?)?.trim();
    final description = (widget.property['description'] as String?)?.trim();
    final address = (widget.property['address'] as String?)?.trim();
    final city = (widget.property['city'] as String?)?.trim();
    final operationType = (widget.property['operation_type'] as String?)?.trim();
    final propertyType = (widget.property['property_type'] as String?)?.trim();
    final price = widget.property['price'];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Detalle de vivienda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title?.isNotEmpty == true ? title! : 'Sin título',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Descripción', value: _safeText(description, 'Sin descripción disponible.')),
            _DetailRow(label: 'Dirección', value: _safeText(address, 'No especificada')),
            _DetailRow(label: 'Ciudad', value: _safeText(city, 'No especificada')),
            _DetailRow(label: 'Precio', value: _formatPrice(price)),
            _DetailRow(label: 'Operación', value: _safeText(operationType, 'No especificada')),
            _DetailRow(label: 'Tipo de vivienda', value: _safeText(propertyType, 'No especificado')),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSendingRequest ? null : _onRequestInfoPressed,
                child: Text(
                  _isSendingRequest ? 'Enviando solicitud...' : 'Solicitar información',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _safeText(String? value, String fallback) {
    return value?.isNotEmpty == true ? value! : fallback;
  }

  String _formatPrice(dynamic value) {
    final num? parsedPrice = value is num ? value : num.tryParse(value.toString());

    if (parsedPrice == null) {
      return 'No especificado';
    }

    return '${parsedPrice.toStringAsFixed(0)} €';
  }

  Future<void> _onRequestInfoPressed() async {
    final String? message = await showDialog<String>(
      context: context,
      builder: (_) => const _RequestMessageDialog(),
    );

    if (message == null) {
      return;
    }

    final String? propertyId = widget.property['id']?.toString();
    final String? ownerId = widget.property['owner_id']?.toString();

    if (propertyId == null || propertyId.isEmpty || ownerId == null || ownerId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo enviar la solicitud por falta de datos de la vivienda.'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud enviada con éxito.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo enviar la solicitud: $error')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSendingRequest = false;
      });
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
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
