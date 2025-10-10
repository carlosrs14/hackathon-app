import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hackatonapp/models/evento.dart';

class EventProvider with ChangeNotifier {
  final List<Evento> _eventos = [
    Evento(id: 1, usuarioId: 1, ubicacionId: 1, fecha: DateTime.now().subtract(const Duration(days: 5))),
    Evento(id: 2, usuarioId: 1, ubicacionId: 1, fecha: DateTime.now().subtract(const Duration(days: 20))),
  ];

  List<Evento> get eventos => _eventos;

  // In a real app, this would save to the database
  void addEvent(Map<int, bool> answers) {
    final newEvent = Evento(
      id: _eventos.length + 1,
      usuarioId: 1, // Dummy user ID
      ubicacionId: 1, // Dummy location ID
      fecha: DateTime.now(),
    );
    _eventos.add(newEvent);
    
    // Here you would also save the symptoms to the evento_sintomas table
    log('Event added: $newEvent');
    log('Answers: $answers');

    notifyListeners();
  }
}
