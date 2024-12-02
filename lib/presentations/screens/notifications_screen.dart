import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // Cargar las notificaciones desde SharedPreferences
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  // Limpiar las notificaciones en SharedPreferences
  Future<void> _clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    setState(() {
      notifications.clear(); // Actualizar la vista
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFF9C241C),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No hay notificaciones para mostrar',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index]),
                );
              },
            ),
      // Botón flotante para limpiar las notificaciones
      floatingActionButton: FloatingActionButton(
        onPressed: _clearNotifications,
        backgroundColor: const Color(0xFF9C241C),
        child: const Icon(Icons.delete),
      ),
    );
  }
}
