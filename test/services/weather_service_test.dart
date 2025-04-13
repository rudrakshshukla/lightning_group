import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:lightning_group/app/data/services/weather_service.dart';
import 'package:lightning_group/app/utils/constants.dart';

// Manual mock for http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;
  late WeatherService weatherService;

  setUp(() {
    mockClient = MockClient();
    weatherService = WeatherService(httpClient: mockClient);
  });

  group('WeatherService', () {
    // Sample weather data
    final weatherJson = {
      "coord": {"lon": 10.99, "lat": 44.34},
      "weather": [
        {"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}
      ],
      "base": "stations",
      "main": {
        "temp": 22.5,
        "feels_like": 21.8,
        "temp_min": 20.6,
        "temp_max": 24.1,
        "pressure": 1015,
        "humidity": 56
      },
      "visibility": 10000,
      "wind": {"speed": 3.6, "deg": 160},
      "clouds": {"all": 0},
      "dt": 1661778000,
      "sys": {
        "type": 2,
        "id": 2004797,
        "country": "IT",
        "sunrise": 1661749471,
        "sunset": 1661798013
      },
      "timezone": 7200,
      "id": 3163858,
      "name": "Zocca",
      "cod": 200
    };

    test('getWeatherByCity returns a WeatherModel if the http call completes successfully', () async {
      // Arrange
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}?q=London&appid=${ApiConstants.apiKey}&units=${ApiConstants.units}',
      );

      when(mockClient.get(uri))
          .thenAnswer((_) async => http.Response(json.encode(weatherJson), 200));

      // Act
      final result = await weatherService.getWeatherByCity('London');

      // Assert
      expect(result, isNotNull);
      expect(result.name, equals('Zocca'));
      expect(result.main?.temp, equals(22.5));

      // Verify that the correct URL was called
      verify(mockClient.get(uri)).called(1);
    });

    test('getWeatherIconUrl returns correct URL', () {
      // Act
      final result = weatherService.getWeatherIconUrl('01d');

      // Assert
      expect(result, equals('${ApiConstants.iconBaseUrl}01d@2x.png'));
    });
  });
}