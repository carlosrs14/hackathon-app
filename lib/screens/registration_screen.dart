import 'package:flutter/material.dart';
import 'package:hackatonapp/models/sintoma.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  final Map<int, bool> _answers = {};

  // TODO: Cargar síntomas desde la base de datos
  final List<Sintoma> _sintomas = [
    Sintoma(id: 1, nombre: 'Fiebre', pregunta: '¿Ha tenido fiebre alta en los últimos días?'),
    Sintoma(id: 2, nombre: 'Dolor de cabeza', pregunta: '¿Siente un fuerte dolor de cabeza?'),
    Sintoma(id: 3, nombre: 'Dolor muscular', pregunta: '¿Tiene dolor en los músculos y articulaciones?'),
    Sintoma(id: 4, nombre: 'Sarpullido', pregunta: '¿Ha notado la aparición de sarpullido en su piel?'),
    Sintoma(id: 5, nombre: 'Malestar general', pregunta: '¿Siente un malestar general o debilidad?'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: () {
        if (_currentStep < _sintomas.length - 1) {
          setState(() {
            _currentStep++;
          });
        } else {
          // Lógica para guardar
          _saveCase();
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep--;
          });
        }
      },
      steps: _buildSteps(),
    );
  }

  List<Step> _buildSteps() {
    return _sintomas.asMap().entries.map((entry) {
      int idx = entry.key;
      Sintoma sintoma = entry.value;

      return Step(
        title: Text(sintoma.nombre),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sintoma.pregunta),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _answers[sintoma.id!] = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _answers[sintoma.id] == true ? Colors.green : null,
                  ),
                  child: const Text('Sí'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _answers[sintoma.id!] = false;
                    });
                  },
                   style: ElevatedButton.styleFrom(
                    backgroundColor: _answers[sintoma.id] == false ? Colors.red : null,
                  ),
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
        isActive: _currentStep >= idx,
        state: _currentStep > idx || _answers.containsKey(sintoma.id) ? StepState.complete : StepState.indexed,
      );
    }).toList();
  }

  void _saveCase() {
    // TODO: Implementar la lógica para guardar en la base de datos
    print('Guardando caso...');
    print('Respuestas: $_answers');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Caso registrado con éxito (simulación).')),
    );

    // Resetear el formulario
    setState(() {
      _currentStep = 0;
      _answers.clear();
    });
  }
}