import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class LocalStorageService {
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyHistory = 'search_history';
  static const String _keyLastLocation = 'last_location';

  /// Mengambil daftar lokasi favorit dari SharedPreferences
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyFavorites);
    if (jsonString == null || jsonString.isEmpty) {
      // Inisialisasi awal beberapa kota favorit default di Indonesia
      final defaultFavorites = [
        LocationModel(
          id: 1642911,
          name: 'Jakarta',
          latitude: -6.21462,
          longitude: 106.84513,
          country: 'Indonesia',
          admin1: 'Jakarta',
          timezone: 'Asia/Jakarta',
          isFavorite: true,
        ),
        LocationModel(
          id: 1650357,
          name: 'Bandung',
          latitude: -6.92222,
          longitude: 107.60694,
          country: 'Indonesia',
          admin1: 'Jawa Barat',
          timezone: 'Asia/Jakarta',
          isFavorite: true,
        ),
        LocationModel(
          id: 1621177,
          name: 'Yogyakarta',
          latitude: -7.79558,
          longitude: 110.36949,
          country: 'Indonesia',
          admin1: 'Daerah Istimewa Yogyakarta',
          timezone: 'Asia/Jakarta',
          isFavorite: true,
        ),
      ];
      final encoded = json.encode(defaultFavorites.map((e) => e.toJson()).toList());
      await prefs.setString(_keyFavorites, encoded);
      return defaultFavorites;
    }

    try {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) {
        final loc = LocationModel.fromJson(item);
        loc.isFavorite = true;
        return loc;
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Menambah atau menyimpan lokasi ke daftar favorit
  Future<void> saveFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    // Hapus jika sudah ada untuk menghindari duplikat
    favorites.removeWhere((item) => item.id == location.id);
    final copy = location.copyWith(isFavorite: true);
    favorites.insert(0, copy);

    final encoded = json.encode(favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_keyFavorites, encoded);
  }

  /// Menghapus lokasi dari daftar favorit berdasarkan ID
  Future<void> removeFavorite(int locationId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.removeWhere((item) => item.id == locationId);

    final encoded = json.encode(favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_keyFavorites, encoded);
  }

  /// Cek apakah lokasi merupakan favorit
  Future<bool> isFavorite(int locationId) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == locationId);
  }

  /// Mengambil riwayat pencarian
  Future<List<LocationModel>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyHistory);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) => LocationModel.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Menambahkan lokasi ke riwayat pencarian (maksimal 10 item terbaru)
  Future<void> addToSearchHistory(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();

    history.removeWhere((item) => item.id == location.id);
    history.insert(0, location);

    if (history.length > 10) {
      history.removeRange(10, history.length);
    }

    final encoded = json.encode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_keyHistory, encoded);
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }

  /// Menyimpan lokasi terakhir yang sedang dibuka pengguna
  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(location.toJson());
    await prefs.setString(_keyLastLocation, encoded);
  }

  /// Mengambil lokasi terakhir yang disimpan
  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyLastLocation);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final decoded = json.decode(jsonString);
      return LocationModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
