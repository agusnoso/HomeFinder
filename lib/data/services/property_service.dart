import 'package:supabase_flutter/supabase_flutter.dart';

class PropertyService {
  PropertyService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<void> createProperty({
    required String title,
    required String description,
    required String address,
    required String city,
    required double price,
    required String operationType,
    required String propertyType,
  }) async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException('Debes iniciar sesión para publicar una vivienda.');
    }

    await _client.from('properties').insert({
      'owner_id': currentUser.id,
      'title': title,
      'description': description,
      'address': address,
      'city': city,
      'price': price,
      'operation_type': operationType,
      'property_type': propertyType,
    });
  }

  Future<List<Map<String, dynamic>>> getMyProperties() async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException('Debes iniciar sesión para ver tus viviendas.');
    }

    final List<dynamic> response = await _client
        .from('properties')
        .select()
        .eq('owner_id', currentUser.id)
        .order('created_at', ascending: false);

    return response
        .map((property) => Map<String, dynamic>.from(property as Map))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAvailableProperties() async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException(
        'Debes iniciar sesión para ver las viviendas disponibles.',
      );
    }

    final List<dynamic> response = await _client
        .from('properties')
        .select(
          'id, owner_id, title, description, city, price, operation_type, property_type',
        )
        .order('created_at', ascending: false);

    return response
        .map((property) => Map<String, dynamic>.from(property as Map))
        .toList();
  }

  Future<void> createPropertyRequest({
    required String propertyId,
    required String ownerId,
    required String message,
  }) async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException('Debes iniciar sesión para enviar una solicitud.');
    }

    await _client.from('property_requests').insert({
      'property_id': propertyId,
      'guest_id': currentUser.id,
      'owner_id': ownerId,
      'message': message,
      'status': 'pendiente',
    });
  }

  Future<void> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException('Debes iniciar sesión para actualizar solicitudes.');
    }

    if (status != 'aceptada' && status != 'rechazada') {
      throw ArgumentError('Estado inválido. Usa "aceptada" o "rechazada".');
    }

    await _client
        .from('property_requests')
        .update({'status': status})
        .eq('id', requestId);
  }

  Future<List<Map<String, dynamic>>> getOwnerRequests() async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException('Debes iniciar sesión para ver tus solicitudes.');
    }

    final List<dynamic> response = await _client
        .from('property_requests')
        .select('id, property_id, guest_id, owner_id, message, status, created_at, properties(title, city, price)')
        .eq('owner_id', currentUser.id)
        .order('created_at', ascending: false);

    return response
        .map((request) => Map<String, dynamic>.from(request as Map))
        .toList();
  }
}
