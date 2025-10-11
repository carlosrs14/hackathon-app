import 'package:flutter/material.dart';
import 'package:hackatonapp/helpers/database_helper.dart';
import 'package:hackatonapp/models/usuario.dart';

class UserProvider with ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  UserProvider() {
    loadUser();
  }

  Future<void> loadUser() async {
    _usuario = await DatabaseHelper.instance.getUser();
    notifyListeners();
  }

  void updateUser(Usuario newUser) {
    _usuario = newUser;
    notifyListeners();
  }
}