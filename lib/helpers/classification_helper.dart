import 'package:hackatonapp/models/sintoma.dart';

enum DengueClassification { grupoA, grupoB, grupoC, grupoD }

class ClassificationResult {
  final DengueClassification classification;
  final bool tieneFactorRiesgo;
  final String classificationName;
  final String recommendations;

  ClassificationResult({
    required this.classification,
    required this.tieneFactorRiesgo,
    required this.classificationName,
    required this.recommendations,
  });
}

class ClassificationHelper {
  static const Map<DengueClassification, String> _classificationNames = {
    DengueClassification.grupoA: 'Grupo A: Manejo Ambulatorio',
    DengueClassification.grupoB: 'Grupo B: Dengue con Signos de Alarma',
    DengueClassification.grupoC: 'Grupo C: Dengue Grave',
    DengueClassification.grupoD: 'Grupo D: Dengue con Signos de Choque', // Although D is a subset of C, we can name it
  };

  static const Map<DengueClassification, String> _recommendations = {
    DengueClassification.grupoA: '''
- Acude a tu centro de salud más cercano para confirmación del diagnóstico.
- Hidratación oral abundante: tomar al menos 2 litros al día (agua, sopas, sueros de rehidratación, jugos naturales no cítricos).
- No automedicarse. No usar Aspirina, Ibuprofeno, naproxeno, dexametasona o diclofenaco.
- Para la fiebre o dolor: usar solo acetaminofén (paracetamol), siempre que no seas alérgico.
- Reposo en cama: evitar el esfuerzo físico y exponerse al sol.
- Vigilancia domiciliaria: controlar temperatura, dolor y signos de alarma.
- Consultar inmediatamente si aparece cualquiera de los siguientes signos: Dolor abdominal intenso, Vómitos persistentes, Sangrados, Sensación de mucho sueño o irritabilidad, Frialdad o debilidad extrema, Dificultad para respirar.
''',
    DengueClassification.grupoB: '''
- Hospitalización inmediata para observación y control médico continuo.
- No consumir alimentos ni líquidos por vía oral si hay vómitos intensos o dolor abdominal hasta que el personal médico lo indique.
- Reposo absoluto.
- No automedicarse.
- Si el paciente está en casa mientras se traslada al hospital: Mantenerlo en reposo, administrar sorbos pequeños de suero oral si es tolerado, no administrar medicamentos inyectados ni tomados por decisión propia.
- Buscar atención médica urgente.
''',
    DengueClassification.grupoC: '''
- Traslado urgente a un hospital de mayor complejidad, no ir a puestos de salud.
- No dar líquidos ni alimentos por vía oral.
- Mantener al paciente acostado, con las piernas elevadas mientras llega ayuda médica.
- No dar medicación casera o automedicación.
- Durante el traslado: llevar historia clínica (si existe) y registrar la hora de inicio de los síntomas.
''',
    DengueClassification.grupoD: '''
- Traslado urgente a un hospital de mayor complejidad, no ir a puestos de salud.
- No dar líquidos ni alimentos por vía oral.
- Mantener al paciente acostado, con las piernas elevadas mientras llega ayuda médica.
- No dar medicación casera o automedicación.
- Durante el traslado: llevar historia clínica (si existe) y registrar la hora de inicio de los síntomas.
''',
  };

  static ClassificationResult classifyDengue(Map<int, bool> answers, List<Sintoma> allSintomas) {
    bool hasFiebre = answers[1] == true;
    bool viveEnZona = answers[2] == true;

    final sintomasGrupoB = allSintomas.where((s) => s.category == SymptomCategory.grupoB).map((s) => s.id!).toList();
    final sintomasGrupoC = allSintomas.where((s) => s.category == SymptomCategory.grupoC).map((s) => s.id!).toList();
    final sintomasGrupoD = allSintomas.where((s) => s.category == SymptomCategory.grupoD).map((s) => s.id!).toList();
    final factoresRiesgo = allSintomas.where((s) => s.category == SymptomCategory.factorRiesgo).map((s) => s.id!).toList();

    int countGrupoB = sintomasGrupoB.where((id) => answers[id] == true).length;
    int countGrupoC = sintomasGrupoC.where((id) => answers[id] == true).length;
    int countGrupoD = sintomasGrupoD.where((id) => answers[id] == true).length;
    bool tieneFactorRiesgo = factoresRiesgo.any((id) => answers[id] == true);

    DengueClassification finalClassification = DengueClassification.grupoA;

    bool esGrupoB = hasFiebre && viveEnZona && countGrupoB >= 2;
    bool esGrupoC = esGrupoB && countGrupoC >= 1;
    bool esGrupoD = esGrupoC && countGrupoD >= 2;

    if (esGrupoD) {
      finalClassification = DengueClassification.grupoD;
    } else if (esGrupoC) {
      finalClassification = DengueClassification.grupoC;
    } else if (esGrupoB) {
      finalClassification = DengueClassification.grupoB;
    }

    // The logic from the doc says "Si responde “Sí” a alguna [de factor de riesgo] → requiere observación hospitalaria inmediata."
    // This implies that any risk factor moves the patient to at least Group B management.
    if (tieneFactorRiesgo && finalClassification == DengueClassification.grupoA) {
       finalClassification = DengueClassification.grupoB;
    }
    
    // The doc says for group C: "En caso de que solo tenga una respuesta de esta categoría es del grupo A"
    // This is a bit ambiguous. Let's interpret it as: if you have ONLY one symptom from group C and don't meet other criteria, you are group A.
    // The current logic handles this, as `esGrupoC` requires being `esGrupoB` first.

    return ClassificationResult(
      classification: finalClassification,
      tieneFactorRiesgo: tieneFactorRiesgo,
      classificationName: _classificationNames[finalClassification]!,
      recommendations: _recommendations[finalClassification]!,
    );
  }

  static String getRecommendationsByClassification(DengueClassification classification) {
    return _recommendations[classification] ?? 'No se encontraron recomendaciones.';
  }

  static String getClassificationName(DengueClassification classification) {
    return _classificationNames[classification] ?? 'Clasificación Desconocida';
  }
}
