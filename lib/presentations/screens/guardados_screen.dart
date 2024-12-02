import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/aplicacion_model.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/proyects_model.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/vista_proyecto.dart';
import 'package:flutter/material.dart';

class SavedJobsScreen extends StatefulWidget {
  final User user;
  const SavedJobsScreen({super.key, required this.user});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  Api_Request api = Api_Request();
  List<ProyectsModel> proyects = [];
  List<AplicacionModel> aplicaciones = [];
  bool _isLoading = true;
  bool _isEmpy = true;
  bool _inProyect = false;
  User? user;

  @override
  void initState() {
    super.initState();
    _checkStateProyects();
    

  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkStateProyects();
  }

   Future<void> _loadProyectsAplicaciones() async {
    setState(() {
      _isLoading = true;
    });
    proyects = await api.getProyects(widget.user.token);
    aplicaciones = await api.getAplicacionStudent(widget.user.token, widget.user.id_user);
    print("Aplicaciones: ${_inProyect}");
    if (_inProyect) {
      Set<int> appliedProjectIds = aplicaciones.map((a) => a.idProyecto).toSet();
      proyects = proyects.where((p) => appliedProjectIds.contains(p.id)).toList();
      
    } else {
      proyects = proyects.where((p) => p.id == user!.id_proyecto).toList();
    }
    _isEmpy = proyects.isEmpty;
    setState(() {
      _isLoading = false;
    });
  }
  Future<void> _checkStateProyects() async{
    user = await Api_Request().loginUserOpened(widget.user.token, widget.user.id_user);
    _inProyect = user!.id_proyecto == 0;
    _loadProyectsAplicaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _isEmpy
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.work_off, size: 100, color: Color(0xFF9C241C)),
                            const Text(
                              'No has aplicado a ningún proyecto',
                              style: TextStyle(color: Color(0xFF9C241C), fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                  _checkStateProyects();
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xFF9C241C)),
                              ),
                              child: const Text(
                                "Actualizar Proyectos",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      : _inProyect
                          ? RefreshIndicator(
                              onRefresh: _loadProyectsAplicaciones,
                              child: _buildRecentJobs(),
                            )
                          : Column(
                              children: [
                                const Text(
                                  'Proyecto en el que estás aplicado',
                                  style: TextStyle(
                                    color: Color(0xFF9C241C),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: _loadProyectsAplicaciones,
                                    child: _buildRecentJobs(),
                                  ),
                                ),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9C241C), Color(0xFFBF2E24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trabajos Aplicados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tus oportunidades en las que has intentado aplicar',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJobs() {
    return ListView.builder(
      itemCount: proyects.length,
      itemBuilder: (context, index) {
        ProyectsModel proyect = proyects[index];
        return GestureDetector(
          onTap: () async {
            var response = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VistaProyecto(proyectsModel: proyect, user: user!),
              ),
            );
            if (response == null) {
              setState(() {
                _isLoading = true;
                _checkStateProyects();
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C241C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: proyect.tipo_proyecto == 'Servicio Social'
                      ? const Icon(Icons.query_builder_sharp, color: Color(0xFF9C241C))
                      : proyect.tipo_proyecto == 'Pasantía'
                          ? const Icon(Icons.work, color: Color(0xFF9C241C))
                          : const SizedBox(),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proyect.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.business_outlined,
                            size: 16,
                            color: Color(0xFF9C241C),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              proyect.nombre_empresa,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 155, 151, 151),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF9C241C),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              proyect.ubicacion,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 155, 151, 151),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTag(proyect.tipo_proyecto),
                          const SizedBox(width: 8),
                          _buildTag(proyect.modalidad),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF9C241C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF9C241C),
          fontSize: 12,
        ),
      ),
    );
  }
}