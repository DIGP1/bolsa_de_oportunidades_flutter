import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/home.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/login_screen.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/vista_proyecto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //messaging
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {

    final prefs = await SharedPreferences.getInstance();
    final prefs2 = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    final idEstudiante = prefs2.getInt('user_id');
    
    if (token != null && token.isNotEmpty && idEstudiante != null) {
      User user = await Api_Request().loginUserOpened(token, idEstudiante);
      print("token: ${user.token}, id: ${user.id_user}");
      return HomeScreen(user: user); // Ajusta según tu modelo
    } else {
      // Si no hay token, mostrar LoginScreen
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolsa de Oportunidades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF9C241C),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("Error al cargar la app"),
              ),
            );
          }
          return snapshot.data ?? const LoginScreen();
        },
      ),
    );
  }
}