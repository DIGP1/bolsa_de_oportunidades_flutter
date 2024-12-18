import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/carreras.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user_info_edit.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final User_Info_Edit userinfo;
  const EditProfileScreen({super.key, required this.user, required this.userinfo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Api_Request api = Api_Request();
  int _idCarreraSeleccionada = 0;
  String? _anioCarrera;
  List<Carreras> listaCarreras = [];
  Carreras? _carreraSeleccionada;
  bool _isLoading = true;

  TextEditingController? _telefonoController;
  TextEditingController? _direccionController;

  @override
  void initState() {
    super.initState();
    _telefonoController = TextEditingController();
    _direccionController = TextEditingController();
    _telefonoController!.text = widget.userinfo.telefono;
    _direccionController!.text = widget.userinfo.direccion;
    _fetchCarreras();
    _anioCarrera = widget.userinfo.anio_estudio.toString();
  }

  @override
  void dispose() {
    _direccionController!.dispose();
    _telefonoController!.dispose();
    super.dispose();
  }

  Future<void> _fetchCarreras() async {
    try {
      List<Carreras> carreras = await api.getCarreras();
      setState(() {
        listaCarreras = carreras;
        _carreraSeleccionada = listaCarreras.firstWhere(
          (carrera) => carrera.id == widget.userinfo.id_carrera,
          orElse: () => Carreras(),
        );
        _idCarreraSeleccionada = _carreraSeleccionada!.id!;
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9C241C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            color: Color(0xFF9C241C),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header con foto de perfil
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF9C241C),
                                        width: 3,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 65,
                                      color: Color(0xFF9C241C),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${widget.userinfo.nombres} ${widget.userinfo.apellidos}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const Text(
                                    'Estudiante',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            _buildSectionTitle('Información Personal'),
                            const SizedBox(height: 10),
                            _buildNonEditableField(
                              'Nombres',
                              widget.userinfo.nombres,
                              Icons.person_outline,
                            ),
                            const SizedBox(height: 10),
                            _buildNonEditableField(
                              'Apellidos',
                              widget.userinfo.apellidos,
                              Icons.person_outline,
                            ),
                            const SizedBox(height: 10),
                            _buildNonEditableField(
                              'Correo',
                              widget.userinfo.email,
                              Icons.email_outlined,
                            ),
                            const SizedBox(height: 24),
                            
                            _buildSectionTitle('Información de Contacto'),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _telefonoController,
                              keyboardType: TextInputType.phone,
                              decoration: _buildInputDecoration(
                                'Teléfono',
                                Icons.phone_outlined,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _direccionController,
                              decoration: _buildInputDecoration(
                                'Dirección',
                                Icons.location_on_outlined,
                              ),
                              maxLines: null,
                              minLines: 2,
                            ),
                            const SizedBox(height: 16),

                            _buildSectionTitle('Información Académica'),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Carreras>(
                              isExpanded: true,
                              decoration: _buildInputDecoration('Carrera', Icons.school_outlined),
                              value: _carreraSeleccionada,
                              items: listaCarreras.map<DropdownMenuItem<Carreras>>((Carreras value) {
                                return DropdownMenuItem<Carreras>(
                                  value: value,
                                  child: Text(
                                    value.nombre_carrera!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return "Por favor, selecciona una opción";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _idCarreraSeleccionada = value!.id!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: _buildInputDecoration(
                                'Año de estudio',
                                Icons.date_range_outlined,
                              ),
                              value: _anioCarrera,
                              items: ['1', '2', '3', '4', '5'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value° Año'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _anioCarrera = value;
                                });
                              },
                            ),
                            const SizedBox(height: 30),

                            // Botón de guardar cambios
                            Container(
                              height: 55,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9C241C),
                                    Color(0xFFB62921),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF9C241C).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_telefonoController!.text.isNotEmpty && 
                                      _direccionController!.text.isNotEmpty) {
                                    User_Info_Edit request = widget.userinfo;
                                    request.anio_estudio = int.parse(_anioCarrera!);
                                    request.telefono = _telefonoController!.text;
                                    request.direccion = _direccionController!.text;
                                    request.id_carrera = _idCarreraSeleccionada;
                                    bool response = await api.editUserInfo(request, widget.user.token);
                                    if (response) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "¡Información editada con éxito!",
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Color.fromARGB(255, 31, 145, 35),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Error al editar la información",
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Guardar Cambios',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF9C241C),
      ),
    );
  }

  Widget _buildNonEditableField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5D0C8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF9C241C),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: const Color(0xFF9C241C)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF5D0C8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF5D0C8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF9C241C), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}