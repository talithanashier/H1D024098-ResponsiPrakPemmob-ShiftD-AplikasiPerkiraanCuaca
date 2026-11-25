import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailGrid extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetailGrid({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final current = weatherData.current;
    final rainProb = weatherData.dailyForecasts.isNotEmpty
        ? weatherData.dailyForecasts.first.precipitationProbability
        : 0;

    final items = [
      _DetailItem(
        icon: Icons.water_drop_outlined,
        iconColor: Colors.blue,
        label: 'Kelembapan',
        value: '${current.relativeHumidity}%',
        description: 'Kelembapan relatif udara',
      ),
      _DetailItem(
        icon: Icons.air_rounded,
        iconColor: Colors.teal,
        label: 'Kecepatan Angin',
        value: '${current.windSpeed.toStringAsFixed(1)} km/h',
        description: 'Kecepatan angin 10m',
      ),
      _DetailItem(
        icon: Icons.umbrella_rounded,
        iconColor: Colors.indigo,
        label: 'Peluang Hujan',
        value: '$rainProb%',
        description: 'Kemungkinan hujan hari ini',
      ),
      _DetailItem(
        icon: Icons.thermostat_rounded,
        iconColor: Colors.deepOrange,
        label: 'Suhu Terasa',
        value: '${current.apparentTemperature.toStringAsFixed(1)}°C',
        description: 'Suhu yang dirasakan tubuh',
      ),
      _DetailItem(
        icon: Icons.grain_rounded,
        iconColor: Colors.lightBlue,
        label: 'Curah Hujan',
        value: '${current.precipitation.toStringAsFixed(1)} mm',
        description: 'Presipitasi saat ini',
      ),
      _DetailItem(
        icon: Icons.wb_sunny_rounded,
        iconColor: Colors.amber,
        label: 'Indeks Cuaca',
        value: 'WMO ${current.weatherCode}',
        description: 'Kode standar meteorologi',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Informasi Tambahan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.55,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: item.iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: item.iconColor, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DetailItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String description;

  _DetailItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.description,
  });
}
