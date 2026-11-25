import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_code_helper.dart';
import '../models/weather_model.dart';
import '../theme/app_theme.dart';

class WeatherHeaderCard extends StatefulWidget {
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
  State<WeatherHeaderCard> createState() => _WeatherHeaderCardState();
}

class _WeatherHeaderCardState extends State<WeatherHeaderCard>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final AnimationController _fadeController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    // Rotating / bobbing weather icon
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Fade-in + slide-up on load
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _fadeController.forward();

    // Gentle pulse for the temperature
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.weatherData.current;
    final info = WeatherCodeHelper.getInfo(current.weatherCode);
    final todayForecast = widget.weatherData.dailyForecasts.isNotEmpty
        ? widget.weatherData.dailyForecasts.first
        : null;

    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);

    return FadeTransition(
      opacity: _fadeAnim,
      child: AnimatedBuilder(
        animation: _slideAnim,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: child,
        ),
        child: Container(
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
                color: info.gradientColors.first.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -15,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // City name & favorite button
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
                                      widget.weatherData.location.name,
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
                              if (widget.weatherData.location.admin1 != null &&
                                  widget.weatherData.location.admin1!.isNotEmpty &&
                                  widget.weatherData.location.admin1 != widget.weatherData.location.name)
                                Padding(
                                  padding: const EdgeInsets.only(left: 26, top: 2),
                                  child: Text(
                                    '${widget.weatherData.location.admin1}, ${widget.weatherData.location.country}',
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
                                    widget.weatherData.location.country,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (widget.onFavoriteToggle != null)
                          _AnimatedFavoriteButton(
                            isFavorite: widget.isFavorite,
                            onPressed: widget.onFavoriteToggle!,
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Animated weather icon
                    AnimatedBuilder(
                      animation: _iconController,
                      builder: (context, child) {
                        final val = _iconController.value;
                        return Transform.translate(
                          offset: Offset(0, math.sin(val * math.pi) * 6),
                          child: Transform.rotate(
                            angle: math.sin(val * math.pi * 2) * 0.05,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        info.icon,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Pulsing temperature
                    ScaleTransition(
                      scale: _pulseAnim,
                      child: Text(
                        '${current.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),

                    // Weather description pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
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

                    Text(
                      dateFormatted,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated heart/star bounce when toggling favorite
class _AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _AnimatedFavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  State<_AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<_AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: IconButton(
        tooltip: widget.isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
        icon: Icon(
          widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: widget.isFavorite ? PastelColors.pastelPink : Colors.white,
          size: 32,
        ),
        onPressed: () {
          _controller.forward(from: 0);
          widget.onPressed();
        },
      ),
    );
  }
}
