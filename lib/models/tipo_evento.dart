class TipoEvento {
  final int? id;
  final String nombre;

  TipoEvento({this.id, required this.nombre});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
