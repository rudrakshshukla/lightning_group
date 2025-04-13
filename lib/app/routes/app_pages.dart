import 'package:get/get.dart';

import '../bindings/weather_binding.dart';
import '../modules/weather/views/weather_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.WEATHER;

  static final routes = [
    GetPage(
      name: Routes.WEATHER,
      page: () => const WeatherView(),
      binding: WeatherBinding(),
    ),
  ];
}
