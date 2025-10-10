class Usuario {
  final int? id;
  final String nombre;
  final int edad;

  Usuario({this.id, required this.nombre, required this.edad});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
    };
  }
}
