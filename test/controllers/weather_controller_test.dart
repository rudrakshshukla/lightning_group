import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:lightning_group/app/controllers/weather_controller.dart';
import 'package:lightning_group/app/data/models/weather_model.dart' as weather;
import 'package:lightning_group/app/data/services/weather_service.dart';

// Manual mock for WeatherService
class MockWeatherService extends Mock implements WeatherService {}

void main() {
  late WeatherController controller;
  late MockWeatherService mockWeatherService;

  setUp(() {
    mockWeatherService = MockWeatherService();
    controller = WeatherController(weatherService: mockWeatherService);

    // Initialize GetX test environment
    Get.testMode = true;
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('WeatherController', () {
    test('initial values are correct', () {
      expect(controller.currentWeather.value, isNull);
      expect(controller.forecastList, isEmpty);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.currentCity.value, isEmpty);
      expect(controller.previousCity.value, isEmpty);
      expect(controller.isSearchMode.value, isFalse);
    });

    test('toggleSearchMode changes isSearchMode value', () {
      expect(controller.isSearchMode.value, isFalse);

      controller.toggleSearchMode();
      expect(controller.isSearchMode.value, isTrue);

      controller.toggleSearchMode();
      expect(controller.isSearchMode.value, isFalse);
    });

    test('getWeatherByCity sets currentCity correctly', () async {
      // Arrange
      final cityName = 'London';

      // Setup a simple weather model with just the name and coordinates
      final testWeather = weather.WeatherModel(
        name: cityName,
        coord: weather.Coord(lat: 51.5074, lon: -0.1278),
      );

      when(mockWeatherService.getWeatherByCity(cityName))
          .thenAnswer((_) async => testWeather);

      // Setup forecast with concrete lat/lon values
      when(mockWeatherService.getForecast(51.5074, -0.1278))
          .thenAnswer((_) async => []);

      // Act
      await controller.getWeatherByCity(cityName);

      // Assert
      expect(controller.currentCity.value, equals(cityName));
      verify(mockWeatherService.getWeatherByCity(cityName)).called(1);
    });

    test('getWeatherByCity handles error correctly', () async {
      // Arrange
      when(mockWeatherService.getWeatherByCity('InvalidCity'))
          .thenThrow(Exception('City not found'));

      // Act
      await controller.getWeatherByCity('InvalidCity');

      // Assert
      expect(controller.currentWeather.value, isNull);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value.contains('City not found'), isTrue);

      verify(mockWeatherService.getWeatherByCity('InvalidCity')).called(1);
    });
  });
}