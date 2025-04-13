import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = '858f15fed9292cbe25c341a754c55e45';
  static const String weatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';
  static const String units = 'metric'; // Use Celsius
  static const String iconBaseUrl = 'https://openweathermap.org/img/wn/';
}

class AppStrings {
  static const String appName = 'Weather App';
  static const String search = 'Search city';
  static const String noWeatherData = 'No weather data available';
  static const String temperature = 'Temperature';
  static const String humidity = 'Humidity';
  static const String windSpeed = 'Wind Speed';
  static const String currentLocation = 'Current Location';
  static const String forecast = 'Forecast';
  static const String errorOccurred = 'An error occurred';
  static const String retry = 'Retry';
  static const String feelsLike = 'Feels Like';
  static const String pressure = 'Pressure';
  static const String searchHint = 'Enter city name';
  static const String searchButton = 'Search';
  static const String locationPermission = 'Location permission is required';
  static const String locationSettings = 'Please enable location services';

  static const String cancel = 'Cancel';
  static const String openSettings = 'Open Settings';
  static const String locationServicesDisabled = 'Location services are disabled. Please enable the services';
  static const String locationPermissionDenied = 'Location permission denied';
  static const String locationPermissionPermanentlyDenied = 'Location permissions are permanently denied. Please open app settings to enable location permissions.';
  static const String searchCityPrompt = 'Search for a city to see weather information';
  static const String orUseLocation = 'Or use your current location';


}
class AppColors {
  static const Color primary = Color(0xFFEF6C00);
  static const Color secondary = Color(0xFFFFA726);
  static const Color background = Color(0xFFFFF3E0);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFFE65100);
  static const Color textSecondary = Color(0xFFF57C00);
  static const Color error = Color(0xFFC62828);
  static const Color shimmerBase = Color(0xFFFFE0B2);
  static const Color shimmerHighlight = Color(0xFFFFF3E0);

}