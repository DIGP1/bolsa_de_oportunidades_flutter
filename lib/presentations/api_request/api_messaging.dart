import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

  final prefs = await SharedPreferences.getInstance();
  final List<String> notifications = prefs.getStringList('notifications') ?? [];
  notifications.add(message.notification?.body ?? 'Sin contenido');
  prefs.setStringList('notifications', notifications);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    //final fCMToken = await _firebaseMessaging.getToken();
    //print('Token: $fCMToken');
    
    await _firebaseMessaging.subscribeToTopic('all');
    print('Dispositivo suscrito al tema "all"');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Payload: ${message.data}');

      _saveNotification(message.notification?.body ?? 'Sin contenido');
    });
  }

  Future<void> _saveNotification(String notificationBody) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList('notifications') ?? [];
    notifications.add(notificationBody);
    prefs.setStringList('notifications', notifications);
  }
}
