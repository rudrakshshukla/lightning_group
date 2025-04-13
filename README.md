# Weather App

A Flutter application that integrates with the OpenWeatherMap API to provide current weather data and forecasts for cities.

## Features

- Search for weather information by city name
- Get weather for current location
- View detailed current weather including temperature, humidity, wind speed, and more
- See 5-day forecast
- Responsive UI that works across different device sizes

### Prerequisites

- Flutter SDK :3.1.5
- Android Studio or VS Code with Flutter extensions
- Android or iOS device/emulator to run

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/weather_app.git
   cd lightning_group
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the tests
   ```bash
   flutter test
   ```

4. Run the app
   ```bash
   flutter run
   ```



## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── bindings/        # Dependency injection
│   ├── controllers/     # Business logic
│   ├── data/
│   │   ├── models/      # Data models
│   │   └── services/    # API services
│   ├── modules/
│   │   └── weather/
│   │       ├── views/   # UI screens
│   │       └── widgets/ # Reusable UI components
│   ├── routes/          # App navigation
│   └── utils/           # Constants and utilities
└── test/
    ├── controllers/     # Controller tests
    └── services/        # Service tests
```

## Architecture

This app uses:
- **GetX** for state management, dependency injection, and navigation
- **HTTP** package for API calls
- **Geolocator** for getting device location
- **Intl** for date formatting


## Demo

