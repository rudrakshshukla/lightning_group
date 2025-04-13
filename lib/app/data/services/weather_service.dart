import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lightning_group/app/data/models/weather_model.dart';

import '../../utils/constants.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final http.Client _httpClient;

  // Constructor with optional parameter for dependency injection
  WeatherService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  // Get current weather by city name
  Future<WeatherModel> getWeatherByCity(String city) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}?q=$city&appid=${ApiConstants.apiKey}&units=${ApiConstants.units}',
    );

    try {
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        // Handle API errors
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get current weather by coordinates
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}?lat=$lat&lon=$lon&appid=${ApiConstants.apiKey}&units=${ApiConstants.units}',
    );

    try {
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        // Handle API errors
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get forecast data by coordinates
  Future<List<ForecastItem>> getForecast(double lat, double lon) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.forecastEndpoint}?lat=$lat&lon=$lon&appid=${ApiConstants.apiKey}&units=${ApiConstants.units}',
    );

    try {
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final forecastModel = ForecastModel.fromJson(json.decode(response.body));

        // Return the list of forecast items or empty list if null
        return forecastModel.list ?? [];
      } else {
        // Handle API errors
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }

  // Get weather icon URL
  String getWeatherIconUrl(String iconCode) {
    return '${ApiConstants.iconBaseUrl}$iconCode@2x.png';
  }
}