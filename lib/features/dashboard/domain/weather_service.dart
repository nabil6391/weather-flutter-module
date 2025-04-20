import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_profile_app/features/dashboard/data/weather.dart';

import '../../../common/network/dio_client.dart';
import '../../../common/utils/constants.dart';

class WeatherService {
  final DioClient _dioClient;

  WeatherService(this._dioClient);

  Future<Weather> getWeatherForCity(String city) async {
    // Basic input validation
    if (city.isEmpty) {
      throw Exception('City name cannot be empty.');
    }

    try {
      final response = await _dioClient.get(
        '/weather',
        queryParameters: {
          'q': city,
          'appid': Constants.apiKey,
          'units': 'metric', // Use Celsius
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return Weather.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to get weather data. Status code: ${response.statusCode}, Message: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to get weather data: ';
      if (e.response != null) {
        errorMessage +=
            'Status ${e.response?.statusCode}: ${e.response?.statusMessage ?? 'Unknown error'}. ';
      } else {
        errorMessage += '${e.message}';
      }
      debugPrint('DioException in WeatherService: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Unexpected error in WeatherService: $e');
      throw Exception(
          'An unexpected error occurred while fetching weather data.');
    }
  }
}
