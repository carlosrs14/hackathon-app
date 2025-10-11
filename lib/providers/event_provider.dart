import 'package:flutter/material.dart';
import 'package:hackatonapp/models/evento.dart';
import 'package:hackatonapp/models/sintoma.dart';

class EventProvider with ChangeNotifier {
  final List<Evento> _eventos = [];

  List<Evento> get eventos => _eventos;

  Evento addEvent({
    required Map<int, bool> answers,
    required List<Sintoma> sintomas,
    required String documentoPersona,
    required bool esUsuarioPrincipal,
    String? parentesco,
  }) {
    final List<Sintoma> sintomasPositivos = sintomas.where((s) {
      return answers.containsKey(s.id) && answers[s.id] == true;
    }).toList();

    final newEvent = Evento(
      id: _eventos.length + 1,
      usuarioId: 1, // TODO: Get the real user ID
      ubicacionId: 1, // TODO: Get the real location ID
      fecha: DateTime.now(),
      sintomas: sintomasPositivos,
      documento_persona: documentoPersona,
      es_usuario_principal: esUsuarioPrincipal,
      parentesco: parentesco,
    );

    _eventos.add(newEvent);

    notifyListeners();
    return newEvent;
  }
}
