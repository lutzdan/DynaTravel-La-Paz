// lib/services/word2vec_service.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class Word2VecService {
  // Mapa palabra → vector (cargado desde el JSON)
  Map<String, List<double>> _vectors = {};
  int _dimensions = 100;
  bool _isLoaded = false;

  // Carga el modelo desde assets — llama esto una sola vez al iniciar la app
  Future<void> loadModel() async {
    if (_isLoaded) return;

    final raw = await rootBundle.loadString('assets/word2vec_tourism.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;

    _dimensions = json['dimensions'] as int;

    final rawVectors = json['vectors'] as Map<String, dynamic>;
    _vectors = rawVectors.map(
      (word, vec) => MapEntry(
        word.toLowerCase(),
        (vec as List).map((v) => (v as num).toDouble()).toList(),
      ),
    );

    _isLoaded = true;
  }

  // Verifica que el modelo esté cargado antes de operar
  void _assertLoaded() {
    if (!_isLoaded) {
      throw StateError(
        'Word2VecService no inicializado. Llama await loadModel() primero.',
      );
    }
  }

  // Vector de una palabra (vector cero si no existe en vocabulario)
  List<double> getVector(String word) {
    _assertLoaded();
    return _vectors[word.toLowerCase()] ?? List.filled(_dimensions, 0.0);
  }

  bool contains(String word) {
    _assertLoaded();
    return _vectors.containsKey(word.toLowerCase());
  }

  // Similitud coseno entre dos palabras — retorna 0.0 a 1.0
  double similarity(String wordA, String wordB) {
    _assertLoaded();
    final a = getVector(wordA);
    final b = getVector(wordB);
    return _cosineSimilarity(a, b);
  }

  // Palabras más similares a una dada
  Map<String, double> findSimilar(String word, {int topN = 8}) {
    _assertLoaded();
    final vec = getVector(word);

    // Si la palabra no existe en el vocabulario, retorna vacío
    if (vec.every((v) => v == 0.0)) return {};

    final scores = <String, double>{};
    for (final entry in _vectors.entries) {
      if (entry.key == word.toLowerCase()) continue;
      scores[entry.key] = _cosineSimilarity(vec, entry.value);
    }

    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(topN));
  }

  // Expande una lista de tags con palabras semánticamente cercanas.
  // Es el método que usa RecommendationService.
  List<String> expandTags(
    List<String> tags, {
    int topN = 3,
    double threshold = 0.55,
  }) {
    _assertLoaded();
    final expanded = <String>{...tags.map((t) => t.toLowerCase())};

    for (final tag in tags) {
      final similar = findSimilar(tag, topN: topN + 5);
      for (final entry in similar.entries) {
        if (entry.value >= threshold) {
          expanded.add(entry.key);
        }
      }
    }

    return expanded.toList();
  }

  // Similitud semántica promedio entre dos sets de tags.
  // Útil si quieres reemplazar o complementar Jaccard con similitud vectorial.
  double setSimiliarity(List<String> tagsA, List<String> tagsB) {
    _assertLoaded();
    if (tagsA.isEmpty || tagsB.isEmpty) return 0.0;

    double total = 0.0;
    int count = 0;

    for (final a in tagsA) {
      double best = 0.0;
      for (final b in tagsB) {
        final s = similarity(a, b);
        if (s > best) best = s;
      }
      total += best;
      count++;
    }

    return count == 0 ? 0.0 : total / count;
  }

  // --- interno ---

  static double _cosineSimilarity(List<double> a, List<double> b) {
    double dot = 0.0, normA = 0.0, normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    if (normA == 0 || normB == 0) return 0.0;
    return dot / (sqrt(normA) * sqrt(normB));
  }
}