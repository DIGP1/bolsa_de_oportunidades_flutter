class User_register {
  final String email;
  final String password;
  final bool estadoUsuario;
  final String fechaRegistro;
  final String nombres;
  final String apellidos;
  final String telefono;
  final int idCarrera;
  final String carnet;
  final int anioEstudio;
  final String direccion;
  final String tokenRecuperacion;
  final String tokenExpiracion;
  final int idTipoUsuario;

  User_register({
    required this.email,
    required this.password,
    required this.estadoUsuario,
    required this.fechaRegistro,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.idCarrera,
    required this.carnet,
    required this.anioEstudio,
    required this.direccion,
    required this.tokenRecuperacion,
    required this.tokenExpiracion,
    required this.idTipoUsuario,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'estado_usuario': estadoUsuario,
      'fecha_registro': fechaRegistro,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'id_carrera': idCarrera,
      'carnet': carnet,
      'anio_estudio': anioEstudio,
      'direccion': direccion,
      'token_recuperacion': tokenRecuperacion,
      'token_expiracion': tokenExpiracion,
      'id_tipo_usuario': idTipoUsuario,
    };
  }
}