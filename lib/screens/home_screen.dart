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
      Disease('Chagas', 'Información sobre el Chagas...'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guía de Enfermedades'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Los mosquitos son vectores de numerosas enfermedades que afectan a millones de personas en todo el mundo. Esta guía proporciona información esencial sobre algunas de las enfermedades más comunes transmitidas por mosquitos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                final disease = diseases[index];
                return _buildDiseaseCard(context, disease);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(BuildContext context, Disease disease) {
    String path = 'assets/${disease.name.toLowerCase()}.jpg';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseDetailScreen(disease: disease),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(path),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Text(
              disease.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
