import 'package:flutter/material.dart';
import 'package:hackatonapp/helpers/database_helper.dart';
import 'package:hackatonapp/models/antecedente.dart';

class HistoryProvider with ChangeNotifier {
  List<Antecedente> _antecedentes = [];

  List<Antecedente> get antecedentes => _antecedentes;

  Future<void> loadAntecedentes(int usuarioId) async {
    _antecedentes = await DatabaseHelper.instance.getAntecedentes(usuarioId);
    notifyListeners();
  }

  Future<void> addAntecedente(Antecedente antecedente) async {
    await DatabaseHelper.instance.insertAntecedente(antecedente);
    await loadAntecedentes(antecedente.usuarioId);
  }

  Future<void> updateAntecedente(Antecedente antecedente) async {
    await DatabaseHelper.instance.updateAntecedente(antecedente);
    await loadAntecedentes(antecedente.usuarioId);
  }

  Future<void> deleteAntecedente(int id, int usuarioId) async {
    await DatabaseHelper.instance.deleteAntecedente(id);
    await loadAntecedentes(usuarioId);
  }
}