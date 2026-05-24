import 'package:flutter/material.dart';

import '../../../data/services/property_service.dart';

class GuestRequestsView extends StatefulWidget {
  const GuestRequestsView({super.key});

  @override
  State<GuestRequestsView> createState() => _GuestRequestsViewState();
}

class _GuestRequestsViewState extends State<GuestRequestsView> {
  late final Future<List<Map<String, dynamic>>> _requestsFuture;
  final PropertyService _propertyService = PropertyService();

  @override
  void initState() {
    super.initState();
    _requestsFuture = _propertyService.getGuestRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Mis solicitudes'), centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No se pudieron cargar tus solicitudes.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final List<Map<String, dynamic>> requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Aún no has enviado solicitudes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final Map<String, dynamic> request = requests[index];
              final Map<String, dynamic>? property =
                  request['properties'] is Map<String, dynamic>
                  ? request['properties'] as Map<String, dynamic>
                  : null;

              final String message = (request['message'] as String?)?.trim().isNotEmpty == true
                  ? request['message'] as String
                  : 'Sin mensaje';
              final String status = (request['status'] as String?) ?? 'pendiente';
              final String propertyTitle =
                  (property?['title'] as String?) ?? 'Vivienda sin título';
              final String propertyCity = (property?['city'] as String?) ?? '';
              final String? createdAt = request['created_at'] as String?;

              return Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        propertyTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (propertyCity.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            propertyCity,
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
                        crossAxisAlignment: WrapCrossAlignment.center,
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
                              'Enviada: ${_formatDate(createdAt)}',
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
    return '$day/$month/$year';
  }
}
