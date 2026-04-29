// services/word2vec_trainer.dart
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:ml_linalg/vector.dart' as ml;
import 'tag_normalizer.dart';

class Word2VecTrainer {
  static const int VECTOR_SIZE = 50;
  static const int WINDOW_SIZE = 5;
  static const int EPOCHS = 100;
  static const double LEARNING_RATE = 0.025;
  static const double MIN_SIMILARITY = 0.1;

  // Corpus específico para La Paz BCS
  static final List<List<String>> _tourismCorpus = [
    // Playa y naturaleza
    ['playa', 'snorkel', 'buceo', 'mar', 'arena', 'naturaleza', 'relax'],
    ['balandra', 'playa', 'naturaleza', 'fotografia', 'mirador'],
    ['espiritu_santo', 'isla', 'snorkel', 'buceo', 'naturaleza', 'ecoturismo'],

    // Gastronomía
    ['mariscos', 'restaurante', 'gastronomia', 'comida_local', 'camarones'],
    ['tacos', 'mexicano', 'restaurante', 'gastronomia', 'calle'],

    // Cultura e historia
    ['museo', 'cultura', 'historia', 'regional'],
    ['iglesia', 'mision', 'historia', 'religion', 'colonial'],
    ['malecon', 'paseo', 'cultura', 'vida_nocturna', 'restaurantes'],

    // Aventura
    ['senderismo', 'hiking', 'aventura', 'naturaleza', 'montana'],
    ['kayak', 'paseo_lancha', 'aventura', 'mar', 'islas'],

    // Compras y vida nocturna
    ['mercado', 'souvenirs', 'artesanias', 'compras'],
    ['bar', 'vida_nocturna', 'malecon', 'musica'],
  ];

  // Entrenar modelo
  static Map<String, List<double>> trainModel() {
    final embeddings = <String, List<double>>{};
    final vocab = _buildVocabulary();

    // Inicializar embeddings aleatoriamente
    for (final word in vocab) {
      embeddings[word] = List.generate(
        VECTOR_SIZE,
        (i) => (Random().nextDouble() - 0.5) / VECTOR_SIZE,
      );
    }

    // Entrenamiento Skip-gram
    for (int epoch = 0; epoch < EPOCHS; epoch++) {
      double totalLoss = 0.0;

      for (final sentence in _tourismCorpus) {
        for (int i = 0; i < sentence.length; i++) {
          final target = sentence[i];
          final contextWords = _getContext(sentence, i);

          for (final contextWord in contextWords) {
            if (embeddings.containsKey(target) &&
                embeddings.containsKey(contextWord)) {
              totalLoss += _trainPair(embeddings, target, contextWord);
            }
          }
        }
      }

      if (epoch % 20 == 0) {
        print('Epoch $epoch, Loss: ${totalLoss / (vocab.length * EPOCHS)}');
      }
    }

    return embeddings;
  }

  static List<String> _getContext(List<String> sentence, int centerIndex) {
    final context = <String>[];
    final start = max(0, centerIndex - WINDOW_SIZE);
    final end = min(sentence.length, centerIndex + WINDOW_SIZE + 1);

    for (int i = start; i < end; i++) {
      if (i != centerIndex) {
        context.add(sentence[i]);
      }
    }
    return context;
  }

  static double _trainPair(
    Map<String, List<double>> embeddings,
    String target,
    String context,
  ) {

    final targetVec = ml.Vector.fromList(embeddings[target]!);
    final contextVec = ml.Vector.fromList(embeddings[context]!);

    final score = targetVec.dot(contextVec);
    final label = 1.0;

    double totalLoss = 0.0;

    final loss = label - score;
    totalLoss += loss * loss;

    // Actualizar embeddings
    for (int i = 0; i < VECTOR_SIZE; i++) {
      final grad = loss * LEARNING_RATE;
      embeddings[target]![i] += grad * contextVec[i];
      embeddings[context]![i] += grad * targetVec[i];
    }

    return loss * loss;
  }

  static List<String> _buildVocabulary() {
    final vocab = <String>{};

    // Tags normalizados
    vocab.addAll(TagNormalizer.spanishToEnglish.values);

    // Agregar corpus específico
    for (final sentence in _tourismCorpus) {
      vocab.addAll(sentence);
    }

    // Agregar tags importantes de Google Places
    vocab.addAll(['tourist_attraction', 'restaurant', 'beach', 'museum']);

    return vocab.toList();
  }

  // Guardar modelo entrenado
  static void saveModel(Map<String, List<double>> model, String path) {
    final jsonData = <String, dynamic>{};
    for (final entry in model.entries) {
      jsonData[entry.key] = entry.value;
    }

    final file = File(path);
    file.writeAsStringSync(json.encode(jsonData));
    print('Modelo guardado en: $path');
  }

  // Cargar modelo entrenado
  static Map<String, List<double>> loadModel(String path) {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        print('No se encontró modelo entrenado. Entrenando nuevo...');
        final newModel = trainModel();
        saveModel(newModel, path);
        return newModel;
      }

      final jsonString = file.readAsStringSync();
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      final model = <String, List<double>>{};
      for (final entry in jsonData.entries) {
        model[entry.key] = List<double>.from(entry.value);
      }

      print('Modelo cargado desde: $path');
      return model;
    } catch (e) {
      print('Error cargando modelo: $e. Entrenando nuevo...');
      final newModel = trainModel();
      saveModel(newModel, path);
      return newModel;
    }
  }
}
