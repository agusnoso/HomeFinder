import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/services/auth_service.dart';
import '../../providers/user_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await AuthService().signOut();
      if (!context.mounted) return;

      context.read<UserProvider>().clearUserData();

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (_) {
      if (!context.mounted) return;

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('No se pudo cerrar sesión. Inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final username = userProvider.username;
    final rolUsuario = userProvider.role;

    final bool esPropietario = rolUsuario == 'propietario';
    final bool esHuesped = rolUsuario == 'huesped';

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeFinder'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person),
            onSelected: (value) async {
              if (value == 'perfil') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil disponible próximamente'),
                  ),
                );
              }

              if (value == 'configuracion') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuración disponible próximamente'),
                  ),
                );
              }

              if (value == 'logout') {
                await _handleLogout(context);
              }
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: 'perfil',
                    child: Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(width: 8),
                        Text('Mi perfil'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'configuracion',
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8),
                        Text('Configuración'),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Cerrar sesión'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido${username.isNotEmpty ? ', $username' : ''}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              esPropietario ? 'Modo Propietario' : 'Modo Huesped',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            if (esPropietario) ...[
              _HomeOptionCard(
                icon: Icons.add_home,
                title: 'Publicar vivienda',
                subtitle: 'Añade una vivienda en alquiler o venta',
                onTap:
                    () => Navigator.pushNamed(context, '/owner/publish-property'),
              ),
              _HomeOptionCard(
                icon: Icons.home_work,
                title: 'Mis viviendas',
                subtitle: 'Consulta y gestiona tus inmuebles publicados',
                onTap:
                    () => Navigator.pushNamed(context, '/owner/my-properties'),
              ),
              _HomeOptionCard(
                icon: Icons.assignment,
                title: 'Solicitudes recibidas',
                subtitle: 'Revisa las solicitudes de los huéspedes',
                onTap:
                    () => Navigator.pushNamed(context, '/owner/requests'),
              ),
              _HomeOptionCard(
                icon: Icons.message,
                title: 'Mensajes',
                subtitle: 'Comunícate con los huéspedes interesados',
                onTap:
                    () => Navigator.pushNamed(context, '/owner/messages'),
              ),
            ],

            if (esHuesped) ...[
              _HomeOptionCard(
                icon: Icons.search,
                title: 'Buscar viviendas',
                subtitle: 'Encuentra viviendas disponibles',
                onTap:
                    () => Navigator.pushNamed(context, '/guest/search-properties'),
              ),
              _HomeOptionCard(
                icon: Icons.apartment,
                title: 'Viviendas disponibles',
                subtitle: 'Consulta inmuebles en alquiler o venta',
                onTap:
                    () => Navigator.pushNamed(context, '/guest/available-properties'),
              ),
              _HomeOptionCard(
                icon: Icons.list_alt,
                title: 'Mis solicitudes',
                subtitle: 'Revisa las solicitudes que has enviado',
                onTap:
                    () => Navigator.pushNamed(context, '/guest/requests'),
              ),
              _HomeOptionCard(
                icon: Icons.message,
                title: 'Mensajes',
                subtitle: 'Comunícate con propietarios',
                onTap:
                    () => Navigator.pushNamed(context, '/guest/messages'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: Icon(icon, size: 34, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
