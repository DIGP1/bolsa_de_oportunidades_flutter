import 'package:flutter/material.dart';

class VistaProyecto extends StatelessWidget {
  const VistaProyecto({super.key});

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
              title: const Text(
                'Desarrollador Flutter Senior',
                style: TextStyle(fontSize: 16),
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
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share),
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
                          Icons.business, 'Empresa:', 'TechCorp Inc.'),
                      _buildInfoRow(
                        Icons.location_on,
                        'Ubicación:',
                        'Ciudad de Guatemala',
                      ),
                      _buildInfoRow(Icons.access_time, 'Duración:', '6 meses'),
                      _buildInfoRow(
                        Icons.work,
                        'Modalidad:',
                        'Tiempo completo',
                      ),
                      _buildInfoRow(Icons.group, 'Cupos:', '2 disponibles'),
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

                  const SizedBox(height: 24),

                  // Habilidades requeridas
                  _buildSkillsSection(),

                  const SizedBox(height: 32),

                  // Botón de aplicar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implementar lógica de aplicación
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C241C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Aplicar ahora',
                        style: TextStyle(
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
              child: const Text(
                'Abierto',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Inicio:',
              '01 Enero 2024',
            ),
            _buildInfoRow(
              Icons.event,
              'Finalización:',
              '30 Junio 2024',
            ),
            _buildInfoRow(
              Icons.timer,
              'Límite para aplicar:',
              '15 Diciembre 2023',
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
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descripción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Buscamos un desarrollador Flutter Senior para unirse a nuestro equipo de desarrollo móvil. El candidato ideal debe tener experiencia en el desarrollo de aplicaciones móviles multiplataforma y conocimientos sólidos en Flutter y Dart.\n\nSerá responsable de diseñar, desarrollar y mantener aplicaciones móviles de alta calidad, trabajando en estrecha colaboración con nuestro equipo de diseño y backend.',
              style: TextStyle(
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
            _buildRequirementItem(
                'Estudiante activo de Ingeniería en Sistemas'),
            _buildRequirementItem('Promedio mínimo de 75 puntos'),
            _buildRequirementItem('Disponibilidad de horario'),
            _buildRequirementItem('Capacidad de trabajo en equipo'),
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

  Widget _buildSkillsSection() {
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
}
