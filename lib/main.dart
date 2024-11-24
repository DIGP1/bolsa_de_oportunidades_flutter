import 'package:bolsa_de_oportunidades_flutter/presentations/screens/home.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/login_screen.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/vista_proyecto.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolsa de Oportunidades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF9C241C),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(), 
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/vista_proyecto':
            return MaterialPageRoute(
              builder: (context) => const VistaProyecto(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
        }
      },
    );
  }
}