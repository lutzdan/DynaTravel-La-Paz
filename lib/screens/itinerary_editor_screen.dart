// lib/screens/itinerary_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/itinerary.dart';
import '../services/itinerary_generator.dart';

class ItineraryEditorScreen extends StatefulWidget {
  final GeneratedItinerary itinerary;
  final ItineraryGenerator generator;
  final List<String> userInterests;
  final String? budget;
  final String? pace;
  final String? schedule;

  const ItineraryEditorScreen({
    super.key,
    required this.itinerary,
    required this.generator,
    required this.userInterests,
    this.budget,
    this.pace,
    this.schedule,
  });

  @override
  State<ItineraryEditorScreen> createState() => _ItineraryEditorScreenState();
}

class _ItineraryEditorScreenState extends State<ItineraryEditorScreen> {
  int _selectedDay = 0;
  List<ItineraryItem> _suggestions = [];
  bool _loadingSuggestions = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
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

  void _loadSuggestions() {
    setState(() {
      _loadingSuggestions = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      final suggestions = widget.generator.getAvailablePlaces(
        _selectedCategory,
        widget.budget,
        widget.userInterests,
      );

      final currentDay = widget.itinerary.days[_selectedDay];
      final currentIds = currentDay.items.map((i) => i.name).toSet();
      final filtered = suggestions.where((s) => !currentIds.contains(s.name)).toList();

      setState(() {
        _suggestions = filtered.take(15).toList();
        _loadingSuggestions = false;
      });
    });
  }

  void _swapActivity(int itemIndex, ItineraryItem newActivity) {
    setState(() {
      final day = widget.itinerary.days[_selectedDay];
      final oldItem = day.items[itemIndex];
      newActivity.timeSlot = oldItem.timeSlot;
      newActivity.estimatedDurationMinutes = oldItem.estimatedDurationMinutes;
      day.items[itemIndex] = newActivity;
      _suggestions.removeWhere((s) => s.name == newActivity.name);
      _suggestions.add(oldItem);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Actividad cambiada a "${newActivity.name}"'),
        backgroundColor: LaPazTheme.natureGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addActivity(ItineraryItem activity) {
    setState(() {
      final day = widget.itinerary.days[_selectedDay];
      final lastTime = day.items.isNotEmpty ? day.items.last.timeSlot : '9:00 AM';
      activity.timeSlot = _getNextTime(lastTime);
      day.items.add(activity);
      _suggestions.removeWhere((s) => s.name == activity.name);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${activity.name}" agregado al itinerario'),
        backgroundColor: LaPazTheme.natureGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeActivity(int index) {
    final day = widget.itinerary.days[_selectedDay];
    final removed = day.items.removeAt(index);

    setState(() {
      _suggestions.add(removed);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${removed.name}" removido'),
        backgroundColor: LaPazTheme.sunsetOrange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _moveActivity(int index, int direction) {
    final day = widget.itinerary.days[_selectedDay];
    final newIndex = index + direction;

    if (newIndex < 0 || newIndex >= day.items.length) return;

    setState(() {
      final temp = day.items[index];
      day.items[index] = day.items[newIndex];
      day.items[newIndex] = temp;

      final tempTime = day.items[index].timeSlot;
      day.items[index].timeSlot = day.items[newIndex].timeSlot;
      day.items[newIndex].timeSlot = tempTime;
    });
  }

  void _editTime(int index) {
    final day = widget.itinerary.days[_selectedDay];
    final item = day.items[index];

    showDialog(
      context: context,
      builder: (context) => _TimePickerDialog(
        currentTime: item.timeSlot,
        onTimeSelected: (time) {
          setState(() {
            item.timeSlot = time;
          });
        },
      ),
    );
  }

  void _editDuration(int index) {
    final day = widget.itinerary.days[_selectedDay];
    final item = day.items[index];

    showDialog(
      context: context,
      builder: (context) => _DurationPickerDialog(
        currentDuration: item.estimatedDurationMinutes,
        onDurationSelected: (duration) {
          setState(() {
            item.estimatedDurationMinutes = duration;
          });
        },
      ),
    );
  }

  String _getNextTime(String currentTime) {
    final times = ['8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM'];
    final currentIndex = times.indexOf(currentTime);
    if (currentIndex >= 0 && currentIndex < times.length - 1) {
      return times[currentIndex + 1];
    }
    return '9:00 AM';
  }

  @override
  Widget build(BuildContext context) {
    final itinerary = widget.itinerary;
    final currentDay = itinerary.days[_selectedDay];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(itinerary),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildDaySelector(itinerary),
                _buildSectionHeader('Tu Itinerario - Día ${currentDay.dayNumber}'),
                ...currentDay.items.asMap().entries.map((entry) {
                  return _buildEditableItem(entry.value, entry.key, currentDay.items.length);
                }),
                if (currentDay.items.isEmpty) _buildEmptyDay(),
                const SizedBox(height: 24),
                _buildSuggestionsSection(),
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
      expandedHeight: 160,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
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
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: LaPazTheme.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: LaPazTheme.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Editar Itinerario',
                        style: TextStyle(
                          color: LaPazTheme.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildDaySelector(GeneratedItinerary itinerary) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 50,
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
                _suggestions = [];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [LaPazTheme.oceanBlue, LaPazTheme.seaGreen])
                    : null,
                color: isSelected ? null : LaPazTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.lightGray,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  'Día ${day.dayNumber}',
                  style: TextStyle(
                    color: isSelected ? LaPazTheme.white : LaPazTheme.charcoal,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: LaPazTheme.charcoal,
        ),
      ),
    );
  }

  Widget _buildEditableItem(ItineraryItem item, int index, int totalItems) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: LaPazTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.color.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [item.color, item.color.withOpacity(0.7)]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: LaPazTheme.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: item.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: LaPazTheme.darkGray,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: LaPazTheme.offWhite,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _editTime(index),
                        child: _buildEditChip(Icons.access_time, item.timeSlot),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _editDuration(index),
                        child: _buildEditChip(Icons.timer, '${item.estimatedDurationMinutes} min'),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _openGoogleMaps(item),
                        child: _buildActionChip(Icons.map, 'Maps', LaPazTheme.oceanBlue),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward, size: 18),
                        color: index > 0 ? LaPazTheme.oceanBlue : LaPazTheme.lightGray,
                        onPressed: index > 0 ? () => _moveActivity(index, -1) : null,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward, size: 18),
                        color: index < totalItems - 1 ? LaPazTheme.oceanBlue : LaPazTheme.lightGray,
                        onPressed: index < totalItems - 1 ? () => _moveActivity(index, 1) : null,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: LaPazTheme.sunsetOrange,
                        onPressed: () => _removeActivity(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  if (item.alternativeNames.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: item.alternativeNames.map((alt) {
                        return GestureDetector(
                          onTap: () {
                            final replacement = widget.generator.findPlaceByName(alt);
                            if (replacement != null) {
                              _swapActivity(index, replacement);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: LaPazTheme.lightGray,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '↔ $alt',
                              style: const TextStyle(fontSize: 10, color: LaPazTheme.darkGray),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: LaPazTheme.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: LaPazTheme.lightGray),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: LaPazTheme.darkGray),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: LaPazTheme.darkGray)),
          const SizedBox(width: 2),
          const Icon(Icons.edit, size: 10, color: LaPazTheme.oceanBlue),
        ],
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }

  Widget _buildEmptyDay() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.event_busy, size: 48, color: LaPazTheme.lightGray),
          const SizedBox(height: 12),
          Text(
            'Sin actividades para este día',
            style: TextStyle(color: LaPazTheme.darkGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Sugerencias de Actividades',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: LaPazTheme.charcoal,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _loadingSuggestions ? null : _loadSuggestions,
                icon: _loadingSuggestions
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: const Text('Actualizar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryFilter(null, 'Todas'),
                const SizedBox(width: 8),
                _buildCategoryFilter('playas', 'Playas'),
                const SizedBox(width: 8),
                _buildCategoryFilter('ecoturismo', 'Ecoturismo'),
                const SizedBox(width: 8),
                _buildCategoryFilter('cultura', 'Cultura'),
                const SizedBox(width: 8),
                _buildCategoryFilter('gastronomia', 'Gastronomía'),
                const SizedBox(width: 8),
                _buildCategoryFilter('aventura', 'Aventura'),
                const SizedBox(width: 8),
                _buildCategoryFilter('vida_nocturna', 'Vida Nocturna'),
                const SizedBox(width: 8),
                _buildCategoryFilter('compras', 'Compras'),
                const SizedBox(width: 8),
                _buildCategoryFilter('relajacion', 'Relajación'),
                const SizedBox(width: 8),
                _buildCategoryFilter('historia', 'Historia'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_suggestions.isEmpty && !_loadingSuggestions)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: LaPazTheme.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: LaPazTheme.lightGray),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 36, color: LaPazTheme.gold),
                    const SizedBox(height: 8),
                    Text(
                      'Toca "Actualizar" para ver sugerencias',
                      style: TextStyle(color: LaPazTheme.darkGray, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          if (_loadingSuggestions)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          ..._suggestions.map((item) => _buildSuggestionCard(item)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(String? category, String label) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _suggestions = [];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.lightGray,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? LaPazTheme.white : LaPazTheme.darkGray,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(ItineraryItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: LaPazTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: item.color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [item.color, item.color.withOpacity(0.7)]),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: LaPazTheme.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: item.color,
                    ),
                  ),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 11, color: LaPazTheme.darkGray),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.map, size: 18),
              color: LaPazTheme.oceanBlue,
              onPressed: () => _openGoogleMaps(item),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _addActivity(item),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Agregar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: item.color,
                foregroundColor: LaPazTheme.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerDialog extends StatefulWidget {
  final String currentTime;
  final Function(String) onTimeSelected;

  const _TimePickerDialog({required this.currentTime, required this.onTimeSelected});

  @override
  State<_TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  late String _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.currentTime;
  }

  @override
  Widget build(BuildContext context) {
    final times = [
      '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
      '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM',
      '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM',
    ];

    return AlertDialog(
      title: const Text('Seleccionar Hora'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: times.length,
          itemBuilder: (context, index) {
            final time = times[index];
            final isSelected = time == _selectedTime;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = time),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.lightGray,
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? LaPazTheme.white : LaPazTheme.charcoal,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onTimeSelected(_selectedTime);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

class _DurationPickerDialog extends StatefulWidget {
  final int currentDuration;
  final Function(int) onDurationSelected;

  const _DurationPickerDialog({required this.currentDuration, required this.onDurationSelected});

  @override
  State<_DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<_DurationPickerDialog> {
  late int _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.currentDuration;
  }

  @override
  Widget build(BuildContext context) {
    final durations = [30, 45, 60, 90, 120, 150, 180, 240, 300, 360, 480];

    return AlertDialog(
      title: const Text('Duración (minutos)'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: durations.length,
          itemBuilder: (context, index) {
            final duration = durations[index];
            final isSelected = duration == _selectedDuration;
            return GestureDetector(
              onTap: () => setState(() => _selectedDuration = duration),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? LaPazTheme.oceanBlue : LaPazTheme.lightGray,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$duration min',
                    style: TextStyle(
                      color: isSelected ? LaPazTheme.white : LaPazTheme.charcoal,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onDurationSelected(_selectedDuration);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
