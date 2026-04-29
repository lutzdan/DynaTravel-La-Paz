// lib/services/recommendation_service.dart

class RecommendationService {
  final Word2VecService _w2v;

  // Tags enriquecidos por categoría en el JSON
  static const Map<String, List<String>> categoryTags = {
    'playa': [
      'playa',
      'playa',
      'mar',
      'arena',
      'sol',
      'natacion',
      'relajacion',
    ],
    'restaurante': ['comida', 'gastronomia', 'sabor', 'mariscos', 'local'],
    'museo': ['cultura', 'historia', 'arte', 'aprendizaje', 'educacion'],
    'ecoturismo': ['naturaleza', 'aventura', 'senderismo', 'fauna', 'flora'],
    // ... una por categoría del JSON
  };

  double jaccardSimilarity(Set<String> a, Set<String> b) {
    final intersection = a.intersection(b).length;
    final union = a.union(b).length;
    return union == 0 ? 0 : intersection / union;
  }

  List<RankedPlace> rankPlaces(
    List<String> userTags,
    Map<String, dynamic> placesJson,
  ) {
    // 1. Expandir tags del usuario con Word2Vec
    final expandedUserTags = _w2v.expandTags(userTags, topN: 5);
    final userTagSet = expandedUserTags.toSet();

    final results = <RankedPlace>[];

    placesJson.forEach((category, places) {
      for (final place in places) {
        // 2. Construir set de tags del lugar
        final placeTypes = List<String>.from(place['types'] ?? []);
        final categoryTagList = categoryTags[category] ?? [];
        final placeTagSet = {...placeTypes, ...categoryTagList, category};

        // 3. Calcular Jaccard
        final score = jaccardSimilarity(userTagSet, placeTagSet);

        results.add(
          RankedPlace(
            place: place,
            category: category,
            jaccardScore: score,
            placeTagSet: placeTagSet,
            userTagSet: userTagSet,
          ),
        );
      }
    });

    results.sort((a, b) => b.jaccardScore.compareTo(a.jaccardScore));
    return results;
  }
}

class Word2VecService 
{
  
}
