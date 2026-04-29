// lib/models/itinerary.dart
import 'package:flutter/material.dart';

class ItineraryItem {
  final String name;
  final String category;
  final String description;
  final String address;
  final double relevanceScore;
  final IconData icon;
  final Color color;
  final String timeSlot;
  final int estimatedDurationMinutes;
  final String budgetLevel;

  ItineraryItem({
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.relevanceScore,
    required this.icon,
    required this.color,
    required this.timeSlot,
    this.estimatedDurationMinutes = 60,
    this.budgetLevel = 'medio',
  });
}

class DayItinerary {
  final int dayNumber;
  final String date;
  final String theme;
  final List<ItineraryItem> items;

  DayItinerary({
    required this.dayNumber,
    required this.date,
    required this.theme,
    required this.items,
  });
}

class GeneratedItinerary {
  final String destination;
  final int totalDays;
  final List<String> userInterests;
  final List<DayItinerary> days;
  final List<String> expandedTags;

  GeneratedItinerary({
    required this.destination,
    required this.totalDays,
    required this.userInterests,
    required this.days,
    required this.expandedTags,
  });
}
