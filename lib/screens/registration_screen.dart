import 'package:flutter/material.dart';
import 'package:hackatonapp/models/sintoma.dart';
import 'package:hackatonapp/providers/event_provider.dart';
import 'package:hackatonapp/providers/symptom_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomProvider>(
      builder: (context, symptomProvider, child) {
        final sintomas = symptomProvider.sintomas;

        return Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < sintomas.length - 1) {
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
    return sintomas.asMap().entries.map((entry) {
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

  void _saveCase(List<Sintoma> sintomas) {
    final newEvent = context.read<EventProvider>().addEvent(_answers, sintomas);

    setState(() {
      _currentStep = 0;
      _answers.clear();
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