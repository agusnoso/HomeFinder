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

  Future<Map<String, String>> signIn({
    required String email,
    required String password,
  }) async {
    final AuthResponse response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final User? authenticatedUser = response.user ?? _client.auth.currentUser;

    if (authenticatedUser == null) {
      throw AuthException('No se pudo obtener el usuario autenticado.');
    }

    final dynamic profileResponse = await _client
        .from('profiles')
        .select('username, email, role')
        .eq('id', authenticatedUser.id)
        .maybeSingle();

    if (profileResponse == null) {
      throw AuthException('No se encontró el perfil del usuario.');
    }

    final Map<String, dynamic> profile = profileResponse as Map<String, dynamic>;

    final String username = (profile['username'] as String?)?.trim() ?? '';
    final String profileEmail = (profile['email'] as String?)?.trim() ?? '';
    final String role = (profile['role'] as String?)?.trim() ?? '';

    if (username.isEmpty || profileEmail.isEmpty || role.isEmpty) {
      throw AuthException('El perfil del usuario está incompleto.');
    }

    return {'username': username, 'email': profileEmail, 'role': role};
  }
}
