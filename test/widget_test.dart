import 'package:flutter_test/flutter_test.dart';
import 'package:responsipemmob/models/location_model.dart';
import 'package:responsipemmob/models/weather_code_helper.dart';
import 'package:responsipemmob/models/weather_model.dart';

void main() {
  group('LocationModel Test', () {
    test('JSON serialization & deserialization', () {
      final json = {
        'id': 1642911,
        'name': 'Jakarta',
        'latitude': -6.21462,
        'longitude': 106.84513,
        'country': 'Indonesia',
        'admin1': 'Jakarta',
        'country_code': 'ID',
        'timezone': 'Asia/Jakarta',
        'isFavorite': true,
      };

      final location = LocationModel.fromJson(json);
      expect(location.id, 1642911);
      expect(location.name, 'Jakarta');
      expect(location.isFavorite, true);

      final encoded = location.toJson();
      expect(encoded['name'], 'Jakarta');
      expect(encoded['latitude'], -6.21462);
    });
  });

  group('WeatherData & WeatherCodeHelper Test', () {
    test('Weather code 0 translates to Cerah', () {
      final info = WeatherCodeHelper.getInfo(0);
      expect(info.description, 'Cerah');
    });

    test('Weather code 61 translates to Hujan Ringan', () {
      final info = WeatherCodeHelper.getInfo(61);
      expect(info.description, 'Hujan Ringan');
    });

    test('CurrentWeather JSON parsing', () {
      final json = {
        'time': '2026-11-25T12:00',
        'temperature_2m': 28.5,
        'relative_humidity_2m': 80,
        'apparent_temperature': 32.1,
        'precipitation': 1.2,
        'weather_code': 61,
        'wind_speed_10m': 12.4,
      };

      final current = CurrentWeather.fromJson(json);
      expect(current.temperature, 28.5);
      expect(current.relativeHumidity, 80);
      expect(current.apparentTemperature, 32.1);
      expect(current.weatherCode, 61);
    });
  });
}
