import 'package:flutter/material.dart';
import 'package:hackatonapp/helpers/database_helper.dart';
import 'package:hackatonapp/models/evento.dart';
import 'package:hackatonapp/models/sintoma.dart';

class EventProvider with ChangeNotifier {
  List<Evento> _eventos = [];

  List<Evento> get eventos => _eventos;

  Future<void> loadEventos(int usuarioId) async {
    _eventos = await DatabaseHelper.instance.getEventos(usuarioId);
    notifyListeners();
  }

  Future<Evento> addEvent({
    required Map<int, bool> answers,
    required List<Sintoma> sintomas,
    required String documentoPersona,
    required bool esUsuarioPrincipal,
    String? parentesco,
    required String classification,
    required bool tieneFactorRiesgo,
    required int usuarioId,
    required int ubicacionId,
  }) async {
    final newEvent = Evento(
      usuarioId: usuarioId,
      ubicacionId: ubicacionId,
      fecha: DateTime.now(),
      sintomas: sintomas,
      documento_persona: documentoPersona,
      es_usuario_principal: esUsuarioPrincipal,
      parentesco: parentesco,
      classification: classification,
      tieneFactorRiesgo: tieneFactorRiesgo,
    );

    final savedEvent = await DatabaseHelper.instance.insertEvento(newEvent, answers);
    
    await loadEventos(usuarioId);

    return savedEvent;
  }
}
