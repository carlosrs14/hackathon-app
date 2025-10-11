import 'package:flutter/material.dart';
import 'package:hackatonapp/models/evento.dart';
import 'package:hackatonapp/models/sintoma.dart';

class PredictionResultScreen extends StatelessWidget {
  final Evento evento;
  final List<Sintoma> sintomasPositivos;

  const PredictionResultScreen({
    super.key,
    required this.evento,
    required this.sintomasPositivos,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy classification
    final String classification = 'Caso Sospechoso de Dengue';

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado del Registro #${evento.id}'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Información del Paciente',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (evento.esUsuarioPrincipal)
                      const Text('Caso registrado para el usuario principal')
                    else
                      Text('Caso registrado para un familiar (Parentesco: ${evento.parentesco ?? 'No especificado'})'),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text('Documento: ${evento.documentoPersona}'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Clasificación Preliminar',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(classification, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.amber.shade100,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Síntomas Registrados:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: sintomasPositivos.length,
                itemBuilder: (context, index) {
                  final sintoma = sintomasPositivos[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(sintoma.nombre),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
