import 'package:flutter/material.dart';
import 'package:hackatonapp/models/usuario.dart';

class UserProvider with ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  UserProvider() {
    // In a real app, you might load the user from a saved session
    _usuario = Usuario(id: 1, nombre: 'Usuario de Prueba', edad: 30);
  }

  void updateUser(Usuario newUser) {
    _usuario = newUser;
    notifyListeners();
  }
}
