import 'package:flutter/material.dart';
import 'package:hackatonapp/screens/home_screen.dart'; // Importing to get the Disease class
import '../helpers/dengue_data.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    
    DiseaseData? diseaseData = findByName(disease.name);
    if (diseaseData == null) {
      return Scaffold(
                appBar: AppBar(
                title: Text(disease.name),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(disease.description),
              ),);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(disease.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(diseaseData.description, Colors.blue[50]),
          const SizedBox(height: 16),
          _buildExpansionTile(
            title: 'Tipos',
            icon: Icons.category,
            children: diseaseData.types.entries.map((entry) => _buildCard('${entry.key}: ${entry.value}', Colors.green[50])).toList(),
          ),
          _buildExpansionTile(
            title: 'Síntomas',
            icon: Icons.warning,
            children: diseaseData.symptoms.entries.map((entry) => _buildCard('${entry.key}: ${entry.value}', Colors.orange[50])).toList(),
          ),
          _buildExpansionTile(
            title: 'Prevención',
            icon: Icons.health_and_safety,
            children: diseaseData.prevention.map((item) => _buildCard(item, Colors.teal[50])).toList(),
          ),
          _buildExpansionTile(
            title: 'Formas de transmisión',
            icon: Icons.transfer_within_a_station,
            children: diseaseData.transmissionsWays.map((item) => _buildCard(item, Colors.red[50])).toList(),
          ),
          _buildExpansionTile(
            title: 'Recomendaciones',
            icon: Icons.lightbulb,
            children: diseaseData.recomendations.map((item) => _buildCard(item, Colors.yellow[50])).toList(),
          ),
          _buildExpansionTile(
            title: 'Fotos',
            icon: Icons.image,
            children: diseaseData.photos.map((photo) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(photo),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        children: children,
      ),
    );
  }

  Widget _buildCard(String content, Color? color) {
    return Card(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
