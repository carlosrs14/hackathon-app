class Ubicacion {
  final int? id;
  final String departamento;
  final String municipio;
  final double? latitud;
  final double? longitud;

  Ubicacion({
    this.id,
    required this.departamento,
    required this.municipio,
    this.latitud,
    this.longitud,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'departamento': departamento,
      'municipio': municipio,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}
