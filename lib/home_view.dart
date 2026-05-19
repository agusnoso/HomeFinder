import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Rol simulado de momento.
  // Más adelante este valor vendrá desde Supabase.
  final String rolUsuario = 'propietario';

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserProvider>().username;

    final bool esPropietario = rolUsuario == 'propietario';
    final bool esHuesped = rolUsuario == 'huesped';

    return Scaffold(
      appBar: AppBar(title: const Text('HomeFinder'), centerTitle: true),
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
              esPropietario ? 'Modo Propietario' : 'Modo Huésped',
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
                onTap: () {},
              ),
              _HomeOptionCard(
                icon: Icons.home_work,
                title: 'Mis viviendas',
                subtitle: 'Consulta y gestiona tus inmuebles publicados',
                onTap: () {},
              ),
              _HomeOptionCard(
                icon: Icons.assignment,
                title: 'Solicitudes recibidas',
                subtitle: 'Revisa las solicitudes de los huéspedes',
                onTap: () {},
              ),
              _HomeOptionCard(
                icon: Icons.message,
                title: 'Mensajes',
                subtitle: 'Comunícate con los huéspedes interesados',
                onTap: () {},
              ),
            ],

            if (esHuesped) ...[
              _HomeOptionCard(
                icon: Icons.search,
                title: 'Buscar viviendas',
                subtitle: 'Encuentra viviendas disponibles',
                onTap: () {},
              ),
              _HomeOptionCard(
                icon: Icons.apartment,
                title: 'Viviendas disponibles',
                subtitle: 'Consulta inmuebles en alquiler o venta',
                onTap: () {},
              ),
              _HomeOptionCard(
                icon: Icons.list_alt,
                title: 'Mis solicitudes',
                subtitle: 'Revisa las solicitudes que has enviado',
                onTap: () {},
              ),
              _HomeOptionCard(
                icon: Icons.message,
                title: 'Mensajes',
                subtitle: 'Comunícate con propietarios',
                onTap: () {},
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
