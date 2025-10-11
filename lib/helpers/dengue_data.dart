import 'dart:developer';

class DiseaseData {
  String name;
  String description;
  Map<String, String> types;
  Map<String, String> symptoms;
  List<String> prevention;
  List<String> transmissionsWays;
  List<String> photos;
  List<String> recomendations;

  DiseaseData({
    required this.name, 
    required this.description, 
    required this.types, 
    required this.symptoms, 
    required this.prevention, 
    required this.transmissionsWays, 
    required this.photos,
    required this.recomendations
  });
}


DiseaseData? findByName(String name) {
  for (DiseaseData d in diseaseData()) {
    log(d.name);
    log(name);
    if (d.name == name) {
      return d;
    }
  }
  return null;
}

List<DiseaseData> diseaseData() {
  List<DiseaseData> diseases = [];
  diseases.add(DiseaseData(
    name: "Dengue", 
    description: "El dengue es una enfermedad causada por un virus que se transmite a las personas a través de la picadura de un mosquito. Es común en zonas donde hay mucho calor y humedad, y puede afectar a personas de todas las edades. Debido a que puede propagarse rápidamente, es importante tomar medidas para prevenirla y controlar los mosquitos que la transmiten. ",
    types: {
      "Dengue sin signos de alarma": "También conocido como dengue clásico, generalmente causa síntomas como fiebre alta, dolor de cabeza intenso, dolor detrás de los ojos, dolores musculares y articulares, y sarpullido.",
      "Dengue con signos de alarma": "Esta categoría busca identificar a los pacientes que necesitan ser hospitalizados para observación. Los signos de alarma incluyen dolor abdominal intenso, vómitos persistentes, sangrado de mucosas (como encías), letargo y mareos.",
      "Dengue grave": "Anteriormente conocido como dengue hemorrágico, es la forma más severa de la enfermedad y requiere atención médica de urgencia. Se caracteriza por sangrado severo, daños en los vasos sanguíneos, dificultad para respirar y una caída drástica de la presión arterial (shock)."
    },
    symptoms: {
      "1": "En esta forma, la persona presenta fiebre alta, generalmente por encima de 38°C, que dura entre 2 y 7 días. Puede sentirse mal, con malestar general, pero no muestra síntomas que indiquen un riesgo inmediato. La fiebre suele bajar a 37.5°C o menos y la persona mejora sin complicaciones.",
      "2": "Aquí, además de la fiebre alta (>38°C) que dura varios días, la persona comienza a mostrar síntomas que alertan sobre un posible empeoramiento. Estos pueden incluir dolor abdominal intenso, vómitos persistentes, sangrado leve, acumulación de líquidos en el cuerpo o cambios en el estado de conciencia. La temperatura puede bajar a 37.5°C o menos cuando inicia esta fase crítica, momento en que se debe prestar especial atención. ",
      "3": "Esta es la forma más seria, donde la persona puede tener problemas muy graves como sangrados importantes, dificultad para respirar o daño en órganos vitales. La fiebre puede disminuir, pero el estado de salud empeora rápidamente. Es una emergencia médica que requiere atención inmediata."
    },
    prevention: [
      "Cambiar frecuentemente el agua de los bebederos de animales y de los floreros. ",
      "Tapar los recipientes con agua, eliminar la basura acumulada en patios y áreas al aire libre, eliminar llantas o almacenamiento en sitios cerrados. ",
      "Utilizar repelentes en las áreas del cuerpo que están descubiertas ",
      "Usar ropa adecuada camisas de manga larga y pantalones largos ",
      "Usar mosquiteros o toldillos en las camas, sobre todo cuando hay pacientes enfermos para evitar que infecten nuevos mosquitos o en los lugares donde duermen los niños. ",
      "Lavar y cepillar tanques y albercas ",
      "Perforar las llantas ubicadas en los parques infantiles que pueden contener aguas estancadas en episodios de lluvia. ",
      "Rellenar con tierra tanques sépticos en desuso, desagües y letrinas abandonadas.  ",
      "Recoger basuras y residuos sólidos en predios y lotes baldíos, mantener el patio limpio y participar en jornadas comunitarias de recolección de inservibles con actividades comunitarias e intersectoriales. "
    ],
    transmissionsWays: [
      "La enfermiedad se transmite d por la picadura de la hembra infectada del mosquito del género Aedes y un huésped susceptible. En colombia se registra como el principal vector de virus el mosquito Aedes aegypti"
    ],
    photos: ["assets/mosquito.jpg"],
    recomendations: [
      "Tapa todas las aguas limpias que estén descubiertas",
      "Usa repelente de insectos",
      "Instala mosquitero para los niños",
      "Protegete con ropa adecuada"
    ]
  ));
  return diseases;
}

// aquí donde estamos pudimos haber tenido dengue y no lo sabemos
// tanto en el magdalena como el país estamos infestados en el dengue

// política de tratamiento de datos
//