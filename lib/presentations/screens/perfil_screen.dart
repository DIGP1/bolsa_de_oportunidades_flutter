import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildProfileContent(),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildHeader() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF9C241C), Color(0xFFBF2E24)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 35,
              color: Color(0xFF9C241C),
            ),
          ),
        ),
        const SizedBox(height: 3),
        
        const Text(
          'Nombre del Usuario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 3,
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3), 
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), 
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.email,
                size: 14, 
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 3),
              Text(
                'usuario@email.com',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 1), 
      ],
    ),
  );
}
}

  Widget _buildProfileContent() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _buildSection('Información Personal', [
          _buildListTile(Icons.person_outline, 'Editar Perfil'),
        ]),
        const SizedBox(height: 15),
        _buildSection('Configuración', [
          _buildListTile(Icons.notifications_outlined, 'Notificaciones'),
          _buildListTile(Icons.lock_outline, 'Privacidad'),
          _buildListTile(Icons.help_outline, 'Ayuda'),
        ]),
        const SizedBox(height: 15),
        _buildSection('Cuenta', [
          _buildListTile(Icons.logout, 'Cerrar Sesión', color: Colors.red),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C241C),
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF9C241C)),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Manejar la navegación o la acción
      },
    );
  }
