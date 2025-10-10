class Sintoma {
  final int? id;
  final String nombre;
  final String pregunta; // e.g., "¿Tiene fiebre?"

  Sintoma({this.id, required this.nombre, required this.pregunta});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'pregunta': pregunta,
    };
  }
}
