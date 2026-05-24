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

  Future<List<Map<String, dynamic>>> getAvailableProperties({
    String? cityQuery,
  }) async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException(
        'Debes iniciar sesión para ver las viviendas disponibles.',
      );
    }

    final String queryText = cityQuery?.trim() ?? '';
    var query = _client.from('properties').select(
      'id, owner_id, title, description, address, city, price, operation_type, property_type',
    );

    if (queryText.isNotEmpty) {
      query = query.ilike('city', '%$queryText%');
    }

    final List<dynamic> response = await query.order(
      'created_at',
      ascending: false,
    );

    return response
        .map((property) => Map<String, dynamic>.from(property as Map))
        .toList();
  }

  Future<void> updateProperty({
    required String propertyId,
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
      throw AuthException('Debes iniciar sesión para editar una vivienda.');
    }

    await _client
        .from('properties')
        .update({
          'title': title,
          'description': description,
          'address': address,
          'city': city,
          'price': price,
          'operation_type': operationType,
          'property_type': propertyType,
        })
        .eq('id', propertyId)
        .eq('owner_id', currentUser.id);
  }

  Future<void> deleteProperty({required String propertyId}) async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException('Debes iniciar sesión para eliminar una vivienda.');
    }

    await _client
        .from('properties')
        .delete()
        .eq('id', propertyId)
        .eq('owner_id', currentUser.id);
  }


  Future<List<Map<String, dynamic>>> searchProperties({
    String? city,
    String? operationType,
    String? propertyType,
    double? maxPrice,
  }) async {
    final String cityQuery = city?.trim() ?? '';
    final String operationFilter = operationType?.trim().toLowerCase() ?? '';
    final String typeFilter = propertyType?.trim().toLowerCase() ?? '';

    var query = _client.from('properties').select(
      'id, owner_id, title, description, address, city, price, operation_type, property_type, created_at',
    );

    if (cityQuery.isNotEmpty) {
      query = query.ilike('city', '%$cityQuery%');
    }

    if (operationFilter.isNotEmpty && operationFilter != 'cualquiera') {
      query = query.eq('operation_type', operationFilter);
    }

    if (typeFilter.isNotEmpty && typeFilter != 'cualquiera') {
      query = query.eq('property_type', typeFilter);
    }

    if (maxPrice != null) {
      query = query.lte('price', maxPrice);
    }

    final List<dynamic> response = await query.order(
      'created_at',
      ascending: false,
    );

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


  Future<List<Map<String, dynamic>>> getGuestRequests() async {
    final User? currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw AuthException('Debes iniciar sesión para ver tus solicitudes.');
    }

    final List<dynamic> response = await _client
        .from('property_requests')
        .select(
          'id, property_id, guest_id, owner_id, message, status, created_at, properties(title, city, price)',
        )
        .eq('guest_id', currentUser.id)
        .order('created_at', ascending: false);

    return response
        .map((request) => Map<String, dynamic>.from(request as Map))
        .toList();
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
