import 'package:flutter/material.dart';
import 'package:hackatonapp/screens/disease_detail_screen.dart';

class Disease {
  final String name;
  final String description;

  Disease(this.name, this.description);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diseases = [
      Disease('Dengue', 'Información sobre el Dengue...'),
      Disease('Zika', 'Información sobre el Zika...'),
      Disease('Chikungunya', 'Información sobre el Chikungunya...'),
      Disease('Malaria', 'Información sobre la Malaria...'),
      Disease('Chagas', 'Información sobre la Malaria...'),
    ];

    return ListView.builder(
      itemCount: diseases.length,
      itemBuilder: (context, index) {
        final disease = diseases[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(disease.name),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiseaseDetailScreen(disease: disease),
                ),
              );
            },
          ),
        );
      },
    );
  }
}