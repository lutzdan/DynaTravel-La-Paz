// services/advanced_word2vec.dart
import 'tag_normalizer.dart';
import 'word2vec_trainer.dart';
import 'package:vector_math/vector_math.dart';
import 'package:ml_linalg/vector.dart' as ml;
import 'dart:math';

class AdvancedWord2Vec {
  final Map<String, List<double>> _embeddings;
  final String _modelPath;

  AdvancedWord2Vec({String modelPath = 'assets/word2vec_tourism.json'})
    : _modelPath = modelPath,
      _embeddings = Word2VecTrainer.loadModel(modelPath);

  List<double> getEmbedding(String word) {
    // Normalizar primero
    final normalizedTags = TagNormalizer.normalizeUserTags([word]);
    if (normalizedTags.isNotEmpty &&
        _embeddings.containsKey(normalizedTags.first)) {
      return List<double>.from(_embeddings[normalizedTags.first]!);
    }

    return _embeddings[word.toLowerCase()] ?? List.filled(50, 0.0);
  }

  List<double> getAverageEmbedding(List<String> words) {
    final embeddings = words
        .expand((word) => [getEmbedding(word)])
        .where((vec) => vec.any((x) => x != 0.0))
        .toList();

    if (embeddings.isEmpty) {
      return List.filled(50, 0.0);
    }

    final avg = List.filled(50, 0.0);
    for (final embedding in embeddings) {
      for (int i = 0; i < 50; i++) {
        avg[i] += embedding[i];
      }
    }

    for (int i = 0; i < 50; i++) {
      avg[i] /= embeddings.length;
    }
    return avg;
  }

  double cosineSimilarity(List<double> a, List<double> b) {
    final vecA = ml.Vector.fromList(a);
    final vecB = ml.Vector.fromList(b);
    return vecA.dot(vecB) / (vecA.length * vecB.length);
  }

  // Encontrar tags más similares
  Map<String, double> findSimilarTags(String query, {int limit = 10}) {
    final queryEmbedding = getEmbedding(query);
    final similarities = <String, double>{};

    for (final entry in _embeddings.entries) {
      final sim = cosineSimilarity(queryEmbedding, entry.value);
      if (sim > 0.3) {
        similarities[entry.key] = sim;
      }
    }

  

    similarities.remove(query);

    final sortedEntries = similarities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries.take(limit));
  }
}
