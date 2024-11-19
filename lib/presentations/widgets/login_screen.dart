// lib/presentations/screens/login_screen.dart
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

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
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), //color de fondo
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/ues.jpeg'      // Ruta de imagen
                    ),
                  ),
                ),
                const SizedBox(height: 5),
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
                Text(
                  'Inicia sesión para encontrar tu oportunidad ideal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
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
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(color: Colors.grey[600]!),
                          hintText: 'ejemplo@correo.com',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF9C241C)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF5D0C8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF5D0C8)),
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
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Colors.grey[600]!),
                          hintText: 'Ingresa tu contraseña',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9C241C)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
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
                            borderSide: const BorderSide(color: Color(0xFFF5D0C8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF5D0C8)),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;
                                    });
                                  },
                                  activeColor: const Color(0xFF9C241C),
                                ),
                                const Text('Recordarme'),
                              ],
                            ),
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                // Implementar recuperación de contraseña
                              },
                              child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Color(0xFF9C241C))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Botón de inicio de sesión
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Implementar lógica de inicio de sesión
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
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
                              color: Colors.white
                            ),
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
                              'O continúa con',
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
                      // Botones de redes sociales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _socialButton(
                            icon: Icons.g_mobiledata,
                            color: const Color(0xFF9C241C),  // Pasa el color aquí
                            onPressed: () {
                              // Implementar inicio de sesión con Google
                            },
                          ),
                          _socialButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF9C241C),  // Pasa el color aquí
                            onPressed: () {
                              // Implementar inicio de sesión con Facebook
                            },
                          ),
                          _socialButton(
                            icon: Icons.apple,
                            color: const Color(0xFF9C241C),
                            onPressed: () {
                              // Implementar inicio de sesión con Apple
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Enlace para registro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes una cuenta?',
                            style: TextStyle(color: Color.fromRGBO(117, 117, 117, 1)),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navegar a la pantalla de registro
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9C241C)),
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

  Widget _socialButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF9C241C)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }
}