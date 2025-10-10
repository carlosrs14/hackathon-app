import 'package:flutter/material.dart';
import 'package:hackatonapp/models/antecedente.dart';

class HistoryProvider with ChangeNotifier {
  List<Antecedente> _antecedentes = [];

  List<Antecedente> get antecedentes => _antecedentes;

  HistoryProvider() {
    fetchHistory();
  }

  void fetchHistory() {
    // In a real app, this would fetch from the database
    _antecedentes = [
      Antecedente(id: 1, usuarioId: 1, descripcion: 'Hipertensión'),
      Antecedente(id: 2, usuarioId: 1, descripcion: 'Asma'),
    ];
    notifyListeners();
  }

  void addAntecedente(String descripcion) {
    final newAntecedente = Antecedente(
      id: _antecedentes.length + 1,
      usuarioId: 1, // Dummy user ID
      descripcion: descripcion,
    );
    _antecedentes.add(newAntecedente);
    notifyListeners();
  }
}
