// lib/screens/itinerary_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/itinerary.dart';
import '../services/itinerary_generator.dart';
import 'itinerary_editor_screen.dart';

class ItineraryScreen extends StatefulWidget {
  final GeneratedItinerary itinerary;
  final ItineraryGenerator generator;
  final List<String> userInterests;
  final String? budget;
  final String? pace;
  final String? schedule;

  const ItineraryScreen({
    super.key,
    required this.itinerary,
    required this.generator,
    required this.userInterests,
    this.budget,
    this.pace,
    this.schedule,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen>
    with SingleTickerProviderStateMixin {
  int _selectedDay = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openGoogleMaps(ItineraryItem item) async {
    final lat = item.latitude;
    final lng = item.longitude;
    final name = Uri.encodeComponent(item.name);
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$name');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final fallbackUrl = Uri.parse('https://www.google.com/maps?q=$lat,$lng($name)');
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _navigateToEditor() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ItineraryEditorScreen(
          itinerary: widget.itinerary,
          generator: widget.generator,
          userInterests: widget.userInterests,
          budget: widget.budget,
          pace: widget.pace,
          schedule: widget.schedule,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itinerary = widget.itinerary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(itinerary),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildDaySelector(itinerary),
                _buildDayContent(itinerary.days[_selectedDay]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(GeneratedItinerary itinerary) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => _navigateToEditor(),
          icon: const Icon(Icons.edit, color: LaPazTheme.white),
          label: const Text(
            'Editar',
            style: TextStyle(color: LaPazTheme.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                LaPazTheme.oceanBlue,
                LaPazTheme.seaGreen,
                LaPazTheme.turquoise,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: LaPazTheme.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.map,
                          color: LaPazTheme.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tu Itinerario',
                              style: TextStyle(
                                color: LaPazTheme.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              itinerary.destination,
                              style: TextStyle(
                                color: LaPazTheme.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildAppBarStat(
                        Icons.calendar_today,
                        '${itinerary.totalDays} Días',
                      ),
                      const SizedBox(width: 16),
                      _buildAppBarStat(
                        Icons.location_on,
                        '${itinerary.days.fold<int>(0, (sum, d) => sum + d.items.length)} Lugares',
                      ),
                      const SizedBox(width: 16),
                      _buildAppBarStat(
                        Icons.auto_awesome,
                        'Personalizado',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: LaPazTheme.white.withOpacity(0.8), size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: LaPazTheme.white.withOpacity(0.9),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelector(GeneratedItinerary itinerary) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itinerary.days.length,
        itemBuilder: (context, index) {
          final day = itinerary.days[index];
          final isSelected = index == _selectedDay;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          LaPazTheme.oceanBlue,
                          LaPazTheme.seaGreen,
                        ],
                      )
                    : null,
                color: isSelected ? null : LaPazTheme.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.lightGray,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: LaPazTheme.oceanBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Día ${day.dayNumber}',
                    style: TextStyle(
                      color: isSelected ? LaPazTheme.white : LaPazTheme.charcoal,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    day.date,
                    style: TextStyle(
                      color: isSelected
                          ? LaPazTheme.white.withOpacity(0.8)
                          : LaPazTheme.darkGray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayContent(DayItinerary day) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  LaPazTheme.mint.withOpacity(0.3),
                  LaPazTheme.sage.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: LaPazTheme.forestGreen.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: LaPazTheme.forestGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: LaPazTheme.natureGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.theme,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: LaPazTheme.natureGreen,
                        ),
                      ),
                      Text(
                        '${day.items.length} actividades planificadas',
                        style: TextStyle(
                          fontSize: 13,
                          color: LaPazTheme.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...day.items.asMap().entries.map((entry) {
            return _buildTimelineItem(entry.value, entry.key, day.items.length);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(ItineraryItem item, int index, int totalItems) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          item.color,
                          item.color.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: LaPazTheme.white,
                      size: 20,
                    ),
                  ),
                  if (index < totalItems - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: LaPazTheme.lightGray,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildItemCard(item, index),
              ),
            ],
          ),
          if (index < totalItems - 1) const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildItemCard(ItineraryItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LaPazTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.1),
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
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getRelevanceLabel(item.relevanceScore),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 13,
              color: LaPazTheme.darkGray,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildInfoChip(Icons.access_time, item.timeSlot),
              _buildInfoChip(
                Icons.timer,
                '${item.estimatedDurationMinutes} min',
              ),
              _buildInfoChip(
                Icons.location_on_outlined,
                _truncateAddress(item.address),
              ),
              _buildInfoChip(
                Icons.attach_money,
                _getBudgetLabel(item.budgetLevel),
                color: _getBudgetColor(item.budgetLevel),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openGoogleMaps(item),
              icon: const Icon(Icons.map, size: 18),
              label: const Text('Ver en Google Maps'),
              style: OutlinedButton.styleFrom(
                foregroundColor: LaPazTheme.oceanBlue,
                side: const BorderSide(color: LaPazTheme.oceanBlue),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? LaPazTheme.darkGray),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color ?? LaPazTheme.darkGray,
          ),
        ),
      ],
    );
  }

  String _getRelevanceLabel(double score) {
    if (score >= 4.0) return 'Excelente Match';
    if (score >= 3.0) return 'Muy Bueno';
    if (score >= 2.0) return 'Bueno';
    return 'Interesante';
  }

  String _truncateAddress(String address) {
    if (address.length <= 25) return address;
    return '${address.substring(0, 22)}...';
  }

  String _getBudgetLabel(String budget) {
    switch (budget) {
      case 'gratis':
        return 'Gratis';
      case 'bajo':
        return 'Económico';
      case 'medio':
        return 'Moderado';
      case 'alto':
        return 'Premium';
      default:
        return budget;
    }
  }

  Color _getBudgetColor(String budget) {
    switch (budget) {
      case 'gratis':
        return LaPazTheme.forestGreen;
      case 'bajo':
        return LaPazTheme.sage;
      case 'medio':
        return LaPazTheme.gold;
      case 'alto':
        return LaPazTheme.sunsetOrange;
      default:
        return LaPazTheme.darkGray;
    }
  }
}
