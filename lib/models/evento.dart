import 'package:hackatonapp/models/sintoma.dart';

class Evento {
  final int? id;
  final int usuarioId;
  final int? tipoEventoId;
  final int ubicacionId;
  final DateTime fecha;
  final List<Sintoma> sintomas;
  final bool reportado;
  final String documento_persona;
  final bool es_usuario_principal;
  final String? parentesco;
  final String classification; // e.g., 'grupoA', 'grupoB'
  final bool tieneFactorRiesgo;

  Evento({
    this.id,
    required this.usuarioId,
    this.tipoEventoId,
    required this.ubicacionId,
    required this.fecha,
    required this.sintomas,
    this.reportado = false,
    required this.documento_persona,
    required this.es_usuario_principal,
    this.parentesco,
    required this.classification,
    required this.tieneFactorRiesgo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'tipoEventoId': tipoEventoId,
      'ubicacionId': ubicacionId,
      'fecha': fecha.toIso8601String(),
      'documento_persona': documento_persona,
      'es_usuario_principal': es_usuario_principal ? 1 : 0,
      'parentesco': parentesco,
      'classification': classification,
      'tieneFactorRiesgo': tieneFactorRiesgo ? 1 : 0,
    };
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['id'],
      usuarioId: map['usuarioId'],
      tipoEventoId: map['tipoEventoId'],
      ubicacionId: map['ubicacionId'],
      fecha: DateTime.parse(map['fecha']),
      sintomas: [], // Note: Symptoms are not fetched here
      reportado: map['reportado'] == 1,
      documento_persona: map['documento_persona'],
      es_usuario_principal: map['es_usuario_principal'] == 1,
      parentesco: map['parentesco'],
      classification: map['classification'],
      tieneFactorRiesgo: map['tieneFactorRiesgo'] == 1,
    );
  }
}