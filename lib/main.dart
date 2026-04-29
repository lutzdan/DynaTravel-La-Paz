import 'package:flutter/material.dart';

// ============================================
// COLORS & THEME - La Paz Beach/Desert Style
// ============================================

class LaPazTheme {
  // Primary Colors - Ocean & Desert
  static const Color oceanBlue = Color(0xFF0077B6);
  static const Color seaGreen = Color(0xFF00B4D8);
  static const Color sand = Color(0xFFF4E4C1);
  static const Color desertSand = Color(0xFFDEB887);
  static const Color sunsetOrange = Color(0xFFE07A5F);
  static const Color coral = Color(0xFFF77F00);
  
  // Nature & Sustainability
  static const Color natureGreen = Color(0xFF2D6A4F);
  static const Color forestGreen = Color(0xFF40916C);
  static const Color sage = Color(0xFF95D5B2);
  static const Color mint = Color(0xFFB7E4C7);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color lightGray = Color(0xFFE9ECEF);
  static const Color darkGray = Color(0xFF495057);
  static const Color charcoal = Color(0xFF212529);
  
  // Accent Colors
  static const Color gold = Color(0xFFD4A373);
  static const Color turquoise = Color(0xFF48CAE4);
  
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: oceanBlue,
      primary: oceanBlue,
      secondary: seaGreen,
      tertiary: natureGreen,
      surface: white,
      onSurface: charcoal,
    ),
    scaffoldBackgroundColor: offWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: oceanBlue,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: oceanBlue,
        foregroundColor: white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

// ============================================
// TAG DATA MODELS
// ============================================

class TagData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const TagData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.description = '',
  });
}

// Main Interest Tags
final List<TagData> mainInterests = [
  TagData(id: 'playa', name: 'Playa', icon: Icons.beach_access, color: LaPazTheme.turquoise, description: 'Playas y costas'),
  TagData(id: 'naturaleza', name: 'Naturaleza', icon: Icons.park, color: LaPazTheme.forestGreen, description: 'Parques y naturaleza'),
  TagData(id: 'cultura', name: 'Cultura', icon: Icons.museum, color: LaPazTheme.sunsetOrange, description: 'Museos y cultura'),
  TagData(id: 'historia', name: 'Historia', icon: Icons.account_balance, color: LaPazTheme.gold, description: 'Sitios históricos'),
  TagData(id: 'gastronomia', name: 'Gastronomía', icon: Icons.restaurant, color: LaPazTheme.coral, description: 'Comida y restaurantes'),
  TagData(id: 'aventura', name: 'Aventura', icon: Icons.hiking, color: LaPazTheme.natureGreen, description: 'Actividades de aventura'),
  TagData(id: 'vida_nocturna', name: 'Vida Nocturna', icon: Icons.nightlife, color: LaPazTheme.oceanBlue, description: 'Bares y entretenimiento'),
  TagData(id: 'compras', name: 'Compras', icon: Icons.shopping_bag, color: LaPazTheme.desertSand, description: 'Mercados y tiendas'),
  TagData(id: 'relajacion', name: 'Relajación', icon: Icons.spa, color: LaPazTheme.sage, description: 'Bienestar y relax'),
  TagData(id: 'fotografia', name: 'Fotografía', icon: Icons.camera_alt, color: LaPazTheme.seaGreen, description: 'Lugares fotográficos'),
  TagData(id: 'turismo_local', name: 'Turismo Local', icon: Icons.location_city, color: LaPazTheme.mint, description: 'Experiencias locales'),
  TagData(id: 'arte', name: 'Arte', icon: Icons.palette, color: LaPazTheme.sunsetOrange, description: 'Galerías y arte'),
  TagData(id: 'religion', name: 'Religión', icon: Icons.church, color: LaPazTheme.gold, description: 'Iglesias y misiones'),
  TagData(id: 'ecoturismo', name: 'Ecoturismo', icon: Icons.eco, color: LaPazTheme.natureGreen, description: 'Turismo sostenible'),
  TagData(id: 'entretenimiento', name: 'Entretenimiento', icon: Icons.celebration, color: LaPazTheme.coral, description: 'Eventos y actividades'),
];

// Specific Interest Tags
final List<TagData> specificInterests = [
  TagData(id: 'snorkel', name: 'Snorkel', icon: Icons.scuba_diving, color: LaPazTheme.turquoise),
  TagData(id: 'buceo', name: 'Buceo', icon: Icons.pool, color: LaPazTheme.oceanBlue),
  TagData(id: 'senderismo', name: 'Senderismo', icon: Icons.terrain, color: LaPazTheme.forestGreen),
  TagData(id: 'avistamiento_ballenas', name: 'Avistamiento de Ballenas', icon: Icons.water, color: LaPazTheme.seaGreen),
  TagData(id: 'deportes_acuaticos', name: 'Deportes Acuáticos', icon: Icons.surfing, color: LaPazTheme.turquoise),
  TagData(id: 'paseo_lancha', name: 'Paseo en Lancha', icon: Icons.directions_boat, color: LaPazTheme.oceanBlue),
  TagData(id: 'museos', name: 'Museos', icon: Icons.museum, color: LaPazTheme.gold),
  TagData(id: 'galerias_arte', name: 'Galerías de Arte', icon: Icons.image, color: LaPazTheme.sunsetOrange),
  TagData(id: 'misiones', name: 'Misiones', icon: Icons.church, color: LaPazTheme.desertSand),
  TagData(id: 'iglesias', name: 'Iglesias', icon: Icons.account_balance, color: LaPazTheme.gold),
  TagData(id: 'malecón', name: 'Malecón', icon: Icons.waves, color: LaPazTheme.seaGreen),
  TagData(id: 'miradores', name: 'Miradores', icon: Icons.landscape, color: LaPazTheme.natureGreen),
  TagData(id: 'mercados', name: 'Mercados', icon: Icons.storefront, color: LaPazTheme.coral),
  TagData(id: 'restaurantes', name: 'Restaurantes', icon: Icons.restaurant_menu, color: LaPazTheme.sunsetOrange),
  TagData(id: 'cafeterías', name: 'Cafeterías', icon: Icons.coffee, color: LaPazTheme.desertSand),
  TagData(id: 'bares', name: 'Bares', icon: Icons.local_bar, color: LaPazTheme.oceanBlue),
  TagData(id: 'parques', name: 'Parques', icon: Icons.forest, color: LaPazTheme.forestGreen),
  TagData(id: 'playas', name: 'Playas', icon: Icons.beach_access, color: LaPazTheme.turquoise),
  TagData(id: 'marinas', name: 'Marinas', icon: Icons.directions_boat, color: LaPazTheme.seaGreen),
  TagData(id: 'zonas_historicas', name: 'Zonas Históricas', icon: Icons.location_history, color: LaPazTheme.gold),
  TagData(id: 'comida_local', name: 'Comida Local', icon: Icons.lunch_dining, color: LaPazTheme.coral),
  TagData(id: 'mariscos', name: 'Mariscos', icon: Icons.set_meal, color: LaPazTheme.oceanBlue),
  TagData(id: 'souvenirs', name: 'Souvenirs', icon: Icons.card_giftcard, color: LaPazTheme.sage),
];

// Filter Tags - Budget
final List<TagData> budgetTags = [
  TagData(id: 'gratis', name: 'Gratis', icon: Icons.money_off, color: LaPazTheme.forestGreen),
  TagData(id: 'bajo', name: 'Bajo', icon: Icons.attach_money, color: LaPazTheme.sage),
  TagData(id: 'medio', name: 'Medio', icon: Icons.money, color: LaPazTheme.gold),
  TagData(id: 'alto', name: 'Alto', icon: Icons.paid, color: LaPazTheme.sunsetOrange),
  TagData(id: 'premium', name: 'Premium', icon: Icons.diamond, color: LaPazTheme.coral),
];

// Filter Tags - Trip Days
final List<TagData> tripDaysTags = [
  TagData(id: '1', name: '1 Día', icon: Icons.looks_one, color: LaPazTheme.oceanBlue),
  TagData(id: '2', name: '2 Días', icon: Icons.looks_two, color: LaPazTheme.seaGreen),
  TagData(id: '3', name: '3 Días', icon: Icons.looks_3, color: LaPazTheme.turquoise),
  TagData(id: '4', name: '4 Días', icon: Icons.looks_4, color: LaPazTheme.natureGreen),
  TagData(id: '5', name: '5 Días', icon: Icons.looks_5, color: LaPazTheme.forestGreen),
  TagData(id: '7', name: '7 Días', icon: Icons.looks_6, color: LaPazTheme.sage),
];

// Filter Tags - Pace
final List<TagData> paceTags = [
  TagData(id: 'relajado', name: 'Relajado', icon: Icons.self_improvement, color: LaPazTheme.sage),
  TagData(id: 'normal', name: 'Normal', icon: Icons.directions_walk, color: LaPazTheme.seaGreen),
  TagData(id: 'intenso', name: 'Intenso', icon: Icons.directions_run, color: LaPazTheme.sunsetOrange),
];

// Filter Tags - Schedule
final List<TagData> scheduleTags = [
  TagData(id: 'mañana', name: 'Mañana', icon: Icons.wb_sunny, color: LaPazTheme.gold),
  TagData(id: 'tarde', name: 'Tarde', icon: Icons.wb_twilight, color: LaPazTheme.coral),
  TagData(id: 'noche', name: 'Noche', icon: Icons.nightlight, color: LaPazTheme.oceanBlue),
  TagData(id: 'todo_el_dia', name: 'Todo el Día', icon: Icons.schedule, color: LaPazTheme.natureGreen),
];

// Filter Tags - Duration
final List<TagData> durationTags = [
  TagData(id: 'corta', name: 'Corta', icon: Icons.timer, color: LaPazTheme.turquoise),
  TagData(id: 'media', name: 'Media', icon: Icons.hourglass_empty, color: LaPazTheme.seaGreen),
  TagData(id: 'larga', name: 'Larga', icon: Icons.hourglass_full, color: LaPazTheme.natureGreen),
  TagData(id: 'todo_el_dia', name: 'Todo el Día', icon: Icons.calendar_today, color: LaPazTheme.forestGreen),
];

// Filter Tags - Trip Type
final List<TagData> tripTypeTags = [
  TagData(id: 'solo', name: 'Solo', icon: Icons.person, color: LaPazTheme.oceanBlue),
  TagData(id: 'pareja', name: 'Pareja', icon: Icons.favorite, color: LaPazTheme.coral),
  TagData(id: 'amigos', name: 'Amigos', icon: Icons.groups, color: LaPazTheme.seaGreen),
  TagData(id: 'familia', name: 'Familia', icon: Icons.family_restroom, color: LaPazTheme.natureGreen),
  TagData(id: 'niños', name: 'Niños', icon: Icons.child_care, color: LaPazTheme.gold),
  TagData(id: 'adultos_mayores', name: 'Adultos', icon: Icons.elderly, color: LaPazTheme.sage),
];

// Filter Tags - Transport
final List<TagData> transportTags = [
  TagData(id: 'caminando', name: 'Caminando', icon: Icons.directions_walk, color: LaPazTheme.forestGreen),
  TagData(id: 'auto_propio', name: 'Auto Propio', icon: Icons.directions_car, color: LaPazTheme.oceanBlue),
  TagData(id: 'transporte_publico', name: 'Transporte Público', icon: Icons.directions_bus, color: LaPazTheme.seaGreen),
  TagData(id: 'tour_privado', name: 'Tour Privado', icon: Icons.tour, color: LaPazTheme.coral),
];

// Filter Tags - Distance
final List<TagData> distanceTags = [
  TagData(id: 'cerca', name: 'Cerca', icon: Icons.near_me, color: LaPazTheme.forestGreen),
  TagData(id: 'media_distancia', name: 'Media', icon: Icons.radio_button_unchecked, color: LaPazTheme.seaGreen),
  TagData(id: 'lejos', name: 'Lejos', icon: Icons.flight, color: LaPazTheme.oceanBlue),
];

// Filter Tags - Accessibility
final List<TagData> accessibilityTags = [
  TagData(id: 'accesible', name: 'Accesible', icon: Icons.accessible, color: LaPazTheme.natureGreen),
  TagData(id: 'no_accesible', name: 'No Accesible', icon: Icons.accessible_forward, color: LaPazTheme.darkGray),
  TagData(id: 'pet_friendly', name: 'Mascotas', icon: Icons.pets, color: LaPazTheme.coral),
];

// Filter Tags - Availability
final List<TagData> availabilityTags = [
  TagData(id: 'abierto', name: 'Abierto', icon: Icons.lock_open, color: LaPazTheme.forestGreen),
  TagData(id: 'cerrado', name: 'Cerrado', icon: Icons.lock, color: LaPazTheme.darkGray),
  TagData(id: 'requiere_reserva', name: 'Reserva', icon: Icons.event_available, color: LaPazTheme.coral),
];

// ============================================
// MAIN APP WIDGET
// ============================================

void main() {
  runApp(const DynaTravelApp());
}

class DynaTravelApp extends StatelessWidget {
  const DynaTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DynaTravel La Paz',
      debugShowCheckedModeBanner: false,
      theme: LaPazTheme.theme,
      home: const RecommendationScreen(),
    );
  }
}

// ============================================
// MAIN SCREEN
// ============================================

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  int _currentStep = 0;
  
  // Selected tags
  Set<String> selectedMainInterests = {};
  Set<String> selectedSpecificInterests = {};
  
  // Filter selections
  String? selectedBudget;
  String? selectedTripDays;
  String? selectedPace;
  String? selectedSchedule;
  String? selectedDuration;
  String? selectedTripType;
  String? selectedTransport;
  String? selectedDistance;
  String? selectedAccessibility;
  String? selectedAvailability;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),
            // Progress Indicator
            _buildProgressIndicator(),
            // Content
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildIntroSection(),
                  _buildMainInterestsSection(),
                  _buildSpecificInterestsSection(),
                  _buildFiltersSection(),
                  _buildSummarySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            LaPazTheme.oceanBlue,
            LaPazTheme.seaGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo/Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: LaPazTheme.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.explore,
              color: LaPazTheme.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          // Title
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DynaTravel',
                  style: TextStyle(
                    color: LaPazTheme.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'La Paz, B.C.S.',
                  style: TextStyle(
                    color: LaPazTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          // Step indicator text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: LaPazTheme.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentStep + 1}/5',
              style: const TextStyle(
                color: LaPazTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          final isCurrent = index == _currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isActive 
                    ? (isCurrent ? LaPazTheme.oceanBlue : LaPazTheme.seaGreen)
                    : LaPazTheme.lightGray,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ============================================
  // STEP 1: INTRO SECTION
  // ============================================
  
  Widget _buildIntroSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Card
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          // La Paz Info Card
          _buildLaPazInfoCard(),
          const SizedBox(height: 20),
          // Sustainable Tourism Card
          _buildSustainableTourismCard(),
          const SizedBox(height: 30),
          // Start Button
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            LaPazTheme.oceanBlue,
            LaPazTheme.seaGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: LaPazTheme.oceanBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Wave Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LaPazTheme.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.waves,
              color: LaPazTheme.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bienvenido a La Paz',
            style: TextStyle(
              color: LaPazTheme.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Descubre el encanto del Mar de Cortés',
            style: TextStyle(
              color: LaPazTheme.white,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLaPazInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LaPazTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: LaPazTheme.oceanBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_city,
                  color: LaPazTheme.oceanBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Acerca de La Paz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: LaPazTheme.charcoal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Info Content
          _buildInfoRow(Icons.water, 'Ubicación', 'Capital de Baja California Sur, a 1,500 km de Tijuana'),
          const Divider(height: 24),
          _buildInfoRow(Icons.wb_sunny, 'Clima', 'Desértico subtropical. Temperatura promedio: 24°C'),
          const Divider(height: 24),
          _buildInfoRow(Icons.people, 'Población', 'Aproximadamente 250,000 habitantes'),
          const Divider(height: 24),
          _buildInfoRow(Icons.directions_boat, 'Mar', 'Mar de Cortés - El acuario natural más grande del mundo'),
          const Divider(height: 24),
          _buildInfoRow(Icons.history_edu, 'Historia', 'Fundada en 1810, rica herencia cultural y colonial'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: LaPazTheme.seaGreen, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: LaPazTheme.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: LaPazTheme.darkGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSustainableTourismCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LaPazTheme.mint.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: LaPazTheme.forestGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: LaPazTheme.forestGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.eco,
                  color: LaPazTheme.natureGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Turismo Sustentable',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: LaPazTheme.natureGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          const Text(
            'La Paz se compromete con un turismo responsable que protege sus ecosistemas marinos y desierto. Disfruta de experiencias que apoyan la economía local y preservan la belleza natural de la región.',
            style: TextStyle(
              fontSize: 14,
              color: LaPazTheme.charcoal,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Sustainability badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSustainabilityBadge('🌿 Eco-friendly'),
              _buildSustainabilityBadge('🐋 Avistamiento Responsable'),
              _buildSustainabilityBadge('🏖️ Playas Limpias'),
              _buildSustainabilityBadge('🍽️ Gastronomía Local'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: LaPazTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: LaPazTheme.forestGreen.withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: LaPazTheme.natureGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: () => _nextStep(),
      style: ElevatedButton.styleFrom(
        backgroundColor: LaPazTheme.oceanBlue,
        foregroundColor: LaPazTheme.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Comenzar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 24),
        ],
      ),
    );
  }

  // ============================================
  // STEP 2: MAIN INTERESTS
  // ============================================
  
  Widget _buildMainInterestsSection() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                '¿Qué te interesa?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: LaPazTheme.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona tus intereses principales',
                style: TextStyle(
                  fontSize: 20,
                  color: LaPazTheme.darkGray.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        // Tags Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: mainInterests.length,
            itemBuilder: (context, index) {
              final tag = mainInterests[index];
              final isSelected = selectedMainInterests.contains(tag.id);
              return _buildInterestCard(tag, isSelected, () {
                setState(() {
                  if (isSelected) {
                    selectedMainInterests.remove(tag.id);
                  } else {
                    selectedMainInterests.add(tag.id);
                  }
                });
              });
            },
          ),
        ),
        // Navigation Buttons
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildInterestCard(TagData tag, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? tag.color.withOpacity(0.15) : LaPazTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? tag.color : LaPazTheme.lightGray,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: tag.color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tag.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tag.icon,
                        color: tag.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Name
                    Text(
                      tag.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? tag.color : LaPazTheme.charcoal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Selection Circle
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: tag.color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: LaPazTheme.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // STEP 3: SPECIFIC INTERESTS
  // ============================================
  
  Widget _buildSpecificInterestsSection() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Intereses Específicos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: LaPazTheme.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Qué actividades te gustaría hacer?',
                style: TextStyle(
                  fontSize: 14,
                  color: LaPazTheme.darkGray.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        // Tags Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: specificInterests.length,
            itemBuilder: (context, index) {
              final tag = specificInterests[index];
              final isSelected = selectedSpecificInterests.contains(tag.id);
              return _buildSmallInterestCard(tag, isSelected, () {
                setState(() {
                  if (isSelected) {
                    selectedSpecificInterests.remove(tag.id);
                  } else {
                    selectedSpecificInterests.add(tag.id);
                  }
                });
              });
            },
          ),
        ),
        // Navigation Buttons
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildSmallInterestCard(TagData tag, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? tag.color.withOpacity(0.15) : LaPazTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? tag.color : LaPazTheme.lightGray,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: tag.color.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tag.icon,
                      color: tag.color,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tag.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? tag.color : LaPazTheme.charcoal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Selection Circle
            if (isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: tag.color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: LaPazTheme.white,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // STEP 4: FILTERS
  // ============================================
  
  Widget _buildFiltersSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configura tu Viaje',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: LaPazTheme.charcoal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ajusta los filtros para personalizar tu itinerario',
            style: TextStyle(
              fontSize: 14,
              color: LaPazTheme.darkGray.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Budget
          _buildFilterSection('Presupuesto', Icons.attach_money, budgetTags, selectedBudget, (value) => setState(() => selectedBudget = value)),
          const SizedBox(height: 20),
          
          // Trip Days
          _buildFilterSection('Días de Viaje', Icons.calendar_today, tripDaysTags, selectedTripDays, (value) => setState(() => selectedTripDays = value)),
          const SizedBox(height: 20),
          
          // Pace
          _buildFilterSection('Ritmo', Icons.directions_walk, paceTags, selectedPace, (value) => setState(() => selectedPace = value)),
          const SizedBox(height: 20),
          
          // Schedule
          _buildFilterSection('Horario', Icons.schedule, scheduleTags, selectedSchedule, (value) => setState(() => selectedSchedule = value)),
          const SizedBox(height: 20),
          
          // Duration
          _buildFilterSection('Duración', Icons.timer, durationTags, selectedDuration, (value) => setState(() => selectedDuration = value)),
          const SizedBox(height: 20),
          
          // Trip Type
          _buildFilterSection('Tipo de Viaje', Icons.group, tripTypeTags, selectedTripType, (value) => setState(() => selectedTripType = value)),
          const SizedBox(height: 20),
          
          // Transport
          _buildFilterSection('Transporte', Icons.directions_car, transportTags, selectedTransport, (value) => setState(() => selectedTransport = value)),
          const SizedBox(height: 20),
          
          // Distance
          _buildFilterSection('Distancia', Icons.near_me, distanceTags, selectedDistance, (value) => setState(() => selectedDistance = value)),
          const SizedBox(height: 20),
          
          // Accessibility
          _buildFilterSection('Accesibilidad', Icons.accessible, accessibilityTags, selectedAccessibility, (value) => setState(() => selectedAccessibility = value)),
          const SizedBox(height: 20),
          
          // Availability
          _buildFilterSection('Disponibilidad', Icons.event, availabilityTags, selectedAvailability, (value) => setState(() => selectedAvailability = value)),
          const SizedBox(height: 30),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, IconData icon, List<TagData> tags, String? selectedValue, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: LaPazTheme.oceanBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LaPazTheme.charcoal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            final isSelected = selectedValue == tag.id;
            return GestureDetector(
              onTap: () => onSelect(tag.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? tag.color.withOpacity(0.15) : LaPazTheme.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? tag.color : LaPazTheme.lightGray,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tag.icon,
                      color: isSelected ? tag.color : LaPazTheme.darkGray,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tag.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? tag.color : LaPazTheme.charcoal,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.check_circle,
                        color: tag.color,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ============================================
  // STEP 5: SUMMARY
  // ============================================
  
  Widget _buildSummarySection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  LaPazTheme.oceanBlue,
                  LaPazTheme.seaGreen,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: LaPazTheme.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Resumen de tu Viaje',
                  style: TextStyle(
                    color: LaPazTheme.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'La Paz, B.C.S.',
                  style: TextStyle(
                    color: LaPazTheme.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Main Interests Summary
          _buildSummaryCard(
            'Intereses Principales',
            Icons.interests,
            LaPazTheme.oceanBlue,
            selectedMainInterests.map((id) => mainInterests.firstWhere((t) => t.id == id).name).toList(),
          ),
          const SizedBox(height: 16),
          
          // Specific Interests Summary
          _buildSummaryCard(
            'Intereses Específicos',
            Icons.explore,
            LaPazTheme.seaGreen,
            selectedSpecificInterests.map((id) => specificInterests.firstWhere((t) => t.id == id).name).toList(),
          ),
          const SizedBox(height: 16),
          
          // Filters Summary
          _buildFiltersSummary(),
          const SizedBox(height: 30),
          
          // Generate Button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Generando itinerario personalizado...'),
                  backgroundColor: LaPazTheme.oceanBlue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LaPazTheme.natureGreen,
              foregroundColor: LaPazTheme.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 24),
                SizedBox(width: 8),
                Text(
                  'Generar Itinerario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Back Button
          TextButton(
            onPressed: () => _previousStep(),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, color: LaPazTheme.oceanBlue),
                SizedBox(width: 8),
                Text(
                  'Volver a editar',
                  style: TextStyle(
                    color: LaPazTheme.oceanBlue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, IconData icon, Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LaPazTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSummary() {
    final filters = <String>[];
    if (selectedBudget != null) filters.add('Presupuesto: ${budgetTags.firstWhere((t) => t.id == selectedBudget).name}');
    if (selectedTripDays != null) filters.add('Días: ${tripDaysTags.firstWhere((t) => t.id == selectedTripDays).name}');
    if (selectedPace != null) filters.add('Ritmo: ${paceTags.firstWhere((t) => t.id == selectedPace).name}');
    if (selectedSchedule != null) filters.add('Horario: ${scheduleTags.firstWhere((t) => t.id == selectedSchedule).name}');
    if (selectedDuration != null) filters.add('Duración: ${durationTags.firstWhere((t) => t.id == selectedDuration).name}');
    if (selectedTripType != null) filters.add('Viaje: ${tripTypeTags.firstWhere((t) => t.id == selectedTripType).name}');
    if (selectedTransport != null) filters.add('Transporte: ${transportTags.firstWhere((t) => t.id == selectedTransport).name}');
    if (selectedDistance != null) filters.add('Distancia: ${distanceTags.firstWhere((t) => t.id == selectedDistance).name}');
    if (selectedAccessibility != null) filters.add('Accesibilidad: ${accessibilityTags.firstWhere((t) => t.id == selectedAccessibility).name}');
    if (selectedAvailability != null) filters.add('Disponibilidad: ${availabilityTags.firstWhere((t) => t.id == selectedAvailability).name}');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LaPazTheme.mint.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LaPazTheme.forestGreen.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, color: LaPazTheme.natureGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Filtros Aplicados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LaPazTheme.natureGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (filters.isEmpty)
            const Text(
              'Sin filtros configurados',
              style: TextStyle(
                fontSize: 14,
                color: LaPazTheme.darkGray,
              ),
            )
          else
            ...filters.map((filter) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.check, color: LaPazTheme.natureGreen, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    filter,
                    style: const TextStyle(
                      fontSize: 13,
                      color: LaPazTheme.charcoal,
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  // ============================================
  // NAVIGATION
  // ============================================
  
  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LaPazTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _previousStep(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: LaPazTheme.oceanBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: LaPazTheme.oceanBlue),
                    SizedBox(width: 8),
                    Text(
                      'Atrás',
                      style: TextStyle(
                        color: LaPazTheme.oceanBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          // Next Button
          Expanded(
            child: ElevatedButton(
              onPressed: () => _nextStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: LaPazTheme.oceanBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == 4 ? 'Finalizar' : 'Siguiente',
                    style: const TextStyle(
                      color: LaPazTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentStep == 4 ? Icons.check : Icons.arrow_forward,
                    color: LaPazTheme.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }
}
