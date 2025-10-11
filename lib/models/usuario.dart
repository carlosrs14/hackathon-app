class Usuario {
  final int? id;
  final String cedula;
  final int edad;

  Usuario({this.id, required this.cedula, required this.edad});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cedula': cedula,
      'edad': edad,
    };
  }
}