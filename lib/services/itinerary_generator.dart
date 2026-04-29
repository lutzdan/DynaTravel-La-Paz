// lib/services/itinerary_generator.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/itinerary.dart';
import 'Word2VecServices.dart';
import 'tag_normalizer.dart';

class ItineraryGenerator {
  final Word2VecService w2v;
  final Random _random = Random(42);

  ItineraryGenerator(this.w2v);

  static const Map<String, Map<String, dynamic>> _lapazPlaces = {
    'playas': {
      'icon': Icons.beach_access,
      'color': 'turquoise',
      'places': [
        {'name': 'Playa Balandra', 'description': 'Aguas cristalinas y manglares icónicos de La Paz', 'address': 'Balandra, La Paz BCS', 'duration': 180, 'budget': 'gratis'},
        {'name': 'Playa El Tesoro', 'description': 'Playa tranquila perfecta para snorkel', 'address': 'Carretera a El Tesoro, La Paz', 'duration': 120, 'budget': 'gratis'},
        {'name': 'Playa Pichilingue', 'description': 'Playa amplia con vista al mar de Cortés', 'address': 'Pichilingue, La Paz', 'duration': 120, 'budget': 'gratis'},
        {'name': 'Playa Coromuel', 'description': 'Playa cercana al centro con ambiente familiar', 'address': 'Blvd. Costa Azul, La Paz', 'duration': 90, 'budget': 'gratis'},
        {'name': 'Playa San Alfonso', 'description': 'Playa de arena blanca y aguas tranquilas', 'address': 'Pichilingue, La Paz', 'duration': 120, 'budget': 'gratis'},
      ],
    },
    'ecoturismo': {
      'icon': Icons.eco,
      'color': 'natureGreen',
      'places': [
        {'name': 'Isla Espíritu Santo', 'description': 'Reserva natural con lobos marinos y playas vírgenes', 'address': 'Isla Espíritu Santo, Golfo de California', 'duration': 480, 'budget': 'alto'},
        {'name': 'Isla Partida', 'description': 'Playa de conchas rosadas y snorkel excepcional', 'address': 'Isla Partida, La Paz', 'duration': 360, 'budget': 'alto'},
        {'name': 'Avistamiento de Ballenas', 'description': 'Observación de ballenas grises y jorobadas (temporada)', 'address': 'Bahía de La Paz', 'duration': 240, 'budget': 'alto'},
        {'name': 'Sierra de La Laguna', 'description': 'Reserva de la biosfera con senderos y cascadas', 'address': 'Sierra de La Laguna, BCS', 'duration': 360, 'budget': 'medio'},
        {'name': 'Cueva de Los Murciélagos', 'description': 'Formación rocosa con murciélagos y arte rupestre', 'address': 'Sierra de La Laguna, BCS', 'duration': 180, 'budget': 'medio'},
      ],
    },
    'cultura': {
      'icon': Icons.museum,
      'color': 'sunsetOrange',
      'places': [
        {'name': 'Museo de Historia Natural', 'description': 'Exhibiciones sobre fauna y flora del Mar de Cortés', 'address': 'Centenario s/n, Centro Histórico, La Paz', 'duration': 90, 'budget': 'bajo'},
        {'name': 'Catedral de Nuestra Señora de La Paz', 'description': 'Catedral histórica del siglo XVIII', 'address': 'Plaza de la Constitución, Centro, La Paz', 'duration': 45, 'budget': 'gratis'},
        {'name': 'Misión de Nuestra Señora del Pilar', 'description': 'Antigua misión jesuita con arquitectura colonial', 'address': 'Todos Santos, BCS', 'duration': 60, 'budget': 'gratis'},
        {'name': 'Galería Municipal de Arte', 'description': 'Exposiciones de artistas locales y regionales', 'address': 'Calle Ignacio Zaragoza, Centro, La Paz', 'duration': 60, 'budget': 'gratis'},
        {'name': 'Centro Cultural La Paz', 'description': 'Espacio cultural con talleres y eventos', 'address': 'Blvd. Juárez, La Paz', 'duration': 90, 'budget': 'bajo'},
      ],
    },
    'gastronomia': {
      'icon': Icons.restaurant,
      'color': 'coral',
      'places': [
        {'name': 'Mercado de Mariscos', 'description': 'Mariscos frescos directamente del muelle', 'address': 'Pichilingue, La Paz', 'duration': 90, 'budget': 'medio'},
        {'name': 'Restaurante El Mesquite', 'description': 'Cocina bajacaliforniana con mariscos y carnes', 'address': 'Blvd. Marina Nacional, La Paz', 'duration': 90, 'budget': 'alto'},
        {'name': 'Tacos El Güero', 'description': 'Tacos de pescado y mariscos estilo local', 'address': 'Calle Constitución, Centro, La Paz', 'duration': 45, 'budget': 'bajo'},
        {'name': 'Café del Mar', 'description': 'Cafetería artesanal con vista al malecón', 'address': 'Malecón de La Paz', 'duration': 60, 'budget': 'medio'},
        {'name': 'La Catrina Food Park', 'description': 'Parque gastronómico con variedad de cocina local', 'address': 'Blvd. Forjadores, La Paz', 'duration': 90, 'budget': 'medio'},
      ],
    },
    'aventura': {
      'icon': Icons.hiking,
      'color': 'natureGreen',
      'places': [
        {'name': 'Snorkel en El Morro', 'description': 'Snorkel con lobos marinos en su hábitat natural', 'address': 'Isla San José, La Paz', 'duration': 240, 'budget': 'alto'},
        {'name': 'Kayak en Balandra', 'description': 'Recorrido en kayak por los manglares de Balandra', 'address': 'Playa Balandra, La Paz', 'duration': 120, 'budget': 'medio'},
        {'name': 'Buceo en El Bajo', 'description': 'Sitio de buceo con mantarrayas y tiburones', 'address': 'El Bajo, Bahía de La Paz', 'duration': 180, 'budget': 'alto'},
        {'name': 'Sendero Cerro de la Calavera', 'description': 'Caminata con vista panorámica de La Paz', 'address': 'Cerro de la Calavera, La Paz', 'duration': 120, 'budget': 'gratis'},
        {'name': 'Paseo en Velero al Atardecer', 'description': 'Navegación al atardecer por la bahía', 'address': 'Marina de La Paz', 'duration': 150, 'budget': 'alto'},
      ],
    },
    'vida_nocturna': {
      'icon': Icons.nightlife,
      'color': 'oceanBlue',
      'places': [
        {'name': 'Malecón de La Paz', 'description': 'Paseo nocturno con esculturas y vistas al mar', 'address': 'Malecón, La Paz', 'duration': 90, 'budget': 'gratis'},
        {'name': 'Bar La Bodega', 'description': 'Bar con música en vivo y cocteles artesanales', 'address': 'Calle Topete, Centro, La Paz', 'duration': 120, 'budget': 'medio'},
        {'name': 'Cantina El Navegante', 'description': 'Cantina tradicional con ambiente local', 'address': 'Calle Revolución, Centro, La Paz', 'duration': 120, 'budget': 'bajo'},
        {'name': 'Rooftop Terraza Bahía', 'description': 'Terraza con vista panorámica y música DJ', 'address': 'Hotel Costa Club, La Paz', 'duration': 120, 'budget': 'alto'},
      ],
    },
    'compras': {
      'icon': Icons.shopping_bag,
      'color': 'desertSand',
      'places': [
        {'name': 'Mercado Municipal', 'description': 'Artesanías, souvenirs y productos locales', 'address': 'Calle Constitución, Centro, La Paz', 'duration': 90, 'budget': 'bajo'},
        {'name': 'Galerías La Paz', 'description': 'Centro comercial con tiendas y restaurantes', 'address': 'Blvd. Gustavo Díaz Ordaz, La Paz', 'duration': 120, 'budget': 'medio'},
        {'name': 'Tienda de Artesanías Sudcalifornia', 'description': 'Artesanías tradicionales de la región', 'address': 'Calle Madero, Centro, La Paz', 'duration': 60, 'budget': 'bajo'},
        {'name': 'Plaza Comercial La Paz', 'description': 'Plaza con variedad de tiendas y servicios', 'address': 'Blvd. Forjadores, La Paz', 'duration': 90, 'budget': 'medio'},
      ],
    },
    'relajacion': {
      'icon': Icons.spa,
      'color': 'sage',
      'places': [
        {'name': 'Spa Bahía de La Paz', 'description': 'Tratamientos de relajación con vista al mar', 'address': 'Hotel Hyatt, La Paz', 'duration': 120, 'budget': 'alto'},
        {'name': 'Parque Ecológico El Mezquitito', 'description': 'Parque tranquilo para caminar y relajarse', 'address': 'Col. El Mezquitito, La Paz', 'duration': 90, 'budget': 'gratis'},
        {'name': 'Yoga en la Playa', 'description': 'Sesiones de yoga al amanecer en la playa', 'address': 'Playa Coromuel, La Paz', 'duration': 60, 'budget': 'medio'},
      ],
    },
    'historia': {
      'icon': Icons.account_balance,
      'color': 'gold',
      'places': [
        {'name': 'Centro Histórico de La Paz', 'description': 'Arquitectura colonial y edificios históricos', 'address': 'Centro Histórico, La Paz', 'duration': 120, 'budget': 'gratis'},
        {'name': 'Museo Regional de Antropología', 'description': 'Historia de los pueblos originarios de BCS', 'address': 'Calle Ignacio Altamirano, La Paz', 'duration': 90, 'budget': 'bajo'},
        {'name': 'Palacio Municipal', 'description': 'Edificio histórico con murales locales', 'address': 'Plaza de la Constitución, La Paz', 'duration': 45, 'budget': 'gratis'},
        {'name': 'Monumento a la Bandera', 'description': 'Mirador histórico con vista panorámica', 'address': 'Cerro de la Calavera, La Paz', 'duration': 60, 'budget': 'gratis'},
      ],
    },
  };

  static const Map<String, IconData> _categoryIcons = {
    'playas': Icons.beach_access,
    'ecoturismo': Icons.eco,
    'cultura': Icons.museum,
    'gastronomia': Icons.restaurant,
    'aventura': Icons.hiking,
    'vida_nocturna': Icons.nightlife,
    'compras': Icons.shopping_bag,
    'relajacion': Icons.spa,
    'historia': Icons.account_balance,
  };

  static const Map<String, String> _categoryColors = {
    'playas': 'turquoise',
    'ecoturismo': 'natureGreen',
    'cultura': 'sunsetOrange',
    'gastronomia': 'coral',
    'aventura': 'natureGreen',
    'vida_nocturna': 'oceanBlue',
    'compras': 'desertSand',
    'relajacion': 'sage',
    'historia': 'gold',
  };

  static const Map<String, Color> _colorMap = {
    'turquoise': LaPazTheme.turquoise,
    'natureGreen': LaPazTheme.natureGreen,
    'sunsetOrange': LaPazTheme.sunsetOrange,
    'coral': LaPazTheme.coral,
    'oceanBlue': LaPazTheme.oceanBlue,
    'desertSand': LaPazTheme.desertSand,
    'sage': LaPazTheme.sage,
    'gold': LaPazTheme.gold,
    'seaGreen': LaPazTheme.seaGreen,
    'forestGreen': LaPazTheme.forestGreen,
  };

  static const List<String> _dayThemes = [
    'Descubriendo La Paz',
    'Aventura y Naturaleza',
    'Cultura y Tradición',
    'Sabores del Mar',
    'Relax y Bienestar',
    'Tesoros Escondidos',
    'Experiencias Únicas',
  ];

  List<String> _expandTagsWithWord2Vec(List<String> tags) {
    final expanded = <String>{...tags};

    final normalized = TagNormalizer.normalizeUserTags(tags);
    for (final tag in normalized) {
      expanded.add(tag);
    }

    try {
      final similar = w2v.expandTags(tags, topN: 5, threshold: 0.4);
      expanded.addAll(similar);
    } catch (_) {
    }

    for (final tag in tags) {
      final equivalents = TagNormalizer.getTagEquivalents();
      for (final key in equivalents.keys) {
        if (tag.toLowerCase().contains(key) || key.contains(tag.toLowerCase())) {
          expanded.addAll(equivalents[key]!);
        }
      }
    }

    return expanded.toList();
  }

  double _scorePlace(
    Map<String, dynamic> place,
    String category,
    List<String> expandedTags,
    String? budget,
    String? pace,
  ) {
    double score = 0.0;

    final placeName = (place['name'] as String).toLowerCase();
    final placeDesc = (place['description'] as String).toLowerCase();
    final placeCategory = category.toLowerCase();

    for (final tag in expandedTags) {
      final lowerTag = tag.toLowerCase();
      if (placeName.contains(lowerTag)) score += 2.0;
      if (placeDesc.contains(lowerTag)) score += 1.0;
      if (placeCategory.contains(lowerTag)) score += 1.5;
    }

    for (final tag in expandedTags) {
      try {
        final sim = w2v.similarity(tag, placeName.split(' ').first);
        score += sim * 0.5;
      } catch (_) {}
    }

    if (budget != null) {
      final placeBudget = place['budget'] as String? ?? 'medio';
      if (placeBudget == budget) score += 1.0;
    }

    score += _random.nextDouble() * 0.3;

    return score;
  }

  String _getTimeSlot(int index, String? schedule) {
    if (schedule == 'mañana') {
      final times = ['8:00 AM', '10:00 AM', '12:00 PM'];
      return times[index % times.length];
    } else if (schedule == 'tarde') {
      final times = ['2:00 PM', '4:00 PM', '6:00 PM'];
      return times[index % times.length];
    } else if (schedule == 'noche') {
      final times = ['6:00 PM', '8:00 PM', '10:00 PM'];
      return times[index % times.length];
    }
    final times = ['9:00 AM', '11:00 AM', '1:00 PM', '3:00 PM', '5:00 PM', '7:00 PM'];
    return times[index % times.length];
  }

  int _getDuration(Map<String, dynamic> place, String? pace) {
    final base = place['duration'] as int? ?? 90;
    if (pace == 'relajado') return (base * 1.3).round();
    if (pace == 'intenso') return (base * 0.7).round();
    return base;
  }

  GeneratedItinerary generate({
    required List<String> mainInterests,
    required List<String> specificInterests,
    int days = 3,
    String? budget,
    String? pace,
    String? schedule,
    String? tripType,
    String? transport,
  }) {
    final allTags = [...mainInterests, ...specificInterests];
    if (allTags.isEmpty) {
      allTags.addAll(['playa', 'naturaleza', 'cultura', 'gastronomia']);
    }

    final expandedTags = _expandTagsWithWord2Vec(allTags);

    final scoredPlaces = <Map<String, dynamic>>[];

    for (final entry in _lapazPlaces.entries) {
      final category = entry.key;
      final categoryData = entry.value;
      final places = categoryData['places'] as List<Map<String, dynamic>>;

      for (final place in places) {
        final score = _scorePlace(place, category, expandedTags, budget, pace);
        scoredPlaces.add({
          'place': place,
          'category': category,
          'score': score,
        });
      }
    }

    scoredPlaces.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));

    final itemsPerDay = max(3, 6 - (pace == 'intenso' ? 0 : pace == 'relajado' ? 1 : 0));
    final totalSlots = itemsPerDay * days;

    final selectedPlaces = scoredPlaces.take(min(totalSlots, scoredPlaces.length)).toList();

    final daysItinerary = <DayItinerary>[];
    var itemIndex = 0;

    for (int day = 0; day < days; day++) {
      final dayItems = <ItineraryItem>[];
      final dayItemCount = min(itemsPerDay, selectedPlaces.length - itemIndex);

      for (int i = 0; i < dayItemCount; i++) {
        final data = selectedPlaces[itemIndex];
        final place = data['place'] as Map<String, dynamic>;
        final category = data['category'] as String;
        final score = data['score'] as double;

        final icon = _categoryIcons[category] ?? Icons.location_on;
        final colorName = _categoryColors[category] ?? 'oceanBlue';
        final color = _colorMap[colorName] ?? LaPazTheme.oceanBlue;

        dayItems.add(ItineraryItem(
          name: place['name'] as String,
          category: category,
          description: place['description'] as String,
          address: place['address'] as String,
          relevanceScore: score,
          icon: icon,
          color: color,
          timeSlot: _getTimeSlot(i, schedule),
          estimatedDurationMinutes: _getDuration(place, pace),
          budgetLevel: place['budget'] as String? ?? 'medio',
        ));

        itemIndex++;
      }

      final today = DateTime.now().add(Duration(days: day));
      final dateStr = '${_getMonthName(today.month)} ${today.day}';

      daysItinerary.add(DayItinerary(
        dayNumber: day + 1,
        date: dateStr,
        theme: _dayThemes[day % _dayThemes.length],
        items: dayItems,
      ));
    }

    return GeneratedItinerary(
      destination: 'La Paz, B.C.S.',
      totalDays: days,
      userInterests: allTags,
      days: daysItinerary,
      expandedTags: expandedTags,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return months[month - 1];
  }
}

class LaPazTheme {
  static const Color oceanBlue = Color(0xFF0077B6);
  static const Color seaGreen = Color(0xFF00B4D8);
  static const Color sand = Color(0xFFF4E4C1);
  static const Color desertSand = Color(0xFFDEB887);
  static const Color sunsetOrange = Color(0xFFE07A5F);
  static const Color coral = Color(0xFFF77F00);
  static const Color natureGreen = Color(0xFF2D6A4F);
  static const Color forestGreen = Color(0xFF40916C);
  static const Color sage = Color(0xFF95D5B2);
  static const Color mint = Color(0xFFB7E4C7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color lightGray = Color(0xFFE9ECEF);
  static const Color darkGray = Color(0xFF495057);
  static const Color charcoal = Color(0xFF212529);
  static const Color gold = Color(0xFFD4A373);
  static const Color turquoise = Color(0xFF48CAE4);
}
