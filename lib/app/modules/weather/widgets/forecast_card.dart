import 'package:flutter/material.dart';
import 'package:lightning_group/app/data/models/weather_model.dart';
import 'package:lightning_group/app/data/services/weather_service.dart';
import 'package:lightning_group/app/utils/constants.dart';

import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final WeatherService _weatherService = WeatherService();

  WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format timestamp to readable date and time
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      (weather.dt ?? 0) * 1000,
    );

    final formattedDate = DateFormat('EEEE, MMM d, y').format(dateTime);
    final formattedTime = DateFormat('h:mm a').format(dateTime);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date and time
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Weather icon and main info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (weather.weather != null &&
                    weather.weather!.isNotEmpty &&
                    weather.weather![0].icon != null)
                  Image.network(
                    _weatherService.getWeatherIconUrl(weather.weather![0].icon!),
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.main?.temp?.toStringAsFixed(1)}°C',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      weather.weather?.first.description?.toUpperCase() ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weather details in grid
            _buildWeatherDetailsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDetailItem(
          context,
          AppStrings.feelsLike,
          '${weather.main?.feelsLike?.toStringAsFixed(1)}°C',
          Icons.thermostat,
        ),
        _buildDetailItem(
          context,
          AppStrings.humidity,
          '${weather.main?.humidity}%',
          Icons.water_drop,
        ),
        _buildDetailItem(
          context,
          AppStrings.windSpeed,
          '${weather.wind?.speed} m/s',
          Icons.air,
        ),
        _buildDetailItem(
          context,
          AppStrings.pressure,
          '${weather.main?.pressure} hPa',
          Icons.speed,
        ),
      ],
    );
  }

  Widget _buildDetailItem(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}