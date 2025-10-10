class Evento {
  final int? id;
  final int usuarioId;
  final int? tipoEventoId;
  final int ubicacionId;
  final DateTime fecha;

  Evento({
    this.id,
    required this.usuarioId,
    this.tipoEventoId,
    required this.ubicacionId,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'tipoEventoId': tipoEventoId,
      'ubicacionId': ubicacionId,
      'fecha': fecha.toIso8601String(),
    };
  }
}
