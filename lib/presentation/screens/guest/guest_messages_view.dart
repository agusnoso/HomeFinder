import 'package:flutter/material.dart';

import '../../../data/services/property_service.dart';
import '../../widgets/app_background.dart';

class GuestMessagesView extends StatefulWidget {
  const GuestMessagesView({super.key});

  @override
  State<GuestMessagesView> createState() => _GuestMessagesViewState();
}

class _GuestMessagesViewState extends State<GuestMessagesView> {
  final PropertyService _propertyService = PropertyService();
  late final Future<List<Map<String, dynamic>>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _propertyService.getGuestRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes'), centerTitle: true),
      body: AppBackground(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _messagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No se pudieron cargar tus mensajes.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final List<Map<String, dynamic>> messages = snapshot.data ?? [];

            if (messages.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Aún no tienes mensajes enviados en solicitudes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final Map<String, dynamic> request = messages[index];
                final Map<String, dynamic>? property =
                    request['properties'] is Map<String, dynamic>
                        ? request['properties'] as Map<String, dynamic>
                        : null;

                final String message =
                    (request['message'] as String?)?.trim().isNotEmpty == true
                        ? request['message'] as String
                        : 'Sin mensaje';
                final String status =
                    (request['status'] as String?) ?? 'pendiente';
                final String title =
                    (property?['title'] as String?) ?? 'Vivienda sin título';
                final String city = (property?['city'] as String?) ?? '';
                final String? createdAt = request['created_at'] as String?;

                return Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (city.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              city,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          'Mensaje: $message',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(status).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Estado: ${_normalizeStatus(status)}',
                                style: TextStyle(
                                  color: _statusColor(status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (createdAt != null)
                              Text(
                                'Fecha: ${_formatDate(createdAt)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
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
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'aceptada':
        return Colors.green;
      case 'rechazada':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _normalizeStatus(String status) {
    if (status.isEmpty) {
      return 'pendiente';
    }

    return status[0].toUpperCase() + status.substring(1);
  }

  String _formatDate(String rawDate) {
    final DateTime? date = DateTime.tryParse(rawDate)?.toLocal();

    if (date == null) {
      return rawDate;
    }

    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
