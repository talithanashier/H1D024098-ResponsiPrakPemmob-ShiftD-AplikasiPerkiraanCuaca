import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_code_helper.dart';
import '../models/weather_model.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> forecasts;

  const DailyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 20, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                'Perkiraan Cuaca Harian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: forecasts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final day = forecasts[index];
            final info = WeatherCodeHelper.getInfo(day.weatherCode);

            // Parsing label hari
            String dayLabel = day.date;
            try {
              final parsedDate = DateTime.parse(day.date);
              final today = DateTime.now();
              if (index == 0) {
                dayLabel = 'Hari ini';
              } else if (parsedDate.day == today.day + 1 &&
                  parsedDate.month == today.month) {
                dayLabel = 'Besok';
              } else {
                dayLabel = DateFormat('EEEE, d MMM', 'id_ID').format(parsedDate);
              }
            } catch (_) {}

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Label hari
                  Expanded(
                    flex: 3,
                    child: Text(
                      dayLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500,
                        color: index == 0 ? Colors.blue.shade700 : null,
                      ),
                    ),
                  ),

                  // Kemungkinan hujan
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (day.precipitationProbability > 0) ...[
                          const Icon(Icons.water_drop, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            '${day.precipitationProbability}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ] else
                          Text(
                            '0%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Icon cuaca & deskripsi singkat
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Tooltip(
                        message: info.description,
                        child: Icon(
                          info.icon,
                          color: info.primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Suhu Min - Max
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${day.minTemperature.toStringAsFixed(0)}°',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey.shade400,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade200, Colors.orange.shade400],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${day.maxTemperature.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
