import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

class LocationViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  LocationViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  // State
  bool _isSearching = false;
  String _searchQuery = '';
  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _searchHistory = [];
  String? _errorMessage;

  Timer? _debounceTimer;

  // Getters
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get favorites => _favorites;
  List<LocationModel> get searchHistory => _searchHistory;
  String? get errorMessage => _errorMessage;

  /// Memuat data favorit dan riwayat pencarian dari penyimpanan lokal
  Future<void> loadLocalData() async {
    _favorites = await _storageService.getFavorites();
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Pencarian dengan debounce (500ms) agar tidak membebani API setiap ketikan
  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      performSearch(query);
    });
  }

  /// Eksekusi pencarian ke REST API Open-Meteo
  Future<void> performSearch(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _apiService.searchCities(cleanQuery);
      // Sinkronkan status favorit
      for (var location in results) {
        location.isFavorite = _favorites.any((f) => f.id == location.id);
      }
      _searchResults = results;
      if (results.isEmpty) {
        _errorMessage = 'Tidak ditemukan lokasi untuk "$cleanQuery"';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Bersihkan input pencarian
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Toggle favorit dari list pencarian atau list favorit
  Future<void> toggleFavorite(LocationModel location) async {
    final isFav = _favorites.any((f) => f.id == location.id);

    if (isFav) {
      await _storageService.removeFavorite(location.id);
      location.isFavorite = false;
    } else {
      await _storageService.saveFavorite(location);
      location.isFavorite = true;
    }

    await loadLocalData();

    // Perbarui status di search results jika sedang tampil
    for (var item in _searchResults) {
      if (item.id == location.id) {
        item.isFavorite = !isFav;
      }
    }
    notifyListeners();
  }

  /// Menghapus item dari riwayat
  Future<void> clearHistory() async {
    await _storageService.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
