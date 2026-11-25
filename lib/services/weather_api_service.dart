import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _forecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';

  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari lokasi kota berdasarkan input teks pengguna
  Future<List<LocationModel>> searchCities(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    final url = Uri.parse(
      '$_geocodingBaseUrl?name=${Uri.encodeComponent(cleanQuery)}&count=10&language=id&format=json',
    );

    try {
      final response = await _client.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final List results = data['results'];
          return results.map((item) => LocationModel.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception('Gagal mengambil data kota (Status HTTP: ${response.statusCode})');
      }
    } catch (e) {
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('ClientException')) {
        throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
      }
      throw Exception('Terjadi kesalahan saat mencari kota: $e');
    }
  }

  /// Mengambil data cuaca lengkap (terkini + prakiraan harian) untuk lokasi tertentu
  Future<WeatherData> getForecast(LocationModel location) async {
    final url = Uri.parse(
      '$_forecastBaseUrl?'
      'latitude=${location.latitude}&'
      'longitude=${location.longitude}&'
      'current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&'
      'daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,weather_code&'
      'timezone=auto',
    );

    try {
      final response = await _client.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherData.fromJson(data, location);
      } else {
        throw Exception('Gagal mengambil ramalan cuaca (Status HTTP: ${response.statusCode})');
      }
    } catch (e) {
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('ClientException')) {
        throw Exception('Tidak ada koneksi internet. Silakan periksa jaringan Anda.');
      }
      throw Exception('Terjadi kesalahan saat memuat cuaca: $e');
    }
  }
}
