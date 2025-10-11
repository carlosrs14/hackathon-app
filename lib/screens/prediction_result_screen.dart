import 'package:flutter/material.dart';
import 'package:hackatonapp/helpers/classification_helper.dart';

class PredictionResultScreen extends StatelessWidget {
  final ClassificationResult result;

  const PredictionResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado del Diagnóstico'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Clasificación de Riesgo',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        result.classificationName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.amber.shade200,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ],
                ),
              ),
            ),
            if (result.tieneFactorRiesgo)
              Card(
                elevation: 4,
                color: Colors.red.shade50,
                margin: const EdgeInsets.only(top: 16.0),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.red, size: 40),
                    title: Text('¡Factor de Riesgo Detectado!'),
                    subtitle: Text('Usted presenta factores de riesgo. Se recomienda observación hospitalaria inmediata.'),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Recomendaciones y Cuidados:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(result.recommendations, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Finalizar y Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}