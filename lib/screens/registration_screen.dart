import 'package:flutter/material.dart';
import 'package:hackatonapp/models/sintoma.dart';
import 'package:hackatonapp/providers/event_provider.dart';
import 'package:hackatonapp/providers/symptom_provider.dart';
import 'package:hackatonapp/providers/user_provider.dart';
import 'package:hackatonapp/screens/prediction_result_screen.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  final Map<int, bool> _answers = {};

  bool _isForCurrentUser = true;
  final _documentoPersonaController = TextEditingController();
  final _parentescoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomProvider>(
      builder: (context, symptomProvider, child) {
        final sintomas = symptomProvider.sintomas;

        return Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < sintomas.length) {
              setState(() {
                _currentStep++;
              });
            } else {
              _saveCase(sintomas);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          steps: _buildSteps(sintomas),
        );
      },
    );
  }

  List<Step> _buildSteps(List<Sintoma> sintomas) {
    final steps = <Step>[
      Step(
        title: const Text('¿Para quién es el registro?'),
        content: Column(
          children: [
            RadioListTile<bool>(
              title: const Text('Para mí'),
              value: true,
              groupValue: _isForCurrentUser,
              onChanged: (value) {
                setState(() {
                  _isForCurrentUser = value!;
                });
              },
            ),
            RadioListTile<bool>(
              title: const Text('Para un familiar'),
              value: false,
              groupValue: _isForCurrentUser,
              onChanged: (value) {
                setState(() {
                  _isForCurrentUser = value!;
                });
              },
            ),
            if (!_isForCurrentUser)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _documentoPersonaController,
                      decoration: const InputDecoration(
                        labelText: 'Documento del familiar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _parentescoController,
                      decoration: const InputDecoration(
                        labelText: 'Parentesco (ej. Madre, Hijo)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
    ];

    steps.addAll(sintomas.asMap().entries.map((entry) {
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
        isActive: _currentStep >= idx + 1,
        state: _currentStep > idx + 1 || _answers.containsKey(sintoma.id) ? StepState.complete : StepState.indexed,
      );
    }));

    return steps;
  }

  void _saveCase(List<Sintoma> sintomas) {
    final userProvider = context.read<UserProvider>();
    final String documentoPersona;
    if (_isForCurrentUser) {
      documentoPersona = userProvider.usuario?.cedula ?? '';
    } else {
      documentoPersona = _documentoPersonaController.text;
    }

    final newEvent = context.read<EventProvider>().addEvent(
          answers: _answers,
          sintomas: sintomas,
          documentoPersona: documentoPersona,
          esUsuarioPrincipal: _isForCurrentUser,
          parentesco: _isForCurrentUser ? null : _parentescoController.text,
        );

    setState(() {
      _currentStep = 0;
      _answers.clear();
      _isForCurrentUser = true;
      _documentoPersonaController.clear();
      _parentescoController.clear();
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PredictionResultScreen(
          evento: newEvent,
          sintomasPositivos: newEvent.sintomas,
        ),
      ),
    );
  }
}
