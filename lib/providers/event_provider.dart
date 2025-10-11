import 'package:flutter/material.dart';
import 'package:hackatonapp/models/evento.dart';
import 'package:hackatonapp/models/sintoma.dart';

class EventProvider with ChangeNotifier {
  final List<Evento> _eventos = [
    Evento(id: 1, usuarioId: 1, ubicacionId: 1, fecha: DateTime.now().subtract(const Duration(days: 5)), sintomas: [Sintoma(id: 1, nombre: 'Fiebre', pregunta: '...')]),
    Evento(id: 2, usuarioId: 1, ubicacionId: 1, fecha: DateTime.now().subtract(const Duration(days: 20)), sintomas: [Sintoma(id: 2, nombre: 'Dolor de cabeza', pregunta: '...')]),
  ];

  List<Evento> get eventos => _eventos;

  // This method now returns the newly created event
  Evento addEvent(Map<int, bool> answers, List<Sintoma> allSintomas) {
    
    final List<Sintoma> sintomasPositivos = allSintomas.where((s) {
      return answers.containsKey(s.id) && answers[s.id] == true;
    }).toList();

    final newEvent = Evento(
      id: _eventos.length + 1,
      usuarioId: 1, // Dummy user ID
      ubicacionId: 1, // Dummy location ID
      fecha: DateTime.now(),
      sintomas: sintomasPositivos,
    );
    
    _eventos.add(newEvent);
    
    print('Event added: $newEvent');
    print('Positive Symptoms: $sintomasPositivos');

    notifyListeners();
    return newEvent;
  }
}
