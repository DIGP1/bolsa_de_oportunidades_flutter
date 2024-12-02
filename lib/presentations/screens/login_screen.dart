// lib/presentations/screens/login_screen.dart
import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user_login.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/home.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/registro_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/recuperation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final bool _rememberMe = false;
  final Api_Request _apiRequest = Api_Request();
  User_login? _user_login;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Logo o imagen de la app
                Center(
                  child: Container(
                    height: 175,
                    width: 275,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), //color de fondo
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset('assets/logo.png' // Ruta de imagen
                        ),
                  ),
                ),
                const SizedBox(height: 3),
                const Center(
                  child: Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      /*color: Colors.black87,*/
                      color: Color(0xFF9C241C), //color de texto
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Center(
                  child: Text(
                    'Inicia sesión para encontrar tu oportunidad ideal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Formulario
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo de correo
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(color: Colors.grey[600]!),
                          hintText: 'ejemplo@correo.com',
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFF9C241C)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFF5D0C8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFF5D0C8)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          if (!value.contains('@')) {
                            return 'Por favor ingresa un correo válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Campo de contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Colors.grey[600]!),
                          hintText: 'Ingresa tu contraseña',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Color(0xFF9C241C)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () async {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFF5D0C8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFF5D0C8)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Recordar contraseña y Olvidé mi contraseña
                     
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String correo1 = _emailController!.text
                                  .substring(0, 7)
                                  .toUpperCase();
                              String correo2 = _emailController!.text
                                  .substring(7)
                                  .toLowerCase();
                              _user_login = User_login(
                                  email: correo1 + correo2,
                                  password: _passwordController!.text);
                              _user = await _apiRequest.loginUser(
                                  _user_login!, context);
                              if (_user != null) {
                                if (_user!.id_tipo_user == 3) {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final prefs2 =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'user_token', _user!.token);
                                      await prefs2.setInt('user_id', _user!.id_user);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Inicio de sesión exitoso",
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.linear(1.5),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 31, 145, 35),
                                    ),
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(user: _user!),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Usuario no autorizado",
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.linear(1.5),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 145, 31, 31),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C241C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Otros métodos de inicio de sesión
                      Row(
                        children: [
                          Expanded(
                            child:
                                Divider(color: Colors.grey[300], thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(
                            child:
                                Divider(color: Colors.grey[300], thickness: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes una cuenta?',
                            style: TextStyle(
                                color: Color.fromRGBO(117, 117, 117, 1)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9C241C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
