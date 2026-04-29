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
        {'name': 'Playa Balandra', 'description': 'Aguas cristalinas y manglares icónicos de La Paz', 'address': 'Balandra, La Paz BCS', 'duration': 180, 'budget': 'gratis', 'lat': 24.1753, 'lng': -110.2290},
        {'name': 'Playa El Tesoro', 'description': 'Playa tranquila perfecta para snorkel', 'address': 'Carretera a El Tesoro, La Paz', 'duration': 120, 'budget': 'gratis', 'lat': 24.1295, 'lng': -110.2356},
        {'name': 'Playa Pichilingue', 'description': 'Playa amplia con vista al mar de Cortés', 'address': 'Pichilingue, La Paz', 'duration': 120, 'budget': 'gratis', 'lat': 24.1180, 'lng': -110.2580},
        {'name': 'Playa Coromuel', 'description': 'Playa cercana al centro con ambiente familiar', 'address': 'Blvd. Costa Azul, La Paz', 'duration': 90, 'budget': 'gratis', 'lat': 24.1506, 'lng': -110.3106},
        {'name': 'Playa San Alfonso', 'description': 'Playa de arena blanca y aguas tranquilas', 'address': 'Pichilingue, La Paz', 'duration': 120, 'budget': 'gratis', 'lat': 24.1230, 'lng': -110.2610},
      ],
    },
    'ecoturismo': {
      'icon': Icons.eco,
      'color': 'natureGreen',
      'places': [
        {'name': 'Isla Espíritu Santo', 'description': 'Reserva natural con lobos marinos y playas vírgenes', 'address': 'Isla Espíritu Santo, Golfo de California', 'duration': 480, 'budget': 'alto', 'lat': 24.4333, 'lng': -110.3500},
        {'name': 'Isla Partida', 'description': 'Playa de conchas rosadas y snorkel excepcional', 'address': 'Isla Partida, La Paz', 'duration': 360, 'budget': 'alto', 'lat': 24.4667, 'lng': -110.3500},
        {'name': 'Avistamiento de Ballenas', 'description': 'Observación de ballenas grises y jorobadas (temporada)', 'address': 'Bahía de La Paz', 'duration': 240, 'budget': 'alto', 'lat': 24.1500, 'lng': -110.3000},
        {'name': 'Sierra de La Laguna', 'description': 'Reserva de la biosfera con senderos y cascadas', 'address': 'Sierra de La Laguna, BCS', 'duration': 360, 'budget': 'medio', 'lat': 23.6167, 'lng': -109.9500},
        {'name': 'Cueva de Los Murciélagos', 'description': 'Formación rocosa con murciélagos y arte rupestre', 'address': 'Sierra de La Laguna, BCS', 'duration': 180, 'budget': 'medio', 'lat': 23.6300, 'lng': -109.9700},
      ],
    },
    'cultura': {
      'icon': Icons.museum,
      'color': 'sunsetOrange',
      'places': [
        {'name': 'Museo de Historia Natural', 'description': 'Exhibiciones sobre fauna y flora del Mar de Cortés', 'address': 'Centenario s/n, Centro Histórico, La Paz', 'duration': 90, 'budget': 'bajo', 'lat': 24.1445, 'lng': -110.3096},
        {'name': 'Catedral de Nuestra Señora de La Paz', 'description': 'Catedral histórica del siglo XVIII', 'address': 'Plaza de la Constitución, Centro, La Paz', 'duration': 45, 'budget': 'gratis', 'lat': 24.1443, 'lng': -110.3102},
        {'name': 'Misión de Nuestra Señora del Pilar', 'description': 'Antigua misión jesuita con arquitectura colonial', 'address': 'Todos Santos, BCS', 'duration': 60, 'budget': 'gratis', 'lat': 23.4245, 'lng': -110.2258},
        {'name': 'Galería Municipal de Arte', 'description': 'Exposiciones de artistas locales y regionales', 'address': 'Calle Ignacio Zaragoza, Centro, La Paz', 'duration': 60, 'budget': 'gratis', 'lat': 24.1440, 'lng': -110.3085},
        {'name': 'Centro Cultural La Paz', 'description': 'Espacio cultural con talleres y eventos', 'address': 'Blvd. Juárez, La Paz', 'duration': 90, 'budget': 'bajo', 'lat': 24.1467, 'lng': -110.3012},
      ],
    },
    'gastronomia': {
      'icon': Icons.restaurant,
      'color': 'coral',
      'places': [
        {'name': 'Mercado de Mariscos', 'description': 'Mariscos frescos directamente del muelle', 'address': 'Pichilingue, La Paz', 'duration': 90, 'budget': 'medio', 'lat': 24.1170, 'lng': -110.2550},
        {'name': 'Restaurante El Mesquite', 'description': 'Cocina bajacaliforniana con mariscos y carnes', 'address': 'Blvd. Marina Nacional, La Paz', 'duration': 90, 'budget': 'alto', 'lat': 24.1510, 'lng': -110.3120},
        {'name': 'Tacos El Güero', 'description': 'Tacos de pescado y mariscos estilo local', 'address': 'Calle Constitución, Centro, La Paz', 'duration': 45, 'budget': 'bajo', 'lat': 24.1450, 'lng': -110.3090},
        {'name': 'Café del Mar', 'description': 'Cafetería artesanal con vista al malecón', 'address': 'Malecón de La Paz', 'duration': 60, 'budget': 'medio', 'lat': 24.1460, 'lng': -110.3130},
        {'name': 'La Catrina Food Park', 'description': 'Parque gastronómico con variedad de cocina local', 'address': 'Blvd. Forjadores, La Paz', 'duration': 90, 'budget': 'medio', 'lat': 24.1530, 'lng': -110.2960},
      ],
    },
    'aventura': {
      'icon': Icons.hiking,
      'color': 'natureGreen',
      'places': [
        {'name': 'Snorkel en El Morro', 'description': 'Snorkel con lobos marinos en su hábitat natural', 'address': 'Isla San José, La Paz', 'duration': 240, 'budget': 'alto', 'lat': 24.2500, 'lng': -110.1500},
        {'name': 'Kayak en Balandra', 'description': 'Recorrido en kayak por los manglares de Balandra', 'address': 'Playa Balandra, La Paz', 'duration': 120, 'budget': 'medio', 'lat': 24.1753, 'lng': -110.2290},
        {'name': 'Buceo en El Bajo', 'description': 'Sitio de buceo con mantarrayas y tiburones', 'address': 'El Bajo, Bahía de La Paz', 'duration': 180, 'budget': 'alto', 'lat': 24.2000, 'lng': -110.2500},
        {'name': 'Sendero Cerro de la Calavera', 'description': 'Caminata con vista panorámica de La Paz', 'address': 'Cerro de la Calavera, La Paz', 'duration': 120, 'budget': 'gratis', 'lat': 24.1550, 'lng': -110.2900},
        {'name': 'Paseo en Velero al Atardecer', 'description': 'Navegación al atardecer por la bahía', 'address': 'Marina de La Paz', 'duration': 150, 'budget': 'alto', 'lat': 24.1480, 'lng': -110.3150},
      ],
    },
    'vida_nocturna': {
      'icon': Icons.nightlife,
      'color': 'oceanBlue',
      'places': [
        {'name': 'Malecón de La Paz', 'description': 'Paseo nocturno con esculturas y vistas al mar', 'address': 'Malecón, La Paz', 'duration': 90, 'budget': 'gratis', 'lat': 24.1458, 'lng': -110.3140},
        {'name': 'Bar La Bodega', 'description': 'Bar con música en vivo y cocteles artesanales', 'address': 'Calle Topete, Centro, La Paz', 'duration': 120, 'budget': 'medio', 'lat': 24.1440, 'lng': -110.3095},
        {'name': 'Cantina El Navegante', 'description': 'Cantina tradicional con ambiente local', 'address': 'Calle Revolución, Centro, La Paz', 'duration': 120, 'budget': 'bajo', 'lat': 24.1435, 'lng': -110.3088},
        {'name': 'Rooftop Terraza Bahía', 'description': 'Terraza con vista panorámica y música DJ', 'address': 'Hotel Costa Club, La Paz', 'duration': 120, 'budget': 'alto', 'lat': 24.1500, 'lng': -110.3135},
      ],
    },
    'compras': {
      'icon': Icons.shopping_bag,
      'color': 'desertSand',
      'places': [
        {'name': 'Mercado Municipal', 'description': 'Artesanías, souvenirs y productos locales', 'address': 'Calle Constitución, Centro, La Paz', 'duration': 90, 'budget': 'bajo', 'lat': 24.1448, 'lng': -110.3080},
        {'name': 'Galerías La Paz', 'description': 'Centro comercial con tiendas y restaurantes', 'address': 'Blvd. Gustavo Díaz Ordaz, La Paz', 'duration': 120, 'budget': 'medio', 'lat': 24.1520, 'lng': -110.2970},
        {'name': 'Tienda de Artesanías Sudcalifornia', 'description': 'Artesanías tradicionales de la región', 'address': 'Calle Madero, Centro, La Paz', 'duration': 60, 'budget': 'bajo', 'lat': 24.1442, 'lng': -110.3092},
        {'name': 'Plaza Comercial La Paz', 'description': 'Plaza con variedad de tiendas y servicios', 'address': 'Blvd. Forjadores, La Paz', 'duration': 90, 'budget': 'medio', 'lat': 24.1535, 'lng': -110.2950},
      ],
    },
    'relajacion': {
      'icon': Icons.spa,
      'color': 'sage',
      'places': [
        {'name': 'Spa Bahía de La Paz', 'description': 'Tratamientos de relajación con vista al mar', 'address': 'Hotel Hyatt, La Paz', 'duration': 120, 'budget': 'alto', 'lat': 24.1515, 'lng': -110.3130},
        {'name': 'Parque Ecológico El Mezquitito', 'description': 'Parque tranquilo para caminar y relajarse', 'address': 'Col. El Mezquitito, La Paz', 'duration': 90, 'budget': 'gratis', 'lat': 24.1390, 'lng': -110.3020},
        {'name': 'Yoga en la Playa', 'description': 'Sesiones de yoga al amanecer en la playa', 'address': 'Playa Coromuel, La Paz', 'duration': 60, 'budget': 'medio', 'lat': 24.1506, 'lng': -110.3106},
      ],
    },
    'historia': {
      'icon': Icons.account_balance,
      'color': 'gold',
      'places': [
        {'name': 'Centro Histórico de La Paz', 'description': 'Arquitectura colonial y edificios históricos', 'address': 'Centro Histórico, La Paz', 'duration': 120, 'budget': 'gratis', 'lat': 24.1445, 'lng': -110.3100},
        {'name': 'Museo Regional de Antropología', 'description': 'Historia de los pueblos originarios de BCS', 'address': 'Calle Ignacio Altamirano, La Paz', 'duration': 90, 'budget': 'bajo', 'lat': 24.1442, 'lng': -110.3085},
        {'name': 'Palacio Municipal', 'description': 'Edificio histórico con murales locales', 'address': 'Plaza de la Constitución, La Paz', 'duration': 45, 'budget': 'gratis', 'lat': 24.1444, 'lng': -110.3101},
        {'name': 'Monumento a la Bandera', 'description': 'Mirador histórico con vista panorámica', 'address': 'Cerro de la Calavera, La Paz', 'duration': 60, 'budget': 'gratis', 'lat': 24.1550, 'lng': -110.2900},
      ],
    },
  };

  static const Map<String, List<String>> _alternatives = {
    'Playa Balandra': ['Playa El Tesoro', 'Playa San Alfonso'],
    'Playa El Tesoro': ['Playa Balandra', 'Playa Coromuel'],
    'Playa Pichilingue': ['Playa San Alfonso', 'Playa Coromuel'],
    'Playa Coromuel': ['Playa Pichilingue', 'Playa El Tesoro'],
    'Playa San Alfonso': ['Playa Pichilingue', 'Playa Balandra'],
    'Isla Espíritu Santo': ['Isla Partida', 'Snorkel en El Morro'],
    'Isla Partida': ['Isla Espíritu Santo', 'Buceo en El Bajo'],
    'Avistamiento de Ballenas': ['Paseo en Velero al Atardecer', 'Kayak en Balandra'],
    'Sierra de La Laguna': ['Cueva de Los Murciélagos', 'Sendero Cerro de la Calavera'],
    'Cueva de Los Murciélagos': ['Sierra de La Laguna', 'Sendero Cerro de la Calavera'],
    'Museo de Historia Natural': ['Museo Regional de Antropología', 'Galería Municipal de Arte'],
    'Catedral de Nuestra Señora de La Paz': ['Palacio Municipal', 'Centro Histórico de La Paz'],
    'Misión de Nuestra Señora del Pilar': ['Centro Histórico de La Paz', 'Galería Municipal de Arte'],
    'Galería Municipal de Arte': ['Museo de Historia Natural', 'Centro Cultural La Paz'],
    'Centro Cultural La Paz': ['Museo de Historia Natural', 'Galería Municipal de Arte'],
    'Mercado de Mariscos': ['Tacos El Güero', 'La Catrina Food Park'],
    'Restaurante El Mesquite': ['Café del Mar', 'La Catrina Food Park'],
    'Tacos El Güero': ['Mercado de Mariscos', 'La Catrina Food Park'],
    'Café del Mar': ['Restaurante El Mesquite', 'Bar La Bodega'],
    'La Catrina Food Park': ['Mercado de Mariscos', 'Restaurante El Mesquite'],
    'Snorkel en El Morro': ['Buceo en El Bajo', 'Kayak en Balandra'],
    'Kayak en Balandra': ['Snorkel en El Morro', 'Paseo en Velero al Atardecer'],
    'Buceo en El Bajo': ['Snorkel en El Morro', 'Isla Partida'],
    'Sendero Cerro de la Calavera': ['Monumento a la Bandera', 'Sierra de La Laguna'],
    'Paseo en Velero al Atardecer': ['Avistamiento de Ballenas', 'Kayak en Balandra'],
    'Malecón de La Paz': ['Café del Mar', 'Rooftop Terraza Bahía'],
    'Bar La Bodega': ['Cantina El Navegante', 'Rooftop Terraza Bahía'],
    'Cantina El Navegante': ['Bar La Bodega', 'Malecón de La Paz'],
    'Rooftop Terraza Bahía': ['Bar La Bodega', 'Malecón de La Paz'],
    'Mercado Municipal': ['Tienda de Artesanías Sudcalifornia', 'Galerías La Paz'],
    'Galerías La Paz': ['Plaza Comercial La Paz', 'Mercado Municipal'],
    'Tienda de Artesanías Sudcalifornia': ['Mercado Municipal', 'Galerías La Paz'],
    'Plaza Comercial La Paz': ['Galerías La Paz', 'Mercado Municipal'],
    'Spa Bahía de La Paz': ['Yoga en la Playa', 'Parque Ecológico El Mezquitito'],
    'Parque Ecológico El Mezquitito': ['Yoga en la Playa', 'Spa Bahía de La Paz'],
    'Yoga en la Playa': ['Spa Bahía de La Paz', 'Parque Ecológico El Mezquitito'],
    'Centro Histórico de La Paz': ['Catedral de Nuestra Señora de La Paz', 'Palacio Municipal'],
    'Museo Regional de Antropología': ['Museo de Historia Natural', 'Centro Histórico de La Paz'],
    'Palacio Municipal': ['Catedral de Nuestra Señora de La Paz', 'Centro Histórico de La Paz'],
    'Monumento a la Bandera': ['Sendero Cerro de la Calavera', 'Centro Histórico de La Paz'],
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

  ItineraryItem _createItemFromData(Map<String, dynamic> data, String category, double score) {
    final place = data['place'] as Map<String, dynamic>;
    final icon = _categoryIcons[category] ?? Icons.location_on;
    final colorName = _categoryColors[category] ?? 'oceanBlue';
    final color = _colorMap[colorName] ?? LaPazTheme.oceanBlue;
    final name = place['name'] as String;
    final alts = _alternatives[name] ?? [];
    final isSponsored = bool;

    return ItineraryItem(
      id: '${category}_${name.toLowerCase().replaceAll(' ', '_')}_${_random.nextInt(99999)}',
      name: name,
      category: category,
      description: place['description'] as String,
      address: place['address'] as String,
      relevanceScore: score,
      icon: icon,
      color: color,
      timeSlot: '9:00 AM',
      estimatedDurationMinutes: place['duration'] as int? ?? 90,
      budgetLevel: place['budget'] as String? ?? 'medio',
      latitude: (place['lat'] as num?)?.toDouble() ?? 24.1445,
      longitude: (place['lng'] as num?)?.toDouble() ?? -110.3100,
      alternativeNames: alts,
    );
  }

  List<String> _expandTagsWithWord2Vec(List<String> tags) {
    final expanded = <String>{...tags};

    final normalized = TagNormalizer.normalizeUserTags(tags);
    for (final tag in normalized) {
      expanded.add(tag);
    }

    try {
      final similar = w2v.expandTags(tags, topN: 5, threshold: 0.4);
      expanded.addAll(similar);
    } catch (_) {}

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

    print(expandedTags);

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

  Map<String, IconData> get allCategoryIcons => _categoryIcons;
  Map<String, Color> get allColorMap => _colorMap;
  Map<String, Map<String, dynamic>> get allPlaces => _lapazPlaces;
  Map<String, List<String>> get allAlternatives => _alternatives;

  List<ItineraryItem> getAvailablePlaces(String? category, String? budget, List<String> userInterests) {
    final items = <ItineraryItem>[];
    final expanded = _expandTagsWithWord2Vec(userInterests);

    for (final entry in _lapazPlaces.entries) {
      if (category != null && entry.key != category) continue;
      final cat = entry.key;
      final places = entry.value['places'] as List<Map<String, dynamic>>;

      for (final place in places) {
        final score = _scorePlace(place, cat, expanded, budget, null);
        items.add(_createItemFromData({'place': place}, cat, score));
      }
    }

    items.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return items;
  }

  ItineraryItem? findPlaceByName(String name) {
    for (final entry in _lapazPlaces.entries) {
      final category = entry.key;
      final places = entry.value['places'] as List<Map<String, dynamic>>;

      for (final place in places) {
        if ((place['name'] as String) == name) {
          final score = 0.0;
          return _createItemFromData({'place': place}, category, score);
        }
      }
    }
    return null;
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

  ItineraryItem _createMealItem(String name, String category, String timeSlot, int duration, String budget) {
    return ItineraryItem(
      id: 'meal_${category}_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(9999)}',
      name: name,
      category: category,
      description: 'Hora de $name',
      address: 'La Paz, B.C.S.',
      relevanceScore: 0.0,
      icon: Icons.restaurant,
      color: LaPazTheme.coral,
      timeSlot: timeSlot,
      estimatedDurationMinutes: duration,
      budgetLevel: budget,
      latitude: 24.1445,
      longitude: -110.3100,
      alternativeNames: [],
    );
  }

  int _getActivitiesPerSegment(String? pace) {
    switch (pace) {
      case 'relajado':
        return 1;
      case 'intenso':
        return 3 + _random.nextInt(2);
      default:
        return 2 + _random.nextInt(2);
    }
  }

  String _getTimeSlotForSegment(String segment, int index) {
    switch (segment) {
      case 'morning':
        final times = ['9:30 AM', '10:30 AM', '11:30 AM', '12:00 PM'];
        return times[index % times.length];
      case 'afternoon':
        final times = ['2:30 PM', '3:30 PM', '4:30 PM', '5:30 PM'];
        return times[index % times.length];
      case 'evening':
        final times = ['8:30 PM', '9:30 PM', '10:30 PM'];
        return times[index % times.length];
      default:
        return '12:00 PM';
    }
  }

  List<String> _buildDayTemplate(String? pace, String? schedule) {
    final template = <String>[];
    final activitiesPerSegment = _getActivitiesPerSegment(pace);

    final includeBreakfast = schedule == null || schedule == 'todo_el_dia' || schedule == 'mañana';
    final includeLunch = schedule == null || schedule == 'todo_el_dia' || schedule == 'tarde';
    final includeDinner = schedule == null || schedule == 'todo_el_dia' || schedule == 'noche';

    if (includeBreakfast) {
      template.add('breakfast');
      for (int i = 0; i < activitiesPerSegment; i++) {
        template.add('activity_morning');
      }
    }

    if (includeLunch) {
      template.add('lunch');
      for (int i = 0; i < activitiesPerSegment; i++) {
        template.add('activity_afternoon');
      }
    }

    if (includeDinner) {
      template.add('dinner');
    }

    return template;
  }

  String _getTimeSlotForTemplateItem(String templateItem, int index) {
    switch (templateItem) {
      case 'breakfast':
        return '8:00 AM';
      case 'lunch':
        return '1:00 PM';
      case 'dinner':
        return '7:00 PM';
      case 'activity_morning':
        final times = ['9:30 AM', '10:30 AM', '11:30 AM', '12:00 PM'];
        return times[index % times.length];
      case 'activity_afternoon':
        final times = ['2:30 PM', '3:30 PM', '4:30 PM', '5:30 PM'];
        return times[index % times.length];
      default:
        return '12:00 PM';
    }
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

    final dayTemplate = _buildDayTemplate(pace, schedule);
    final activitySlots = dayTemplate.where((item) => item.startsWith('activity')).length;
    final totalActivitySlots = activitySlots * days;

    final selectedPlaces = scoredPlaces.take(min(totalActivitySlots, scoredPlaces.length)).toList();

    final daysItinerary = <DayItinerary>[];
    var activityIndex = 0;

    for (int day = 0; day < days; day++) {
      final dayItems = <ItineraryItem>[];
      var morningActivityCount = 0;
      var afternoonActivityCount = 0;
      var sponsoredSet = false;

      for (int t = 0; t < dayTemplate.length; t++) {
        final templateItem = dayTemplate[t];

        if (templateItem == 'breakfast') {
          dayItems.add(_createMealItem('Desayuno', 'gastronomia', '8:00 AM', 60, 'bajo'));
        } else if (templateItem == 'lunch') {
          dayItems.add(_createMealItem('Comida', 'gastronomia', '1:00 PM', 90, 'medio'));
        } else if (templateItem == 'dinner') {
          dayItems.add(_createMealItem('Cena', 'gastronomia', '7:00 PM', 90, 'medio'));
        } else if (templateItem.startsWith('activity')) {
          if (activityIndex < selectedPlaces.length) {
            final data = selectedPlaces[activityIndex];
            final place = data['place'] as Map<String, dynamic>;
            final category = data['category'] as String;
            final score = data['score'] as double;

            final item = _createItemFromData(data, category, score);
            item.timeSlot = _getTimeSlotForTemplateItem(templateItem, templateItem == 'activity_morning' ? morningActivityCount++ : afternoonActivityCount++);
            item.estimatedDurationMinutes = _getDuration(place, pace);

            if (!sponsoredSet) {
              item.isSponsored = true;
              sponsoredSet = true;
            }

            dayItems.add(item);

            activityIndex++;
          }
        }
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
