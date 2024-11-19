// lib/main.dart
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/home.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/widgets/login_screen.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/widgets/registro_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
      /*home: const LoginScreen(), // O MainScreen() si quieres saltarte el login*/
      /*home: const HomeScreen(),*/
      home: const RegisterScreen(),
    );
  }
}
