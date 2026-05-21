import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    final AuthResponse response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final User? createdUser = response.user ?? response.session?.user;

    if (createdUser == null) {
      throw AuthException(
        'No se pudo obtener el usuario creado. Revisa la configuración de confirmación por correo.',
      );
    }

    await _client.from('profiles').insert({
      'id': createdUser.id,
      'username': username,
      'email': email,
      'role': role,
    });
  }
}
