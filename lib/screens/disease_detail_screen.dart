import 'package:flutter/material.dart';
import 'package:hackatonapp/screens/home_screen.dart'; // Importing to get the Disease class

class DiseaseDetailScreen extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disease.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(disease.description),
      ),
    );
  }
}
