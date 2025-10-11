import 'package:flutter/material.dart';
import 'package:hackatonapp/models/sintoma.dart';

class SymptomProvider with ChangeNotifier {
  List<Sintoma> _sintomas = [];

  List<Sintoma> get sintomas => _sintomas;

  SymptomProvider() {
    fetchSymptoms();
  }

  void fetchSymptoms() {
    _sintomas = [
      // --- Preguntas Base ---
      Sintoma(id: 1, nombre: 'Fiebre', pregunta: '¿Ha tenido fiebre en los últimos 7 días?', category: SymptomCategory.fiebre),
      Sintoma(id: 2, nombre: 'Zona de Dengue', pregunta: '¿Vive o ha viajado a una zona donde hay casos de dengue?', category: SymptomCategory.viveZona),

      // --- Grupo B ---
      Sintoma(id: 3, nombre: 'Dolor de Cabeza', pregunta: '¿Ha presentado dolor de cabeza o detrás de los ojos?', category: SymptomCategory.grupoB),
      Sintoma(id: 4, nombre: 'Dolor Muscular/Articular', pregunta: '¿Ha tenido dolor muscular o articular?', category: SymptomCategory.grupoB),
      Sintoma(id: 5, nombre: 'Sarpullido', pregunta: '¿Ha presentado sarpullido o erupción en la piel?', category: SymptomCategory.grupoB),

      // --- Grupo C (Signos de Alarma) ---
      Sintoma(id: 6, nombre: 'Dolor Abdominal', pregunta: '¿Siente dolor abdominal intenso o continuo?', category: SymptomCategory.grupoC),
      Sintoma(id: 7, nombre: 'Vómitos Persistentes', pregunta: '¿Ha tenido vómitos persistentes (más de 3 veces al día)?', category: SymptomCategory.grupoC),
      Sintoma(id: 8, nombre: 'Mareo o Desmayo', pregunta: '¿Ha sentido mareo o desmayo al ponerse de pie (lipotimia)?', category: SymptomCategory.grupoC),
      Sintoma(id: 9, nombre: 'Dolor de Hígado', pregunta: '¿Tiene el abdomen inflamado o siente dolor al tocar el hígado (debajo de las costillas derechas)?', category: SymptomCategory.grupoC),
      Sintoma(id: 10, nombre: 'Sangrados', pregunta: '¿Ha notado sangrados por encías, nariz o heces negras?', category: SymptomCategory.grupoC),
      Sintoma(id: 11, nombre: 'Somnolencia/Irritabilidad', pregunta: '¿Se siente muy somnoliento(a) o irritable?', category: SymptomCategory.grupoC),
      Sintoma(id: 12, nombre: 'Poca Orina', pregunta: '¿Ha notado que orina muy poco?', category: SymptomCategory.grupoC),
      Sintoma(id: 13, nombre: 'Bajón de Temperatura', pregunta: '¿Ha sentido frío repentino o bajón de temperatura corporal?', category: SymptomCategory.grupoC),
      Sintoma(id: 14, nombre: 'Acumulación de Líquidos', pregunta: '¿Tiene acumulación de líquidos (hinchazón, ascitis o dificultad para respirar)?', category: SymptomCategory.grupoC),

      // --- Grupo D (Signos de Choque) ---
      Sintoma(id: 15, nombre: 'Manos/Pies Fríos o Azulados', pregunta: '¿Siente las manos o pies fríos o azulados?', category: SymptomCategory.grupoD),
      Sintoma(id: 16, nombre: 'Pulso Rápido y Débil', pregunta: '¿Su pulso se siente rápido y débil?', category: SymptomCategory.grupoD),
      Sintoma(id: 17, nombre: 'Presión Baja/Mareo Extremo', pregunta: '¿Ha tenido presión arterial baja o mareo extremo?', category: SymptomCategory.grupoD),
      Sintoma(id: 18, nombre: 'Respiración Rápida', pregunta: '¿Ha tenido respiración rápida o dificultad para respirar?', category: SymptomCategory.grupoD),

      // --- Factores de Riesgo ---
      Sintoma(id: 19, nombre: 'Embarazo', pregunta: '¿Está embarazada?', category: SymptomCategory.factorRiesgo),
      Sintoma(id: 20, nombre: 'Edad', pregunta: '¿Tiene menos de 5 años o más de 65 años?', category: SymptomCategory.factorRiesgo),
      Sintoma(id: 21, nombre: 'Enfermedad Crónica', pregunta: '¿Tiene alguna enfermedad crónica (hipertensión, diabetes, asma, enfermedad renal, cardíaca, etc.)?', category: SymptomCategory.factorRiesgo),
      Sintoma(id: 22, nombre: 'Vive Solo/a', pregunta: '¿Vive solo(a) o tiene dificultad para llegar a un hospital?', category: SymptomCategory.factorRiesgo),
    ];
    notifyListeners();
  }
}