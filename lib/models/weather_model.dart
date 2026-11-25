import 'location_model.dart';

class CurrentWeather {
  final String time;
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'] ?? '',
      temperature: (json['temperature_2m'] is num)
          ? (json['temperature_2m'] as num).toDouble()
          : 0.0,
      relativeHumidity: (json['relative_humidity_2m'] is num)
          ? (json['relative_humidity_2m'] as num).toInt()
          : 0,
      apparentTemperature: (json['apparent_temperature'] is num)
          ? (json['apparent_temperature'] as num).toDouble()
          : 0.0,
      precipitation: (json['precipitation'] is num)
          ? (json['precipitation'] as num).toDouble()
          : 0.0,
      weatherCode: (json['weather_code'] is num)
          ? (json['weather_code'] as num).toInt()
          : 0,
      windSpeed: (json['wind_speed_10m'] is num)
          ? (json['wind_speed_10m'] as num).toDouble()
          : 0.0,
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemperature;
  final double minTemperature;
  final int precipitationProbability;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.precipitationProbability,
    required this.weatherCode,
  });
}

class WeatherData {
  final LocationModel location;
  final CurrentWeather current;
  final List<DailyForecast> dailyForecasts;
  final String timezone;

  WeatherData({
    required this.location,
    required this.current,
    required this.dailyForecasts,
    required this.timezone,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, LocationModel location) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};

    final current = CurrentWeather.fromJson(currentJson);

    final List<DailyForecast> forecasts = [];
    final times = dailyJson['time'] as List? ?? [];
    final maxTemps = dailyJson['temperature_2m_max'] as List? ?? [];
    final minTemps = dailyJson['temperature_2m_min'] as List? ?? [];
    final precipProbs = dailyJson['precipitation_probability_max'] as List? ?? [];
    final weatherCodes = dailyJson['weather_code'] as List? ?? [];

    for (int i = 0; i < times.length; i++) {
      forecasts.add(
        DailyForecast(
          date: times[i].toString(),
          maxTemperature: (i < maxTemps.length && maxTemps[i] is num)
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          minTemperature: (i < minTemps.length && minTemps[i] is num)
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          precipitationProbability: (i < precipProbs.length && precipProbs[i] is num)
              ? (precipProbs[i] as num).toInt()
              : 0,
          weatherCode: (i < weatherCodes.length && weatherCodes[i] is num)
              ? (weatherCodes[i] as num).toInt()
              : 0,
        ),
      );
    }

    return WeatherData(
      location: location,
      current: current,
      dailyForecasts: forecasts,
      timezone: json['timezone'] ?? 'auto',
    );
  }
}
