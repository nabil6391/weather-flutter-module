import 'package:flutter/foundation.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String icon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      return Weather(
        cityName: json['name'] as String? ?? 'Unknown City',
        temperature: (json['main']?['temp'] as num?)?.toDouble() ?? 0.0,
        condition: json['weather']?[0]?['main'] as String? ?? 'Unknown',
        icon: json['weather']?[0]?['icon'] as String? ?? '',
      );
    } catch (e) {
      debugPrint('Error parsing Weather from JSON: $e');
      // Return a default or throw a more specific error
      return Weather(
          cityName: 'Error City',
          temperature: 0.0,
          condition: 'Parse Error',
          icon: '');
    }
  }
}
