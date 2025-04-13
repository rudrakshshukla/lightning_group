import 'package:get/get.dart';


import '../controllers/weather_controller.dart';
import '../data/services/weather_service.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    // Register the WeatherService as a dependency
    Get.lazyPut<WeatherService>(() => WeatherService());

    // Register the WeatherController with WeatherService as a dependency
    Get.lazyPut<WeatherController>(() => WeatherController(
      weatherService: Get.find<WeatherService>(),
    ));
  }
}