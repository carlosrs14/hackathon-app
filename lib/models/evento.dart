import 'package:hackatonapp/models/sintoma.dart';

class Evento {
  final int? id;
  final int usuarioId;
  final int? tipoEventoId;
  final int ubicacionId;
  final DateTime fecha;
  final List<Sintoma> sintomas;
  final bool reportado;

  final String documentoPersona;
  final bool esUsuarioPrincipal;
  final String? parentesco;

  Evento({
    this.id,
    required this.usuarioId,
    this.tipoEventoId,
    required this.ubicacionId,
    required this.fecha,
    required this.sintomas,
    this.reportado = false,
    required this.documentoPersona,
    required this.esUsuarioPrincipal,
    this.parentesco,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'tipoEventoId': tipoEventoId,
      'ubicacionId': ubicacionId,
      'fecha': fecha.toIso8601String(),
      'documento_persona': documentoPersona,
      'es_usuario_principal': esUsuarioPrincipal ? 1 : 0,
      'parentesco': parentesco,
    };
  }
}
