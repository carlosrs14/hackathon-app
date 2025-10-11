import 'package:flutter/material.dart';
import 'package:hackatonapp/helpers/database_helper.dart';
import 'package:hackatonapp/main.dart';
import 'package:hackatonapp/models/ubicacion.dart';
import 'package:hackatonapp/models/usuario.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _edadController = TextEditingController();

  String? _selectedDepartamento;
  String? _selectedMunicipio;

  final Map<String, List<String>> _municipios = {
    'Magdalena': ['Santa Marta', 'Ciénaga', 'Aracataca'],
    'Antioquia': ['Medellín', 'Envigado', 'Itagüí'],
    'Cundinamarca': ['Bogotá', 'Soacha', 'Zipaquirá'],
  };

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final usuario = Usuario(
        cedula: _cedulaController.text,
        edad: int.parse(_edadController.text),
      );

      final ubicacion = Ubicacion(
        departamento: _selectedDepartamento!,
        municipio: _selectedMunicipio!,
      );

      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertUbicacion(ubicacion);
      await dbHelper.insertUser(usuario);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su cédula';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su edad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDepartamento,
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  border: OutlineInputBorder(),
                ),
                items: _municipios.keys.map((String departamento) {
                  return DropdownMenuItem<String>(
                    value: departamento,
                    child: Text(departamento),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDepartamento = newValue;
                    _selectedMunicipio = null; // Reset municipio when department changes
                  });
                },
                validator: (value) => value == null ? 'Seleccione un departamento' : null,
              ),
              const SizedBox(height: 16),
              if (_selectedDepartamento != null)
                DropdownButtonFormField<String>(
                  value: _selectedMunicipio,
                  decoration: const InputDecoration(
                    labelText: 'Municipio',
                    border: OutlineInputBorder(),
                  ),
                  items: _municipios[_selectedDepartamento!]!.map((String municipio) {
                    return DropdownMenuItem<String>(
                      value: municipio,
                      child: Text(municipio),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMunicipio = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione un municipio' : null,
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
