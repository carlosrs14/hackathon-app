import 'package:flutter/material.dart';
import 'package:hackatonapp/providers/event_provider.dart';
import 'package:hackatonapp/providers/history_provider.dart';
import 'package:hackatonapp/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // --- User Info Section ---
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.usuario;
            if (user == null) {
              return const ListTile(title: Text('Cargando usuario...'));
            }
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.person_pin_rounded, size: 40),
                title: Text(user.nombre, style: Theme.of(context).textTheme.headlineSmall),
                subtitle: Text('Edad: ${user.edad} años'),
              ),
            );
          },
        ),

        const Divider(),

        // --- Medical History Section ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Mis Antecedentes', style: Theme.of(context).textTheme.titleLarge),
        ),
        Consumer<HistoryProvider>(
          builder: (context, historyProvider, child) {
            final antecedentes = historyProvider.antecedentes;
            if (antecedentes.isEmpty) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No hay antecedentes registrados.'),
              ));
            }
            return Column(
              children: antecedentes.map((antecedente) => ListTile(
                leading: const Icon(Icons.medical_information),
                title: Text(antecedente.descripcion),
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
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Aún no has registrado ningún caso.'),
              ));
            }
            return ListView.builder(
              shrinkWrap: true, // Important for nested ListViews
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
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
                      // TODO: Navegar a una pantalla de detalle del evento
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
