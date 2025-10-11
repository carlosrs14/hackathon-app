enum SymptomCategory { grupoB, grupoC, grupoD, factorRiesgo, fiebre, viveZona }

class Sintoma {
  final int? id;
  final String nombre;
  final String pregunta;
  final SymptomCategory category;

  Sintoma({
    this.id,
    required this.nombre,
    required this.pregunta,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'pregunta': pregunta,
      'category': category.toString(),
    };
  }

  factory Sintoma.fromMap(Map<String, dynamic> map) {
    return Sintoma(
      id: map['id'],
      nombre: map['nombre'],
      pregunta: map['pregunta'],
      category: SymptomCategory.values.firstWhere((e) => e.toString() == map['category']),
    );
  }
}