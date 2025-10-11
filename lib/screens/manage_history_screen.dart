import 'package:flutter/material.dart';
import 'package:hackatonapp/models/antecedente.dart';
import 'package:hackatonapp/providers/history_provider.dart';
import 'package:hackatonapp/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ManageHistoryScreen extends StatefulWidget {
  const ManageHistoryScreen({super.key});

  @override
  State<ManageHistoryScreen> createState() => _ManageHistoryScreenState();
}

class _ManageHistoryScreenState extends State<ManageHistoryScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).usuario;
    if (user != null) {
      Provider.of<HistoryProvider>(context, listen: false).loadAntecedentes(user.id!);
    }
  }

  void _showAntecedenteDialog({Antecedente? antecedente}) {
    final controller = TextEditingController(text: antecedente?.descripcion ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(antecedente == null ? 'Añadir Antecedente' : 'Editar Antecedente'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Descripción'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final user = Provider.of<UserProvider>(context, listen: false).usuario;
                if (controller.text.isNotEmpty && user != null) {
                  if (antecedente == null) {
                    // Add new
                    final newAntecedente = Antecedente(
                      usuarioId: user.id!,
                      descripcion: controller.text,
                    );
                    Provider.of<HistoryProvider>(context, listen: false).addAntecedente(newAntecedente);
                  } else {
                    // Update existing
                    final updatedAntecedente = Antecedente(
                      id: antecedente.id,
                      usuarioId: antecedente.usuarioId,
                      descripcion: controller.text,
                    );
                    Provider.of<HistoryProvider>(context, listen: false).updateAntecedente(updatedAntecedente);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Antecedentes'),
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, child) {
          final antecedentes = historyProvider.antecedentes;
          if (antecedentes.isEmpty) {
            return const Center(child: Text('No hay antecedentes registrados.'));
          }
          return ListView.builder(
            itemCount: antecedentes.length,
            itemBuilder: (context, index) {
              final antecedente = antecedentes[index];
              return ListTile(
                title: Text(antecedente.descripcion),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showAntecedenteDialog(antecedente: antecedente),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Provider.of<HistoryProvider>(context, listen: false).deleteAntecedente(antecedente.id!, antecedente.usuarioId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAntecedenteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
