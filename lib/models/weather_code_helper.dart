import 'package:flutter/material.dart';

class WeatherCodeInfo {
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color primaryColor;

  const WeatherCodeInfo({
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.primaryColor,
  });
}

/// Pastel-themed gradient + icon per WMO weather code
class WeatherCodeHelper {
  static WeatherCodeInfo getInfo(int code) {
    switch (code) {
      case 0:
        return const WeatherCodeInfo(
          description: 'Cerah',
          icon: Icons.wb_sunny_rounded,
          gradientColors: [Color(0xFFFFE9A0), Color(0xFFF5CAC3)],
          primaryColor: Color(0xFFD4A843),
        );
      case 1:
        return const WeatherCodeInfo(
          description: 'Sebagian Cerah',
          icon: Icons.wb_sunny_outlined,
          gradientColors: [Color(0xFFFFE9A0), Color(0xFFB8D8E8)],
          primaryColor: Color(0xFFD4A843),
        );
      case 2:
        return const WeatherCodeInfo(
          description: 'Berawan Sebagian',
          icon: Icons.cloud_queue_rounded,
          gradientColors: [Color(0xFFB8D8E8), Color(0xFFC5DEAD)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 3:
        return const WeatherCodeInfo(
          description: 'Berawan Tebal',
          icon: Icons.cloud_rounded,
          gradientColors: [Color(0xFF8B3A62), Color(0xFFB56B8A)],
          primaryColor: Color(0xFF8B3A62),
        );
      case 45:
      case 48:
        return const WeatherCodeInfo(
          description: 'Berkabut',
          icon: Icons.blur_on_rounded,
          gradientColors: [Color(0xFFA3B06D), Color(0xFFE8EDCF)],
          primaryColor: Color(0xFF7B8B4E),
        );
      case 51:
        return const WeatherCodeInfo(
          description: 'Gerimis Ringan',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFFB8D8E8), Color(0xFFC5DEAD)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 53:
      case 55:
        return const WeatherCodeInfo(
          description: 'Gerimis Sedang / Lebat',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFF8B3A62), Color(0xFFB8D8E8)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 56:
      case 57:
        return const WeatherCodeInfo(
          description: 'Gerimis Dingin Membeku',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFFB8D8E8), Color(0xFFF5CAC3)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 61:
        return const WeatherCodeInfo(
          description: 'Hujan Ringan',
          icon: Icons.water_drop_outlined,
          gradientColors: [Color(0xFFB8D8E8), Color(0xFF8B3A62)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 63:
        return const WeatherCodeInfo(
          description: 'Hujan Sedang',
          icon: Icons.water_drop_rounded,
          gradientColors: [Color(0xFF7B8B4E), Color(0xFFB8D8E8)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 65:
        return const WeatherCodeInfo(
          description: 'Hujan Lebat',
          icon: Icons.thunderstorm_outlined,
          gradientColors: [Color(0xFF8B3A62), Color(0xFF7B8B4E)],
          primaryColor: Color(0xFF8B3A62),
        );
      case 66:
      case 67:
        return const WeatherCodeInfo(
          description: 'Hujan Es Beku',
          icon: Icons.severe_cold_rounded,
          gradientColors: [Color(0xFFC5DEAD), Color(0xFFB8D8E8)],
          primaryColor: Color(0xFF7FAF60),
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherCodeInfo(
          description: 'Hujan Salju',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFFB8D8E8), Color(0xFFF5CAC3)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 80:
      case 81:
      case 82:
        return const WeatherCodeInfo(
          description: 'Hujan Badai Lokal',
          icon: Icons.beach_access_rounded,
          gradientColors: [Color(0xFF8B3A62), Color(0xFFB8D8E8)],
          primaryColor: Color(0xFF8B3A62),
        );
      case 85:
      case 86:
        return const WeatherCodeInfo(
          description: 'Hujan Badai Salju',
          icon: Icons.ac_unit_outlined,
          gradientColors: [Color(0xFFB8D8E8), Color(0xFFC5DEAD)],
          primaryColor: Color(0xFF6FA3C0),
        );
      case 95:
        return const WeatherCodeInfo(
          description: 'Badai Petir',
          icon: Icons.flash_on_rounded,
          gradientColors: [Color(0xFF8B3A62), Color(0xFFFFE9A0)],
          primaryColor: Color(0xFFD4A843),
        );
      case 96:
      case 99:
        return const WeatherCodeInfo(
          description: 'Badai Petir & Hujan Es',
          icon: Icons.thunderstorm_rounded,
          gradientColors: [Color(0xFF8B3A62), Color(0xFF7B8B4E)],
          primaryColor: Color(0xFF8B3A62),
        );
      default:
        return const WeatherCodeInfo(
          description: 'Cuaca Berubah',
          icon: Icons.cloud_outlined,
          gradientColors: [Color(0xFFA3B06D), Color(0xFFF5CAC3)],
          primaryColor: Color(0xFF7B8B4E),
        );
    }
  }
}
