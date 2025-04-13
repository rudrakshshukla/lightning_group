import 'package:flutter/material.dart';
import 'package:lightning_group/app/data/models/forecast_model.dart';
import 'package:lightning_group/app/utils/constants.dart';

import 'package:intl/intl.dart';

import '../../../data/services/weather_service.dart';

class ForecastCard extends StatelessWidget {
  final ForecastItem forecast;
  final WeatherService _weatherService = WeatherService();

  ForecastCard({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format timestamp to readable date and time
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      (forecast.dt ?? 0) * 1000,
    );

    final formattedDay = DateFormat('E').format(dateTime);
    final formattedTime = DateFormat('h a').format(dateTime);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day and time
            Text(
              formattedDay,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),

            // Weather icon
            if (forecast.weather != null &&
                forecast.weather!.isNotEmpty &&
                forecast.weather![0].icon != null)
              Image.network(
                _weatherService.getWeatherIconUrl(forecast.weather![0].icon!),
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 8),

            // Temperature
            Text(
              '${forecast.main?.temp?.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            // Weather description
            Text(
              forecast.weather?.first.description ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}