import 'package:hackatonapp/models/sintoma.dart';

class Evento {
  final int? id;
  final int usuarioId;
  final int? tipoEventoId;
  final int ubicacionId;
  final DateTime fecha;
  final List<Sintoma> sintomas;
  final bool reportado;

  Evento({
    this.id,
    required this.usuarioId,
    this.tipoEventoId,
    required this.ubicacionId,
    required this.fecha,
    required this.sintomas,
    this.reportado = false
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
