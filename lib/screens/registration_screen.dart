import 'package:flutter/material.dart';
import 'package:hackatonapp/helpers/classification_helper.dart';
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

  List<Step> _buildSteps(List<Sintoma> sintomas) {
    final symptomsByCategory = <SymptomCategory, List<Sintoma>>{};
    for (var s in sintomas) {
      (symptomsByCategory[s.category] ??= []).add(s);
    }

    final orderedCategories = [
      SymptomCategory.fiebre,
      SymptomCategory.viveZona,
      SymptomCategory.grupoB,
      SymptomCategory.grupoC,
      SymptomCategory.grupoD,
      SymptomCategory.factorRiesgo,
    ];

    final categoryTitles = {
      SymptomCategory.fiebre: 'Fiebre',
      SymptomCategory.viveZona: 'Ubicación',
      SymptomCategory.grupoB: 'Síntomas Generales',
      SymptomCategory.grupoC: 'Signos de Alarma',
      SymptomCategory.grupoD: 'Signos de Choque',
      SymptomCategory.factorRiesgo: 'Factores de Riesgo',
    };

    final steps = <Step>[
      Step(
        title: const Text('Paciente'),
        content: _buildPatientStep(),
        isActive: _currentStep >= 0,
      ),
    ];

    int stepIndex = 1;
    for (var category in orderedCategories) {
      if (symptomsByCategory.containsKey(category)) {
        steps.add(
          Step(
            title: Text(categoryTitles[category]!),
            content: _buildSymptomList(symptomsByCategory[category]!),
            isActive: _currentStep >= stepIndex,
          ),
        );
        stepIndex++;
      }
    }
    return steps;
  }

  Widget _buildPatientStep() {
    return Column(
      children: [
        RadioListTile<bool>(
          title: const Text('Para mí'),
          value: true,
          groupValue: _isForCurrentUser,
          onChanged: (value) => setState(() => _isForCurrentUser = value!),
        ),
        RadioListTile<bool>(
          title: const Text('Para un familiar'),
          value: false,
          groupValue: _isForCurrentUser,
          onChanged: (value) => setState(() => _isForCurrentUser = value!),
        ),
        if (!_isForCurrentUser)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _documentoPersonaController,
                  decoration: const InputDecoration(labelText: 'Documento del familiar', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _parentescoController,
                  decoration: const InputDecoration(labelText: 'Parentesco (ej. Madre, Hijo)', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSymptomList(List<Sintoma> sintomas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sintomas.map((sintoma) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(sintoma.pregunta, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _answers[sintoma.id!] = true),
                  style: ElevatedButton.styleFrom(backgroundColor: _answers[sintoma.id] == true ? Colors.green : null),
                  child: const Text('Sí'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _answers[sintoma.id!] = false),
                  style: ElevatedButton.styleFrom(backgroundColor: _answers[sintoma.id] == false ? Colors.red : null),
                  child: const Text('No'),
                ),
              ],
            ),
            const Divider(height: 24),
          ],
        );
      }).toList(),
    );
  }

  void _saveCase(List<Sintoma> allSintomas) async {
    final userProvider = context.read<UserProvider>();
    final String documentoPersona;
    if (_isForCurrentUser) {
      documentoPersona = userProvider.usuario?.cedula ?? '';
    } else {
      documentoPersona = _documentoPersonaController.text;
    }

    final classificationResult = ClassificationHelper.classifyDengue(_answers, allSintomas);

    final newEvent = await context.read<EventProvider>().addEvent(
          answers: _answers,
          sintomas: allSintomas.where((s) => _answers[s.id] == true).toList(),
          documentoPersona: documentoPersona,
          esUsuarioPrincipal: _isForCurrentUser,
          parentesco: _isForCurrentUser ? null : _parentescoController.text,
          classification: classificationResult.classification.name, // Pass the enum name
          tieneFactorRiesgo: classificationResult.tieneFactorRiesgo,
          usuarioId: userProvider.usuario!.id!,
          ubicacionId: 1, // Dummy Ubicacion ID
        );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PredictionResultScreen(
          result: classificationResult,
        ),
      ),
    );

    setState(() {
      _currentStep = 0;
      _answers.clear();
      _isForCurrentUser = true;
      _documentoPersonaController.clear();
      _parentescoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomProvider>(
      builder: (context, symptomProvider, child) {
        final allSintomas = symptomProvider.sintomas;
        final steps = _buildSteps(allSintomas);

        return Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < steps.length - 1) {
              setState(() {
                _currentStep++;
              });
            } else {
              _saveCase(allSintomas);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          steps: steps,
        );
      },
    );
  }
}