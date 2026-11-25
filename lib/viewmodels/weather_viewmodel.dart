import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  WeatherViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  // State
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;
  WeatherData? _weatherData;
  LocationModel? _currentLocation;
  bool _isFavorite = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  WeatherData? get weatherData => _weatherData;
  LocationModel? get currentLocation => _currentLocation;
  bool get isFavorite => _isFavorite;

  // Lokasi default (Jakarta) jika belum ada data di penyimpanan lokal
  static final LocationModel defaultLocation = LocationModel(
    id: 1642911,
    name: 'Jakarta',
    latitude: -6.21462,
    longitude: 106.84513,
    country: 'Indonesia',
    admin1: 'Jakarta',
    timezone: 'Asia/Jakarta',
  );

  /// Inisialisasi awal saat aplikasi pertama kali dibuka
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final savedLocation = await _storageService.getLastLocation();
      final targetLocation = savedLocation ?? defaultLocation;
      _currentLocation = targetLocation;
      _isFavorite = await _storageService.isFavorite(targetLocation.id);

      await _fetchWeather(targetLocation);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memuat cuaca untuk lokasi tertentu (dipilih dari pencarian atau favorit)
  Future<void> selectLocation(LocationModel location) async {
    _currentLocation = location;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simpan sebagai lokasi terakhir dan tambahkan ke riwayat pencarian
      await _storageService.saveLastLocation(location);
      await _storageService.addToSearchHistory(location);
      _isFavorite = await _storageService.isFavorite(location.id);

      await _fetchWeather(location);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh data cuaca (Pull to refresh)
  Future<void> refresh() async {
    if (_currentLocation == null) return;
    _isRefreshing = true;
    notifyListeners();

    try {
      _isFavorite = await _storageService.isFavorite(_currentLocation!.id);
      await _fetchWeather(_currentLocation!);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Toggle status favorit untuk lokasi saat ini
  Future<void> toggleFavorite() async {
    if (_currentLocation == null) return;

    if (_isFavorite) {
      await _storageService.removeFavorite(_currentLocation!.id);
      _isFavorite = false;
    } else {
      await _storageService.saveFavorite(_currentLocation!);
      _isFavorite = true;
    }
    notifyListeners();
  }

  /// Internal fetch method
  Future<void> _fetchWeather(LocationModel location) async {
    final data = await _apiService.getForecast(location);
    _weatherData = data;
    _errorMessage = null;
  }
}
