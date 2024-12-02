class ProyectsModel {
  final int id;
  final String nombre_empresa;
  final String titulo;
  final String descripcion;
  final List<String> requisitos; // Cambiar de String a List<String>
  final String estado_oferta;
  final String modalidad;
  final String fecha_inicio;
  final String fecha_limite;
  final String fecha_fin;
  final int estado_proyecto;
  final int cupos_disponibles;
  final String tipo_proyecto;
  final String ubicacion;
  final String nombre_carrera;

  ProyectsModel({
    required this.id,
    required this.nombre_empresa,
    required this.titulo,
    required this.descripcion,
    required this.requisitos,
    required this.estado_oferta,
    required this.modalidad,
    required this.fecha_inicio,
    required this.fecha_limite,
    required this.fecha_fin,
    required this.estado_proyecto,
    required this.cupos_disponibles,
    required this.tipo_proyecto,
    required this.ubicacion,
    required this.nombre_carrera,
  });

  factory ProyectsModel.fromJson(Map<String, dynamic> json) {
    return ProyectsModel(
      id: json['id_proyecto'],
      nombre_empresa: json['nombre_empresa'],
      titulo: json['titulo_proyecto'],
      descripcion: json['descripcion_proyeto'],
      requisitos: List<String>.from(json['requisitos_proyecto']), // Convertir lista JSON a List<String>
      estado_oferta: json['estado_oferta'],
      modalidad: json['modalidad'],
      fecha_inicio: json['fecha_inicio_proyecto'],
      fecha_limite: json['fecha_fin_proyecto'],
      fecha_fin: json['fecha_limite_aplicacion'],
      estado_proyecto: json['estado_proyecto'],
      cupos_disponibles: json['cupos_disponibles'],
      tipo_proyecto: json['tipo_proyecto'],
      ubicacion: json['ubicacion_proyecto'],
      nombre_carrera: json['nombre_carrera'],
    );
  }
}

