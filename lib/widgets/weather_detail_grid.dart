import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../theme/app_theme.dart';

class WeatherDetailGrid extends StatefulWidget {
  final WeatherData weatherData;

  const WeatherDetailGrid({super.key, required this.weatherData});

  @override
  State<WeatherDetailGrid> createState() => _WeatherDetailGridState();
}

class _WeatherDetailGridState extends State<WeatherDetailGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.weatherData.current;
    final rainProb = widget.weatherData.dailyForecasts.isNotEmpty
        ? widget.weatherData.dailyForecasts.first.precipitationProbability
        : 0;

    final items = [
      _DetailItem(
        icon: Icons.water_drop_outlined,
        bgColor: PastelColors.pastelBlue,
        iconColor: PastelColors.pastelBlueDark,
        label: 'Kelembapan',
        value: '${current.relativeHumidity}%',
        description: 'Kelembapan relatif udara',
      ),
      _DetailItem(
        icon: Icons.air_rounded,
        bgColor: PastelColors.pastelGreen,
        iconColor: PastelColors.pastelGreenDark,
        label: 'Kecepatan Angin',
        value: '${current.windSpeed.toStringAsFixed(1)} km/h',
        description: 'Kecepatan angin 10m',
      ),
      _DetailItem(
        icon: Icons.umbrella_rounded,
        bgColor: PastelColors.burgundyLight,
        iconColor: PastelColors.burgundy,
        label: 'Peluang Hujan',
        value: '$rainProb%',
        description: 'Kemungkinan hujan hari ini',
      ),
      _DetailItem(
        icon: Icons.thermostat_rounded,
        bgColor: PastelColors.pastelPink,
        iconColor: PastelColors.pastelPinkDark,
        label: 'Suhu Terasa',
        value: '${current.apparentTemperature.toStringAsFixed(1)}°C',
        description: 'Suhu yang dirasakan tubuh',
      ),
      _DetailItem(
        icon: Icons.grain_rounded,
        bgColor: PastelColors.oliveLight,
        iconColor: PastelColors.olive,
        label: 'Curah Hujan',
        value: '${current.precipitation.toStringAsFixed(1)} mm',
        description: 'Presipitasi saat ini',
      ),
      _DetailItem(
        icon: Icons.wb_sunny_rounded,
        bgColor: PastelColors.warmYellow,
        iconColor: PastelColors.goldAccent,
        label: 'Indeks Cuaca',
        value: 'WMO ${current.weatherCode}',
        description: 'Kode standar meteorologi',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: PastelColors.burgundyLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.dashboard_rounded, size: 18, color: PastelColors.burgundy),
              ),
              const SizedBox(width: 10),
              const Text(
                'Informasi Tambahan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PastelColors.textDark,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
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
            // Staggered animation per card
            final startInterval = index * 0.1;
            final endInterval = (startInterval + 0.4).clamp(0.0, 1.0);
            final animation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _staggerController,
                curve: Interval(startInterval, endInterval, curve: Curves.easeOutBack),
              ),
            );

            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - animation.value)),
                  child: Opacity(
                    opacity: animation.value,
                    child: child,
                  ),
                );
              },
              child: _DetailCard(item: item),
            );
          },
        ),
      ],
    );
  }
}

class _DetailCard extends StatefulWidget {
  final _DetailItem item;
  const _DetailCard({required this.item});

  @override
  State<_DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<_DetailCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.bgColor.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.bgColor.withValues(alpha: 0.6),
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
                      color: item.bgColor.withValues(alpha: 0.6),
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
                        color: item.iconColor,
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: PastelColors.textDark,
                ),
              ),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 10,
                  color: PastelColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String label;
  final String value;
  final String description;

  _DetailItem({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.description,
  });
}
