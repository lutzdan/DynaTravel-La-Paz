// services/tag_normalizer.dart
class TagNormalizer {
  // Mapping español -> inglés (tags de usuario)
  static final Map<String, String> spanishToEnglish = 
  {
    // Preferencias principales
    'playa': 'beach',
    'naturaleza': 'natural_feature',
    'cultura': 'cultural_landmark',
    'historia': 'historical_landmark',
    'gastronomía': 'restaurant',
    'aventura': 'tourist_attraction',
    'vida nocturna': 'night_club',
    'compras': 'shopping_mall',
    'relajación': 'park',
    'fotografía': 'scenic_spot',
    'turismo local': 'tourist_attraction',
    'arte': 'art_gallery',
    'religión': 'church',
    'ecoturismo': 'national_park',
    'entretenimiento': 'amusement_center',

    // Intereses específicos
    'snorkel': 'tourist_attraction',
    'buceo': 'tourist_attraction',
    'senderismo': 'hiking_area',
    'avistamiento de ballenas': 'tourist_attraction',
    'deportes acuáticos': 'beach',
    'paseo en lancha': 'marina',
    'museos': 'museum',
    'galerías de arte': 'art_gallery',
    'misiones': 'historical_landmark',
    'iglesias': 'church',
    'malecón': 'tourist_attraction',
    'miradores': 'observation_deck',
    'mercados': 'market',
    'restaurantes': 'restaurant',
    'cafeterías': 'cafe',
    'bares': 'bar',
    'parques': 'park',
    'playas': 'beach',
    'marinas': 'marina',
    'zonas históricas': 'historical_landmark',
    'comida local': 'restaurant',
    'mariscos': 'seafood_restaurant',
    'souvenirs': 'gift_shop',
  };

  // Mapping inglés -> categorías semánticas (Google tags -> conceptos)
  static final Map<String, String> googleToSemantic = {
    // Cultura/Historia
    'art_gallery': 'arte',
    'art_museum': 'arte',
    'history_museum': 'historia',
    'museum': 'cultura',
    'historical_landmark': 'historia',
    'cultural_landmark': 'cultura',
    'church': 'religión',

    // Naturaleza/Aventura
    'beach': 'playa',
    'national_park': 'naturaleza',
    'hiking_area': 'aventura',
    'marina': 'aventura',

    // Comida
    'restaurant': 'gastronomía',
    'mexican_restaurant': 'gastronomía',
    'seafood_restaurant': 'mariscos',
    'cafe': 'gastronomía',

    // Entretenimiento
    'night_club': 'vida nocturna',
    'bar': 'vida nocturna',
    'shopping_mall': 'compras',
    'market': 'compras',
  };

  // Normalizar tags del usuario (español -> Google tags)
  static List<String> normalizeUserTags(List<String> userTags) {
    return userTags
        .map((tag) => spanishToEnglish[tag.toLowerCase()] ?? tag.toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList();
  }

  // Normalizar tags de Google (Google tags -> tags semánticos en español)
  static List<String> normalizeGoogleTags(List<String> googleTags) {
    return googleTags
        .map((tag) => googleToSemantic[tag.toLowerCase()] ?? tag.toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList();
  }

  // Obtener tags equivalentes bidireccionales
  static Map<String, List<String>> getTagEquivalents() {
    return {
      'playa': ['beach', 'tourist_attraction'],
      'naturaleza': ['national_park', 'natural_feature', 'nature_preserve'],
      'cultura': ['cultural_landmark', 'museum', 'art_gallery'],
      'historia': ['historical_landmark', 'history_museum'],
      'gastronomía': ['restaurant', 'mexican_restaurant', 'seafood_restaurant'],
      'aventura': ['hiking_area', 'tourist_attraction', 'marina'],
      'vida nocturna': ['night_club', 'bar', 'live_music_venue'],
      'compras': ['shopping_mall', 'market', 'gift_shop'],
    };
  }
}
