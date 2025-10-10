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
}
