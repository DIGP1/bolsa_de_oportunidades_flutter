import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/aplicacion_model.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/proyects_model.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:flutter/material.dart';

class VistaProyecto extends StatefulWidget {
  final ProyectsModel proyectsModel;
  final User user;
  const VistaProyecto({Key? key, required this.proyectsModel, required this.user}) : super(key: key);

  @override
  State<VistaProyecto> createState() => _VistaProyectoState();
}

class _VistaProyectoState extends State<VistaProyecto> {
  Api_Request api_request = Api_Request();
  var _color_button = const Color(0xFF9C241C);
  var _text_button = "Aplicar ahora";
  bool _action_button = true;
  List<AplicacionModel> list_aplicaciones_estudiante = [];
  AplicacionModel? aplicacionExistente;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarAplicacion();
  }
  @override
  void dispose() {
   super.dispose();
  }
  

  Future<void> verificarAplicacion() async {
    list_aplicaciones_estudiante = await api_request.getAplicacionStudent(widget.user.token, widget.user.id_user);
    bool existe = list_aplicaciones_estudiante.any((element) {
      if (element.idProyecto == widget.proyectsModel.id) {
      aplicacionExistente = element;
      return true;
      }
      return false;
    });
    if (existe && aplicacionExistente != null) {
      setState(() {
      _color_button = Colors.green;
      _text_button = "Aplicación enviada";
      _action_button = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF9C241C),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.proyectsModel.titulo, //Carga de titulo del proyecto
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF9C241C),
                      const Color(0xFF9C241C).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: const Icon(
                            // Reemplazamos Image.asset por un Icon
                            Icons.business,
                            size: 40,
                            color: Color(0xFF9C241C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    title: 'Información del Proyecto',
                    children: [
                      _buildInfoRow(
                          Icons.business, 'Empresa:', widget.proyectsModel.nombre_empresa), //Carga de empresa del proyecto
                      _buildInfoRow(
                        Icons.location_on,
                        'Ubicación:',
                        widget.proyectsModel.ubicacion, //Carga de ubicacion del proyecto
                      ),
                      _buildInfoRow(Icons.access_time, 'Duración:', widget.proyectsModel.fecha_inicio + ' hasta ' + widget.proyectsModel.fecha_fin), //Carga de fecha de inicio y fin del proyecto
                      _buildInfoRow(
                        Icons.paste_rounded,
                        'Tipo de proyecto:',
                        widget.proyectsModel.tipo_proyecto, //Carga de modalidad del proyecto
                      ),
                      _buildInfoRow(
                        Icons.work,
                        'Modalidad:',
                        widget.proyectsModel.modalidad, //Carga de modalidad del proyecto
                      ),
                      ...[
                        if(widget.proyectsModel.cupos_disponibles == 1) 
                          _buildInfoRow(Icons.group, 'Cupos:', '${widget.proyectsModel.cupos_disponibles} disponible')
                        else 
                          _buildInfoRow(Icons.group, 'Cupos:', '${widget.proyectsModel.cupos_disponibles} disponibles')
                      ]
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Estado y fechas
                  _buildStatusSection(),

                  const SizedBox(height: 24),

                  // Descripción
                  _buildDescriptionSection(),

                  const SizedBox(height: 24),

                  // Requisitos
                  _buildRequirementsSection(),


                  const SizedBox(height: 32),

                  // Botón de aplicar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async{
                        if(_action_button){
                          AplicacionModel aplicacionModel = AplicacionModel(
                            id: 0,
                            idEstudiante: widget.user.id_user,
                            idProyecto: widget.proyectsModel.id,
                            idEstadoAplicacion: 1,
                            comentariosEmpresa: '',
                          );
                          if(await api_request.applyProyect(aplicacionModel, widget.user.token, context)){
                            setState(() {
                              _color_button = Colors.green;
                              _text_button = "Aplicación enviada";
                              _action_button = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Aplicación enviada correctamente'),
                                backgroundColor: Colors.green,
                              ),
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al enviar la aplicación'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }else{
                            showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                              title: const Text('Eliminar Aplicación'),
                              content: const Text('Ya has aplicado a este proyecto. ¿Realmente deseas eliminar tu aplicación?'),
                              actions: [
                                TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  
                                },
                                child: const Text('No'),
                                ),
                                TextButton(
                                onPressed: () async{
                                  bool flag = await api_request.deleteAplicacion(aplicacionExistente!.id, widget.user.token);
                                    setState(() {
                                      if(flag){
                                        _action_button = true;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Aplicación eliminada correctamente'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );}
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Error al eliminar la aplicación'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      _color_button = const Color(0xFF9C241C);
                                      _text_button = "Aplicar ahora";
                                      _action_button = true;
                                      Navigator.of(context).pop();
                                    });
                                    
                                },
                                child: const Text('Sí'),
                                ),
                              ],
                              );
                            },
                            );
                        }
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _color_button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _text_button,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF9C241C)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado y Fechas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.proyectsModel.estado_oferta, //Carga de estado del proyecto
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Inicio:',
              widget.proyectsModel.fecha_inicio, //Carga de fecha de inicio del proyecto
            ),
            _buildInfoRow(
              Icons.event,
              'Finalización:',
              widget.proyectsModel.fecha_fin, //Carga de fecha de fin del proyecto
            ),
            _buildInfoRow(
              Icons.timer,
              'Límite para aplicar:',
              widget.proyectsModel.fecha_limite, //Carga de fecha límite para aplicar al proyecto
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.proyectsModel.descripcion, //Carga de descripción del proyecto
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Requisitos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (var req in widget.proyectsModel.requisitos) _buildRequirementItem(req),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF9C241C), size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  /*Widget _buildSkillsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habilidades Requeridas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSkillChip('Flutter'),
                _buildSkillChip('Dart'),
                _buildSkillChip('Git'),
                _buildSkillChip('Firebase'),
                _buildSkillChip('REST APIs'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF9C241C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9C241C).withOpacity(0.2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF9C241C),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  */
}