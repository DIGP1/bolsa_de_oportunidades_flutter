import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

  final prefs = await SharedPreferences.getInstance();
  final List<String> notifications = prefs.getStringList('notifications') ?? [];
  notifications.add(message.notification?.body ?? 'Sin contenido');
  prefs.setStringList('notifications', notifications);

  // Muestra la notificación en segundo plano
  await _showNotification(
    message.notification?.title ?? 'Sin título',
    message.notification?.body ?? 'Sin contenido',
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel', // ID único del canal
    'Notificaciones', // Nombre del canal
    channelDescription: 'Canal de notificaciones importantes',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // ID de la notificación
    title, // Título
    body, // Cuerpo
    platformChannelSpecifics,
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // Inicialización de FlutterLocalNotifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await _firebaseMessaging.subscribeToTopic('all');
    print('Dispositivo suscrito al tema "all"');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Payload: ${message.data}');

      _saveNotification(message.notification?.body ?? 'Sin contenido');

      // Muestra la notificación en primer plano
      await _showNotification(
        message.notification?.title ?? 'Sin título',
        message.notification?.body ?? 'Sin contenido',
      );
    });
  }

  Future<void> _saveNotification(String notificationBody) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList('notifications') ?? [];
    notifications.add(notificationBody);
    prefs.setStringList('notifications', notifications);
  }
}
