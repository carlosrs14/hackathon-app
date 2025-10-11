class Antecedente {
  final int? id;
  final int usuarioId;
  final String descripcion;

  Antecedente({this.id, required this.usuarioId, required this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'descripcion': descripcion,
    };
  }

  factory Antecedente.fromMap(Map<String, dynamic> map) {
    return Antecedente(
      id: map['id'],
      usuarioId: map['usuarioId'],
      descripcion: map['descripcion'],
    );
  }
}
