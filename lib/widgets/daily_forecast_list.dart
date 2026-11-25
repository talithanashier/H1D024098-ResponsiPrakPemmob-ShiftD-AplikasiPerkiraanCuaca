import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_code_helper.dart';
import '../models/weather_model.dart';
import '../theme/app_theme.dart';

class DailyForecastList extends StatefulWidget {
  final List<DailyForecast> forecasts;

  const DailyForecastList({super.key, required this.forecasts});

  @override
  State<DailyForecastList> createState() => _DailyForecastListState();
}

class _DailyForecastListState extends State<DailyForecastList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Alternating pastel colors for each row
  static const _rowColors = [
    PastelColors.pastelBlue,
    PastelColors.pastelPink,
    PastelColors.pastelGreen,
    PastelColors.warmYellow,
    PastelColors.burgundyLight,
    PastelColors.oliveLight,
    PastelColors.pastelBlue,
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.forecasts.isEmpty) {
      return const SizedBox.shrink();
    }

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
                  color: PastelColors.oliveLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month_rounded, size: 18, color: PastelColors.olive),
              ),
              const SizedBox(width: 10),
              const Text(
                'Perkiraan Cuaca Harian',
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
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.forecasts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final day = widget.forecasts[index];
            final info = WeatherCodeHelper.getInfo(day.weatherCode);
            final rowColor = _rowColors[index % _rowColors.length];

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

            // Staggered slide-in animation
            final startInterval = (index * 0.08).clamp(0.0, 0.7);
            final endInterval = (startInterval + 0.3).clamp(0.0, 1.0);
            final slideAnim = Tween<Offset>(
              begin: const Offset(0.5, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(startInterval, endInterval, curve: Curves.easeOutCubic),
              ),
            );
            final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(startInterval, endInterval),
              ),
            );

            return SlideTransition(
              position: slideAnim,
              child: FadeTransition(
                opacity: fadeAnim,
                child: _ForecastRow(
                  dayLabel: dayLabel,
                  day: day,
                  info: info,
                  rowColor: rowColor,
                  isToday: index == 0,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ForecastRow extends StatefulWidget {
  final String dayLabel;
  final DailyForecast day;
  final WeatherCodeInfo info;
  final Color rowColor;
  final bool isToday;

  const _ForecastRow({
    required this.dayLabel,
    required this.day,
    required this.info,
    required this.rowColor,
    required this.isToday,
  });

  @override
  State<_ForecastRow> createState() => _ForecastRowState();
}

class _ForecastRowState extends State<_ForecastRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.rowColor.withValues(alpha: _expanded ? 0.5 : 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.rowColor.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Day label
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.dayLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: widget.isToday ? FontWeight.bold : FontWeight.w500,
                      color: widget.isToday
                          ? PastelColors.burgundy
                          : PastelColors.textDark,
                    ),
                  ),
                ),

                // Rain probability
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.day.precipitationProbability > 0) ...[
                        Icon(Icons.water_drop, size: 14,
                          color: PastelColors.pastelBlueDark),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.day.precipitationProbability}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PastelColors.pastelBlueDark,
                          ),
                        ),
                      ] else
                        Text(
                          '0%',
                          style: TextStyle(
                            fontSize: 12,
                            color: PastelColors.textLight,
                          ),
                        ),
                    ],
                  ),
                ),

                // Weather icon
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Tooltip(
                      message: widget.info.description,
                      child: Icon(
                        widget.info.icon,
                        color: widget.info.primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Min-Max temp
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.day.minTemperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: PastelColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              PastelColors.pastelBlue,
                              PastelColors.pastelPink,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.day.maxTemperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: PastelColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Expandable detail
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _miniDetail(Icons.thermostat, 'Maks',
                        '${widget.day.maxTemperature.toStringAsFixed(1)}°'),
                    _miniDetail(Icons.ac_unit, 'Min',
                        '${widget.day.minTemperature.toStringAsFixed(1)}°'),
                    _miniDetail(Icons.umbrella, 'Hujan',
                        '${widget.day.precipitationProbability}%'),
                    _miniDetail(Icons.cloud, 'Kondisi',
                        widget.info.description),
                  ],
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: PastelColors.burgundySoft),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: PastelColors.textLight)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PastelColors.textDark)),
      ],
    );
  }
}
