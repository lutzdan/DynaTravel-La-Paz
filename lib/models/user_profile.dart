// lib/models/user_profile.dart
import 'package:flutter/material.dart';

class UserProfile 
{
  final List<String> tags = List.empty(); // ["playa", "snorkel", "naturaleza", "familia"]
  final TripConfig tripConfig = TripConfig(); // días, presupuesto, ritmo

  // Se guarda en SharedPreferences como JSON
  Map<String, dynamic> toJson() => {
    'tags': tags,
    'tripConfig': tripConfig.toJson(),
  };
}

class TripConfig 
{

  final int days = 0;
  final String budget = ""; // "bajo", "medio", "alto"
  final String pace = ""; // "relajado", "moderado", "intenso"
  final TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  final TimeOfDay endTime = TimeOfDay(hour: 12, minute: 12);
  
  Map<String, dynamic> toJson() =>  
  {
    'days': days,
    'budget': budget

  };
}
