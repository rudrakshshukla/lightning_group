import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../data/models/forecast_model.dart';
import '../data/models/weather_model.dart';
import '../data/services/weather_service.dart';
import '../utils/constants.dart';

class WeatherController extends GetxController {
  final WeatherService weatherService;

  // Dependency injection
  WeatherController({required this.weatherService});

  // Observables for reactive UI
  final currentWeather = Rx<WeatherModel?>(null);
  final forecastList = <ForecastItem>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentCity = ''.obs;
  final previousCity = ''.obs;
  final isSearchMode = false.obs;
  final TextEditingController searchController = TextEditingController();

  // Cache for weather data to improve back navigation
  final _weatherCache = <String, WeatherModel>{};
  final _forecastCache = <String, List<ForecastItem>>{};

  @override
  void onInit() {
    super.onInit();
    // Get weather for current location when app starts
    getCurrentLocationWeather();
  }

  @override
  void onClose() {
    // Dispose resources
    searchController.dispose();
    super.onClose();
  }

  // Toggle search mode
  void toggleSearchMode() {
    isSearchMode.value = !isSearchMode.value;
    if (!isSearchMode.value) {
      searchController.clear();
    }
  }

  // Get weather for a city by name
  Future<void> getWeatherByCity(String city) async {
    if (city.isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Set previous city for back navigation
      if (currentCity.value.isNotEmpty && currentCity.value != city) {
        previousCity.value = currentCity.value;
      }

      // Check cache first
      if (_weatherCache.containsKey(city)) {
        currentWeather.value = _weatherCache[city];
        currentCity.value = city;

        if (_forecastCache.containsKey(city)) {
          forecastList.assignAll(_forecastCache[city]!);
        }

        isLoading.value = false;
        return;
      }

      // Get current weather data
      final weather = await weatherService.getWeatherByCity(city);
      currentWeather.value = weather;
      currentCity.value = city;

      // Cache the weather data
      _weatherCache[city] = weather;

      // Get forecast data if we have coordinates
      if (weather.coord != null) {
        final forecast = await weatherService.getForecast(
          weather.coord!.lat!,
          weather.coord!.lon!,
        );
        forecastList.assignAll(forecast);

        // Cache the forecast data
        _forecastCache[city] = forecast;
      }

      // Clear search field after successful search
      searchController.clear();

    } catch (e) {
      errorMessage.value = '${AppStrings.errorOccurred}: $e';
      debugPrint('Error getting weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get weather for current location
  Future<void> getCurrentLocationWeather() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        isLoading.value = false;
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();

      // Get weather and forecast by coordinates
      final weather = await weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      // Set previous city for back navigation
      if (currentCity.value.isNotEmpty && currentCity.value != weather.name) {
        previousCity.value = currentCity.value;
      }

      currentWeather.value = weather;
      currentCity.value = weather.name ?? '';

      // Cache the weather data if we have a city name
      if (weather.name != null && weather.name!.isNotEmpty) {
        _weatherCache[weather.name!] = weather;
      }

      // Get forecast data
      final forecast = await weatherService.getForecast(
        position.latitude,
        position.longitude,
      );
      forecastList.assignAll(forecast);

      // Cache the forecast data if we have a city name
      if (weather.name != null && weather.name!.isNotEmpty) {
        _forecastCache[weather.name!] = forecast;
      }

    } catch (e) {
      errorMessage.value = '${AppStrings.errorOccurred}: $e';
      debugPrint('Error getting location weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to open location settings
      Get.dialog(
        AlertDialog(
          title: Text(AppStrings.locationSettings),
          content: Text(AppStrings.locationServicesDisabled),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Get.back(result: true);
                await Geolocator.openLocationSettings();
              },
              child: Text(AppStrings.openSettings),
            ),
          ],
        ),
      );
      return false;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          AppStrings.locationPermission,
          AppStrings.locationPermissionDenied,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          title: Text(AppStrings.locationPermission),
          content: Text(AppStrings.locationPermissionPermanentlyDenied),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Get.back(result: true);
                await Geolocator.openAppSettings();
              },
              child: Text(AppStrings.openSettings),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }
}