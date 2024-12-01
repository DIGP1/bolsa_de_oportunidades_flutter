import 'package:bolsa_de_oportunidades_flutter/presentations/api_request/api_request.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/proyects_model.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/models/user.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/guardados_screen.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/perfil_screen.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/vista_proyecto.dart';
import 'package:bolsa_de_oportunidades_flutter/presentations/screens/notifications_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeContent(user: widget.user),
          SavedJobsScreen(user: widget.user),
          ProfileScreen(user: widget.user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF9C241C),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Aplicados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}


class HomeContent extends StatefulWidget {
  final User user;
  const HomeContent({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Api_Request api = Api_Request();
  List<ProyectsModel> proyects = [];
  bool _isLoading = true;
  TextEditingController? _searchController;
  List<ProyectsModel> originalProyects = [];

  Future<void> _loadProyects() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<ProyectsModel> list_proyects =
          await api.getProyects(widget.user.token);
      list_proyects = list_proyects.reversed.toList();

      setState(() {
        proyects = list_proyects;
        originalProyects = list_proyects;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los proyectos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cargar los proyectos'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadProyects();
  }

  @override
  void dispose() {
    _searchController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadProyects,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          //_buildCategories(context),
                          _buildRecentJobs(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9C241C), Color(0xFFBF2E24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Encuentra tu oportunidad ideal',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF9C241C)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar propuesta...',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          proyects = originalProyects;
                        } else {
                          proyects = originalProyects.where((proyect) {
                            return proyect.titulo
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                        }
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Color(0xFF9C241C)),
                  onPressed: () {
                    // Aquí puedes manejar el tap en el botón de filtros
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecentJobs() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trabajos Recientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: proyects.length,
          itemBuilder: (context, index) {
            ProyectsModel proyect = proyects[index];
            return GestureDetector(
              onTap: () async {
                var response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VistaProyecto(
                        proyectsModel: proyect, user: widget.user),
                  ),
                );
                if (response == null) {
                  setState(() {
                    _isLoading = true;
                    _loadProyects();
                  });
                }
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          ? const Icon(Icons.query_builder_sharp,
                              color: Color(0xFF9C241C))
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
        ),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF9C241C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Color(0xFF9C241C),
          fontSize: 12,
        ),
      ),
    );
  }
}
