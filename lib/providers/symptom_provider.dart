import 'package:flutter/material.dart';
import 'package:hackatonapp/models/sintoma.dart';

class SymptomProvider with ChangeNotifier {
  List<Sintoma> _sintomas = [];

  List<Sintoma> get sintomas => _sintomas;

  SymptomProvider() {
    fetchSymptoms();
  }

  // In a real app, this would fetch from the database
  void fetchSymptoms() {
    _sintomas = [
      Sintoma(id: 1, nombre: 'Fiebre', pregunta: '¿Ha tenido fiebre alta en los últimos días?'),
      Sintoma(id: 2, nombre: 'Dolor de cabeza', pregunta: '¿Siente un fuerte dolor de cabeza?'),
      Sintoma(id: 3, nombre: 'Dolor muscular', pregunta: '¿Tiene dolor en los músculos y articulaciones?'),
      Sintoma(id: 4, nombre: 'Sarpullido', pregunta: '¿Ha notado la aparición de sarpullido en su piel?'),
      Sintoma(id: 5, nombre: 'Malestar general', pregunta: '¿Siente un malestar general o debilidad?'),
    ];
    notifyListeners();
  }
}
