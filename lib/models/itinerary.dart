// lib/models/itinerary.dart
import 'package:flutter/material.dart';

class ItineraryItem {
  final String id;
  String name;
  String category;
  String description;
  String address;
  double relevanceScore;
  IconData icon;
  Color color;
  String timeSlot;
  int estimatedDurationMinutes;
  String budgetLevel;
  final double latitude;
  final double longitude;
  final List<String> alternativeNames;
  bool isSponsored;

  ItineraryItem({
    required this.id,
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
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.alternativeNames = const [],
    this.isSponsored = false,
  });

  ItineraryItem copyWith({
    String? name,
    String? category,
    String? description,
    String? address,
    double? relevanceScore,
    IconData? icon,
    Color? color,
    String? timeSlot,
    int? estimatedDurationMinutes,
    String? budgetLevel,
    bool? isSponsored,
  }) {
    return ItineraryItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      address: address ?? this.address,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      timeSlot: timeSlot ?? this.timeSlot,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      latitude: latitude,
      longitude: longitude,
      alternativeNames: alternativeNames,
      isSponsored: isSponsored ?? this.isSponsored,
    );
  }
}

class DayItinerary {
  final int dayNumber;
  final String date;
  String theme;
  List<ItineraryItem> items;

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
