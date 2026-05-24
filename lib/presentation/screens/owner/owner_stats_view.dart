import 'package:flutter/material.dart';

import '../../../data/services/property_service.dart';

class OwnerStatsView extends StatefulWidget {
  const OwnerStatsView({super.key});

  @override
  State<OwnerStatsView> createState() => _OwnerStatsViewState();
}

class _OwnerStatsViewState extends State<OwnerStatsView> {
  final PropertyService _propertyService = PropertyService();
  late Future<Map<String, int>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _propertyService.getOwnerStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: FutureBuilder<Map<String, int>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No se pudieron cargar las estadísticas. Inténtalo de nuevo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            );
          }

          final stats = snapshot.data ?? <String, int>{};

          final cards = [
            _StatCardData(
              title: 'Viviendas publicadas',
              value: stats['totalProperties'] ?? 0,
              icon: Icons.home_work,
            ),
            _StatCardData(
              title: 'Solicitudes recibidas',
              value: stats['totalRequests'] ?? 0,
              icon: Icons.assignment,
            ),
            _StatCardData(
              title: 'Pendientes',
              value: stats['pendingRequests'] ?? 0,
              icon: Icons.hourglass_bottom,
            ),
            _StatCardData(
              title: 'Aceptadas',
              value: stats['acceptedRequests'] ?? 0,
              icon: Icons.check_circle,
            ),
            _StatCardData(
              title: 'Rechazadas',
              value: stats['rejectedRequests'] ?? 0,
              icon: Icons.cancel,
            ),
          ];

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 600
                  ? 2
                  : 1;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            card.icon,
                            size: 34,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${card.value}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _StatCardData {
  const _StatCardData({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final int value;
  final IconData icon;
}
