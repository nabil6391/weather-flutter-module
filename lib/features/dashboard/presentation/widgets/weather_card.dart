import 'package:flutter/material.dart';
import 'package:weather_profile_app/features/dashboard/data/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({
    Key? key,
    required this.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String iconUrl = weather.icon.isNotEmpty
        ? 'https://openweathermap.org/img/wn/${weather.icon}@2x.png'
        : '';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit content vertically
          children: [
            Text(
              weather.cityName,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  // Display one decimal place
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconUrl.isNotEmpty)
                      Image.network(
                        iconUrl,
                        width: 60,
                        height: 60,
                        // Loading builder can show a placeholder while image loads
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null)
                            return child; // Image loaded
                          return const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          );
                        },
                        // Error builder handles cases where the image fails to load
                        errorBuilder: (ctx, error, stackTrace) {
                          debugPrint('Error loading weather icon: $error');
                          return const Icon(
                            Icons.cloud_off, // More specific icon for error
                            size: 60,
                            color: Colors.grey,
                          );
                        },
                      )
                    else
                      // Placeholder if icon ID is empty
                      const Icon(
                        Icons.co2,
                        size: 60,
                        color: Colors.grey,
                      ),
                    const SizedBox(height: 4), // Space between icon and text
                    Text(
                      weather.condition,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
