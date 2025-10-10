import 'package:flutter/material.dart';
import 'package:hackatonapp/models/evento.dart'; // Assuming Evento model is available

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Cargar eventos desde la base de datos
    final List<Evento> dummyEventos = [
      Evento(id: 1, usuarioId: 1, ubicacionId: 1, fecha: DateTime.now().subtract(const Duration(days: 5))),
      Evento(id: 2, usuarioId: 1, ubicacionId: 1, fecha: DateTime.now().subtract(const Duration(days: 20))),
    ];

    if (dummyEventos.isEmpty) {
      return const Center(
        child: Text('Aún no has registrado ningún caso.'),
      );
    }

    return ListView.builder(
      itemCount: dummyEventos.length,
      itemBuilder: (context, index) {
        final evento = dummyEventos[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.history),
            title: Text('Caso registrado el ${evento.fecha.day}/${evento.fecha.month}/${evento.fecha.year}'),
            subtitle: Text('ID del Caso: ${evento.id}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navegar a una pantalla de detalle del evento
            },
          ),
        );
      },
    );
  }
}