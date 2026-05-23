import 'package:flutter/material.dart';

import '../../../data/services/property_service.dart';

class OwnerRequestsView extends StatefulWidget {
  const OwnerRequestsView({super.key});

  @override
  State<OwnerRequestsView> createState() => _OwnerRequestsViewState();
}

class _OwnerRequestsViewState extends State<OwnerRequestsView> {
  final PropertyService _propertyService = PropertyService();
  late Future<List<Map<String, dynamic>>> _requestsFuture;
  final Set<String> _processingRequestIds = <String>{};

  @override
  void initState() {
    super.initState();
    _requestsFuture = _propertyService.getOwnerRequests();
  }

  void _reloadRequests() {
    setState(() {
      _requestsFuture = _propertyService.getOwnerRequests();
    });
  }

  Future<void> _handleStatusUpdate({
    required String requestId,
    required String status,
  }) async {
    setState(() {
      _processingRequestIds.add(requestId);
    });

    try {
      await _propertyService.updateRequestStatus(
        requestId: requestId,
        status: status,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'aceptada'
                ? 'Solicitud aceptada correctamente.'
                : 'Solicitud rechazada correctamente.',
          ),
        ),
      );
      _reloadRequests();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo actualizar la solicitud. $error'),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _processingRequestIds.remove(requestId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes recibidas'),
        centerTitle: true,
      ),
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
                  'No se pudieron cargar las solicitudes.\n${snapshot.error}',
                  textAlign: TextAlign.center,
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
                  'Aún no recibiste solicitudes para tus viviendas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  request['properties'] is Map
                  ? Map<String, dynamic>.from(request['properties'] as Map)
                  : null;

              final String requestId = (request['id'] ?? '').toString();
              final String message = (request['message'] ?? '').toString();
              final String status = (request['status'] ?? 'sin estado').toString();
              final String? createdAt = request['created_at']?.toString();
              final String title = (property?['title'] ?? 'Vivienda sin título')
                  .toString();
              final String city = (property?['city'] ?? '').toString();
              final bool isPending = status == 'pendiente';
              final bool isProcessing = _processingRequestIds.contains(requestId);

              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (city.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          city,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        message.isEmpty ? 'Sin mensaje.' : message,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Chip(
                            label: Text('Estado: $status'),
                            visualDensity: VisualDensity.compact,
                          ),
                          if (createdAt != null && createdAt.isNotEmpty)
                            Chip(
                              label: Text('Fecha: ${_formatDate(createdAt)}'),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                      if (isPending) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isProcessing
                                    ? null
                                    : () => _handleStatusUpdate(
                                        requestId: requestId,
                                        status: 'rechazada',
                                      ),
                                child: const Text('Rechazar'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isProcessing
                                    ? null
                                    : () => _handleStatusUpdate(
                                        requestId: requestId,
                                        status: 'aceptada',
                                      ),
                                child: const Text('Aceptar'),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  String _formatDate(String value) {
    final DateTime? parsedDate = DateTime.tryParse(value);
    if (parsedDate == null) {
      return value;
    }

    final DateTime localDate = parsedDate.toLocal();
    final String day = localDate.day.toString().padLeft(2, '0');
    final String month = localDate.month.toString().padLeft(2, '0');
    final String year = localDate.year.toString();
    final String hour = localDate.hour.toString().padLeft(2, '0');
    final String minute = localDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}
