import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/carreras.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user_register.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  Api_Request api = Api_Request();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  int _idCarreraSeleccionada = 0;
  List<Carreras> listaCarreras = [];
  bool _isLoading = true; // Bandera para mostrar un indicador de carga
  String? _anioCarrera;

  //Controladores de TextFields
  TextEditingController? _nombresController;
  TextEditingController? _apellidosController;
  TextEditingController? _correoController;
  TextEditingController? _telefonoController;
  TextEditingController? _direccionController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _nombresController = TextEditingController();
    _apellidosController = TextEditingController();
    _correoController = TextEditingController();
    _telefonoController = TextEditingController();
    _direccionController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _fetchCarreras();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _nombresController!.dispose();
    _apellidosController!.dispose();
    _correoController!.dispose();
    _telefonoController!.dispose();
    _direccionController!.dispose();
    _passwordController!.dispose();
    _confirmPasswordController!.dispose();
    super.dispose();
  }



  Future<void> _fetchCarreras() async {
    try {
      List<Carreras> carreras = await api.getCarreras();
      setState(() {
        listaCarreras = carreras;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las carreras: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : 
      SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BOTÓN DE REGRESAR 
                    Padding(
                      padding: const EdgeInsets.only(top: 2), 
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF9C241C),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    
                    const SizedBox(width: 50),
                    
                    //LOGO UES
                    Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 202, 39, 39).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.asset('assets/ues.jpeg'),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Center(
                  child: Text(
                    'Registro de usuario',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C241C),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Center(
                  child: Text(
                    'Completa tus datos para registrarte',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Formulario
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nombres
                      TextFormField(
                        controller: _nombresController,
                        decoration: _buildInputDecoration(
                            'Nombres', Icons.person_outline),
                        validator: (value) => value!.isEmpty
                            ? 'Por favor ingresa tus nombres'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Apellidos
                      TextFormField(
                        controller: _apellidosController,
                        decoration: _buildInputDecoration(
                            'Apellidos', Icons.person_outline),
                        validator: (value) => value!.isEmpty
                            ? 'Por favor ingresa tus apellidos'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      // Correo electrónico
                      TextFormField(
                        controller: _correoController,
                        decoration: _buildInputDecoration(
                          'Correo electrónico', 
                          Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          // Expresión regular para validar el formato LLNNNNN@ues.edu.sv
                          final regex = RegExp(r'^[a-zA-Z]{2}\d{5}@ues\.edu\.sv$');

                          if (!regex.hasMatch(value)) {
                            return 'Ingresa un correo en el formato LLNNNNN@ues.edu.sv';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Teléfono
                      TextFormField(
                        controller: _telefonoController,
                        keyboardType: TextInputType.phone, 
                        decoration: _buildInputDecoration(
                          'Teléfono',
                          Icons.phone_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu número de teléfono';
                          }
                          final regex = RegExp(r'^\d{8}$');
                          if (!regex.hasMatch(value)) {
                            return 'Ingresa un número de teléfono válido de 8 dígitos';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //Direccion
                      TextFormField(
                        controller: _direccionController,
                        decoration: _buildInputDecoration(
                            'Direccion', Icons.location_on_outlined),
                        validator: (value) => value!.isEmpty
                            ? 'Por favor ingresa tu direccion'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      //Carrera
                      DropdownButtonFormField<Carreras>(
                      decoration: _buildInputDecoration('Carrera', Icons.school_outlined),
                        items: listaCarreras.map<DropdownMenuItem<Carreras>>((Carreras value){
                          return DropdownMenuItem<Carreras>(value: value, child: Text(value.nombre_carrera!));
                        }).toList(),
                        validator: (value){
                          if (value == null) {
                            return "Por favor, selecciona una opcion";
                          }
                          return null;
                        },
                        onChanged: (value){
                          setState(() {
                            _idCarreraSeleccionada = value!.id!;
                          });
                        }),
                        const SizedBox(height: 10),

                        //Año de estudio
                        DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration("Año de estudio", Icons.date_range_outlined),
                          items: <String>["1", "2","3","4","5"].map<DropdownMenuItem<String>>((String value){
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return "Por favor, selecciona una opcion";
                            }
                            return null;
                          },
                          onChanged: (value){
                            setState(() {
                              _anioCarrera = value;
                            });
                          }),
                          const SizedBox(height: 10),
                      // Contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: _buildInputDecoration(
                          'Contraseña',
                          Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa una contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirmar Contraseña
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: _buildInputDecoration(
                          'Confirmar Contraseña',
                          Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(() =>
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor confirma tu contraseña';
                          }
                          // Aquí deberías comparar con la contraseña original
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),

                      // Términos y condiciones
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) =>
                                setState(() => _acceptTerms = value!),
                            activeColor: const Color(0xFF9C241C),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _acceptTerms = !_acceptTerms),
                              child: Text(
                                'Acepto los términos y condiciones',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Botón de registro
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _acceptTerms
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    User_register user_register = User_register(
                                      email: _correoController!.text.toLowerCase(), //Se pasa el correo a minusculas para que no haya problemas en el inicio de sesión
                                      password: _passwordController!.text,
                                      estadoUsuario: true,
                                      fechaRegistro: DateTime.now().toString(),
                                      nombres: _nombresController!.text,
                                      apellidos: _apellidosController!.text,
                                      telefono: _telefonoController!.text,
                                      idCarrera: _idCarreraSeleccionada,
                                      carnet: _correoController!.text.substring(0, 7),
                                      anioEstudio: int.parse(_anioCarrera!),
                                      direccion: _direccionController!.text,
                                      tokenRecuperacion: '',
                                      tokenExpiracion: '',
                                      idTipoUsuario: 3,
                                    );
                                    api.registerUser(user_register).then((value) {
                                      if (value) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Usuario registrado correctamente'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    }).catchError((e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error al registrar el usuario: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C241C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Enlace para iniciar sesión
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes una cuenta?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Inicia Sesión',
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

  
  InputDecoration _buildInputDecoration(String label, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: const Color(0xFF9C241C)),
      suffixIcon: suffixIcon,
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
    );
  }
}
