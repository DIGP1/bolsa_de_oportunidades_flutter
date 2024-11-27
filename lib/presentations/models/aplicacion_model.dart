class AplicacionModel {
  int id;
  final int idEstudiante;
  final int idProyecto;
  final int idEstadoAplicacion;
  final String comentariosEmpresa;

  AplicacionModel({
    required this.id,
    required this.idEstudiante,
    required this.idProyecto,
    required this.idEstadoAplicacion,
    required this.comentariosEmpresa,
  });

  factory AplicacionModel.fromJson(Map<String, dynamic> json) {
    return AplicacionModel(
      id: json['id'],
      idEstudiante: json['id_estudiante'],
      idProyecto: json['id_proyecto'],
      idEstadoAplicacion: json['id_estado_aplicacion'],
      comentariosEmpresa: json['comentarios_empresa'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_estudiante': idEstudiante,
      'id_proyecto': idProyecto,
      'id_estado_aplicacion': idEstadoAplicacion,
      'comentarios_empresa': comentariosEmpresa,
    };
  }
}