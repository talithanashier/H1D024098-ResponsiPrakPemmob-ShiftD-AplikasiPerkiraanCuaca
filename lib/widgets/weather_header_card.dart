import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_code_helper.dart';
import '../models/weather_model.dart';

class WeatherHeaderCard extends StatelessWidget {
  final WeatherData weatherData;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const WeatherHeaderCard({
    super.key,
    required this.weatherData,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final current = weatherData.current;
    final info = WeatherCodeHelper.getInfo(current.weatherCode);
    final todayForecast = weatherData.dailyForecasts.isNotEmpty
        ? weatherData.dailyForecasts.first
        : null;

    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: info.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: info.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Baris nama kota & tombol favorit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            weatherData.location.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (weatherData.location.admin1 != null &&
                        weatherData.location.admin1!.isNotEmpty &&
                        weatherData.location.admin1 != weatherData.location.name)
                      Padding(
                        padding: const EdgeInsets.only(left: 26, top: 2),
                        child: Text(
                          '${weatherData.location.admin1}, ${weatherData.location.country}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 26, top: 2),
                        child: Text(
                          weatherData.location.country,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (onFavoriteToggle != null)
                IconButton(
                  tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
                  icon: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFavorite ? Colors.amberAccent : Colors.white,
                    size: 32,
                  ),
                  onPressed: onFavoriteToggle,
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Icon cuaca & Suhu saat ini
          Icon(
            info.icon,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 8),

          Text(
            '${current.temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 54,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            ),
          ),

          // Deskripsi kondisi cuaca
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              info.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Suhu min dan max hari ini jika tersedia
          if (todayForecast != null)
            Text(
              'Maks: ${todayForecast.maxTemperature.toStringAsFixed(0)}°  •  Min: ${todayForecast.minTemperature.toStringAsFixed(0)}°',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 8),

          // Tanggal
          Text(
            dateFormatted,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
