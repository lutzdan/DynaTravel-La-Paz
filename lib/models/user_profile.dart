// lib/models/user_profile.dart
import 'package:flutter/material.dart';

class UserProfile {
  List<String> tags;
  TripConfig tripConfig;

  UserProfile({
    List<String>? tags,
    TripConfig? tripConfig,
  })  : tags = tags ?? [],
        tripConfig = tripConfig ?? TripConfig();

  Map<String, dynamic> toJson() => {
        'tags': tags,
        'tripConfig': tripConfig.toJson(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      tags: List<String>.from(json['tags'] ?? []),
      tripConfig: TripConfig.fromJson(json['tripConfig'] ?? {}),
    );
  }
}

class TripConfig {
  int days;
  String budget;
  String pace;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String? schedule;
  String? duration;
  String? tripType;
  String? transport;
  String? distance;
  String? accessibility;
  String? availability;

  TripConfig({
    this.days = 0,
    this.budget = '',
    this.pace = '',
    this.startTime = const TimeOfDay(hour: 8, minute: 0),
    this.endTime = const TimeOfDay(hour: 18, minute: 0),
    this.schedule,
    this.duration,
    this.tripType,
    this.transport,
    this.distance,
    this.accessibility,
    this.availability,
  });

  Map<String, dynamic> toJson() => {
        'days': days,
        'budget': budget,
        'pace': pace,
        'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
        'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
        'schedule': schedule,
        'duration': duration,
        'tripType': tripType,
        'transport': transport,
        'distance': distance,
        'accessibility': accessibility,
        'availability': availability,
      };

  factory TripConfig.fromJson(Map<String, dynamic> json) {
    return TripConfig(
      days: json['days'] ?? 0,
      budget: json['budget'] ?? '',
      pace: json['pace'] ?? '',
      startTime: TimeOfDay(
        hour: json['startTime']?['hour'] ?? 8,
        minute: json['startTime']?['minute'] ?? 0,
      ),
      endTime: TimeOfDay(
        hour: json['endTime']?['hour'] ?? 18,
        minute: json['endTime']?['minute'] ?? 0,
      ),
      schedule: json['schedule'],
      duration: json['duration'],
      tripType: json['tripType'],
      transport: json['transport'],
      distance: json['distance'],
      accessibility: json['accessibility'],
      availability: json['availability'],
    );
  }
}
