import 'package:flutter/foundation.dart';
import 'package:weather_profile_app/common/network/dio_client.dart';
import 'package:weather_profile_app/features/dashboard/data/weather.dart';

import 'weather_service.dart';

class WeatherProvider with ChangeNotifier {
  late WeatherService _weatherService;

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherProvider(DioClient? dioClient) {
    if (dioClient != null) {
      _weatherService = WeatherService(dioClient);
    }
  }

  Weather? get weather => _weather;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchWeather(String city) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _weatherService.getWeatherForCity(city);
      debugPrint('Successfully fetched weather for $city');
    } catch (e) {
      _error = e.toString();
      _weather = null;
      debugPrint('Error fetching weather for $city: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearWeather() {
    _weather = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  updateDioClient(DioClient dioClient) {
    _weatherService = WeatherService(dioClient);
  }
}
