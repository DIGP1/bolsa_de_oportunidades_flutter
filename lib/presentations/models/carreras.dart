class Carreras {
  int? id;
  int? id_departamento;
  String? codigo_carrera;
  String? nombre_carrera;

  Carreras({
    this.id,
    this.id_departamento,
    this.codigo_carrera,
    this.nombre_carrera,
  });

  factory Carreras.fromJson(Map<String, dynamic> json) {
    return Carreras(
      id: json['id'],
      id_departamento: json['id_departamento'],
      codigo_carrera: json['codigo_carrera'],
      nombre_carrera: json['nombre_carrera'],
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.nombre_carrera!;
  }

}
