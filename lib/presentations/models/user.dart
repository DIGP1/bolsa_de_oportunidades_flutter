class User {
  final int id_user;
  final String email;
  final int id_tipo_user;
  final int estado_usuario;
  final String fecha_registro;
  final String token;
  final int id_proyecto;

  User({
    required this.id_user,
    required this.email,
    required this.id_tipo_user,
    required this.estado_usuario,
    required this.fecha_registro,
    required this.token,
    required this.id_proyecto
  });

  // Método factory para crear una instancia de User desde la respuesta JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id_user: json['estudiante_id'],
      email: json['user']['email'],
      id_tipo_user: json['user']['id_tipo_usuario'],
      estado_usuario: json['user']['estado_usuario'],
      fecha_registro: json['user']['fecha_registro'],
      token: json['token'],
      id_proyecto: json['user']['id_proyecto_asignado']
    );
  }

  // Método para convertir User a JSON (útil si se necesitan guardar los datos localmente)
  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'email': email,
      'id_tipo_user': id_tipo_user,
      'estado_usuario': estado_usuario,
      'fecha_registro': fecha_registro,
      'token': token,
    };
  }
}