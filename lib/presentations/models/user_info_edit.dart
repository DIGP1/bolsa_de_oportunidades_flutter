class User_Info_Edit{
  final int id;
  final String email;
  final String nombres;
  final String apellidos;
  final String carnet;
  int anio_estudio;
  String telefono;
  String direccion;
  int id_carrera;
  final String nombre_carrera;
  final int id_departamento;
  final String nombre_departamento;

  User_Info_Edit({
    required this.id,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.carnet,
    required this.anio_estudio,
    required this.telefono,
    required this.direccion,
    required this.id_carrera,
    required this.nombre_carrera,
    required this.id_departamento,
    required this.nombre_departamento
  });

  factory User_Info_Edit.fromJson(Map<String, dynamic> json) {
    return User_Info_Edit(
      id: json['id'],
      email: json['email'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      carnet: json['carnet'],
      anio_estudio: json['anio_estudio'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      id_carrera: json['id_carrera'],
      nombre_carrera: json['nombre_carrera'],
      id_departamento: json['id_departamento'],
      nombre_departamento: json['nombre_departamento']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'anio_estudio': anio_estudio,
      'telefono': telefono,
      'direccion': direccion,
      'id_carrera': id_carrera,
    };
  }
}