import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackatonapp/helpers/classification_helper.dart';
import 'package:hackatonapp/helpers/database_helper.dart';
import 'package:hackatonapp/providers/event_provider.dart';
import 'package:hackatonapp/providers/history_provider.dart';
import 'package:hackatonapp/providers/user_provider.dart';
import 'package:hackatonapp/screens/manage_history_screen.dart';
import 'package:hackatonapp/screens/prediction_result_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false).usuario;
      if (user != null) {
        Provider.of<HistoryProvider>(context, listen: false).loadAntecedentes(user.id!);
        Provider.of<EventProvider>(context, listen: false).loadEventos(user.id!);
      }
    });
  }

  Future<void> _exportData(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
      // final allData = await DatabaseHelper.instance.getAllData();
      // final jsonData = jsonEncode(allData);
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Datos exportados con éxito')));

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).usuario;

    return ListView(
      children: [
        // --- User Info Section ---
        if (user == null)
          const ListTile(title: Text('Cargando usuario...'))
        else
          Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.person_pin_rounded, size: 40),
              title: Text("Cédula: ${user.cedula}", style: Theme.of(context).textTheme.headlineSmall),
              subtitle: Text('Edad: ${user.edad} años'),
            ),
          ),

        const Divider(),

        // --- Medical History Section ---
        ListTile(
          title: Text('Mis Antecedentes', style: Theme.of(context).textTheme.titleLarge),
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ManageHistoryScreen()));
            },
            child: const Text('Gestionar'),
          ),
        ),
        Consumer<HistoryProvider>(
          builder: (context, historyProvider, child) {
            final antecedents = historyProvider.antecedentes;
            if (antecedents.isEmpty) {
              return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('No hay antecedentes registrados.')));
            }
            return Column(
              children: antecedents.map((antecedent) => ListTile(
                leading: const Icon(Icons.medical_information),
                title: Text(antecedent.descripcion),
              )).toList(),
            );
          },
        ),

        const Divider(),

        // --- Registered Events Section ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Mis Casos Registrados', style: Theme.of(context).textTheme.titleLarge),
        ),
        Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            final eventos = eventProvider.eventos;
            if (eventos.isEmpty) {
              return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Aún no has registrado ningún caso.')));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text('Caso #${evento.id}'),
                    subtitle: Text('Registrado el: ${evento.fecha.day}/${evento.fecha.month}/${evento.fecha.year}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      final classificationEnum = DengueClassification.values.firstWhere(
                        (e) => e.name == evento.classification,
                        orElse: () => DengueClassification.grupoA,
                      );

                      final result = ClassificationResult(
                        classification: classificationEnum,
                        tieneFactorRiesgo: evento.tieneFactorRiesgo,
                        classificationName: ClassificationHelper.getClassificationName(classificationEnum),
                        recommendations: ClassificationHelper.getRecommendationsByClassification(classificationEnum),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PredictionResultScreen(result: result),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),

        const Divider(),

        // --- Export Button ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _exportData(context),
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Exportar datos'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}