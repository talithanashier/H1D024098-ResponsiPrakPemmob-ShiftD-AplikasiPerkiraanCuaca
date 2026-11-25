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

class WeatherCodeHelper {
  static WeatherCodeInfo getInfo(int code) {
    switch (code) {
      case 0:
        return const WeatherCodeInfo(
          description: 'Cerah',
          icon: Icons.wb_sunny_rounded,
          gradientColors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
          primaryColor: Colors.amber,
        );
      case 1:
        return const WeatherCodeInfo(
          description: 'Sebagian Cerah',
          icon: Icons.wb_sunny_outlined,
          gradientColors: [Color(0xFF2980B9), Color(0xFF6DD5FA)],
          primaryColor: Colors.amber,
        );
      case 2:
        return const WeatherCodeInfo(
          description: 'Berawan Sebagian',
          icon: Icons.cloud_queue_rounded,
          gradientColors: [Color(0xFF3a7bd5), Color(0xFF3a6073)],
          primaryColor: Colors.lightBlueAccent,
        );
      case 3:
        return const WeatherCodeInfo(
          description: 'Berawan Tebal',
          icon: Icons.cloud_rounded,
          gradientColors: [Color(0xFF4B6CB7), Color(0xFF182848)],
          primaryColor: Colors.blueGrey,
        );
      case 45:
      case 48:
        return const WeatherCodeInfo(
          description: 'Berkabut',
          icon: Icons.blur_on_rounded,
          gradientColors: [Color(0xFF606c38), Color(0xFF283618)],
          primaryColor: Colors.teal,
        );
      case 51:
        return const WeatherCodeInfo(
          description: 'Gerimis Ringan',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFF3a7bd5), Color(0xFF2b5876)],
          primaryColor: Colors.lightBlue,
        );
      case 53:
      case 55:
        return const WeatherCodeInfo(
          description: 'Gerimis Sedang / Lebat',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
          primaryColor: Colors.blue,
        );
      case 56:
      case 57:
        return const WeatherCodeInfo(
          description: 'Gerimis Dingin Membeku',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
          primaryColor: Colors.cyan,
        );
      case 61:
        return const WeatherCodeInfo(
          description: 'Hujan Ringan',
          icon: Icons.water_drop_outlined,
          gradientColors: [Color(0xFF283E51), Color(0xFF4B79A1)],
          primaryColor: Colors.blueAccent,
        );
      case 63:
        return const WeatherCodeInfo(
          description: 'Hujan Sedang',
          icon: Icons.water_drop_rounded,
          gradientColors: [Color(0xFF141E30), Color(0xFF243B55)],
          primaryColor: Colors.blue,
        );
      case 65:
        return const WeatherCodeInfo(
          description: 'Hujan Lebat',
          icon: Icons.thunderstorm_outlined,
          gradientColors: [Color(0xFF0f2027), Color(0xFF203a43)],
          primaryColor: Colors.indigo,
        );
      case 66:
      case 67:
        return const WeatherCodeInfo(
          description: 'Hujan Es Beku',
          icon: Icons.severe_cold_rounded,
          gradientColors: [Color(0xFF1D976C), Color(0xFF93F9B9)],
          primaryColor: Colors.cyanAccent,
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherCodeInfo(
          description: 'Hujan Salju',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFF83a4d4), Color(0xFFb6fbff)],
          primaryColor: Colors.lightBlueAccent,
        );
      case 80:
      case 81:
      case 82:
        return const WeatherCodeInfo(
          description: 'Hujan Badai Lokal',
          icon: Icons.beach_access_rounded,
          gradientColors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
          primaryColor: Colors.blue,
        );
      case 85:
      case 86:
        return const WeatherCodeInfo(
          description: 'Hujan Badai Salju',
          icon: Icons.ac_unit_outlined,
          gradientColors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
          primaryColor: Colors.cyan,
        );
      case 95:
        return const WeatherCodeInfo(
          description: 'Badai Petir',
          icon: Icons.flash_on_rounded,
          gradientColors: [Color(0xFF141E30), Color(0xFF243B55)],
          primaryColor: Colors.amber,
        );
      case 96:
      case 99:
        return const WeatherCodeInfo(
          description: 'Badai Petir & Hujan Es',
          icon: Icons.thunderstorm_rounded,
          gradientColors: [Color(0xFF0F2027), Color(0xFF2C5364)],
          primaryColor: Colors.deepOrangeAccent,
        );
      default:
        return const WeatherCodeInfo(
          description: 'Cuaca Berubah',
          icon: Icons.cloud_outlined,
          gradientColors: [Color(0xFF3E5151), Color(0xFFDECBA4)],
          primaryColor: Colors.blueGrey,
        );
    }
  }
}
