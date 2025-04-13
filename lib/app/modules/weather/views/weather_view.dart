import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/weather_controller.dart';
import '../../../utils/constants.dart';
import '../widgets/forecast_card.dart';
import '../widgets/weather_card.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => controller.isSearchMode.value
            ? TextField(
          controller: controller.searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.getWeatherByCity(value);
              controller.toggleSearchMode();
            }
          },
        )
            : Text(controller.currentCity.value.isEmpty
            ? AppStrings.appName
            : controller.currentCity.value)),
        leading: Obx(() => controller.isSearchMode.value
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.toggleSearchMode,
        )
            : controller.currentCity.value.isNotEmpty && controller.previousCity.value.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.getWeatherByCity(controller.previousCity.value),
        )
            : const SizedBox.shrink()),
        actions: [
          Obx(() => controller.isSearchMode.value
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.searchController.clear();
            },
          )
              : IconButton(
            icon: const Icon(Icons.search),
            onPressed: controller.toggleSearchMode,
          )),
          Obx(() => controller.isSearchMode.value
              ? const SizedBox.shrink()
              : IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: controller.getCurrentLocationWeather,
          )),
        ],
      ),
      body: Obx(
            () => RefreshIndicator(
          onRefresh: () async {
            if (controller.currentCity.isNotEmpty) {
              await controller.getWeatherByCity(controller.currentCity.value);
            } else {
              await controller.getCurrentLocationWeather();
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: controller.isLoading.value
                ? _buildLoadingState()
                : controller.errorMessage.isNotEmpty
                ? _buildErrorState()
                : _buildWeatherContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading weather data...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (controller.currentCity.isNotEmpty) {
                  controller.getWeatherByCity(controller.currentCity.value);
                } else {
                  controller.getCurrentLocationWeather();
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.retry),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context) {
    if (controller.currentWeather.value == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/weather_icon.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.cloud,
                  size: 120,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.searchCityPrompt,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.orUseLocation,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.toggleSearchMode,
                    icon: const Icon(Icons.search),
                    label: Text(AppStrings.searchButton),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: controller.getCurrentLocationWeather,
                    icon: const Icon(Icons.my_location),
                    label: Text(AppStrings.currentLocation),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Weather Data
            Hero(
              tag: 'city_name',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  controller.currentCity.value,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Current Weather Card with animation
            AnimatedOpacity(
              opacity: controller.currentWeather.value != null ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: controller.currentWeather.value != null
                  ? WeatherCard(weather: controller.currentWeather.value!)
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // Forecast Data with animation
            if (controller.forecastList.isNotEmpty)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.forecast,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.forecastList.length,
                        itemBuilder: (context, index) {
                          // Staggered animation for the forecast cards
                          return AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(milliseconds: 500 + (index * 100)),
                            child: ForecastCard(
                              forecast: controller.forecastList[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}