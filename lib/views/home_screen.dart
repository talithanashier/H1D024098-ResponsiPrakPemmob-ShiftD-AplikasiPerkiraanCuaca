import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/empty_error_view.dart';
import '../widgets/weather_detail_grid.dart';
import '../widgets/weather_header_card.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingPulse;

  @override
  void initState() {
    super.initState();
    _loadingPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
      context.read<LocationViewModel>().loadLocalData();
    });
  }

  @override
  void dispose() {
    _loadingPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: PastelColors.burgundyLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.cloud_sync_rounded,
                  color: PastelColors.burgundy, size: 22),
            ),
            const SizedBox(width: 10),
            const Text('Responsi Cuaca'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Lokasi Favorit',
            icon: const Icon(Icons.favorite_rounded, color: PastelColors.burgundySoft),
            onPressed: () {
              Navigator.push(
                context,
                _slideRoute(const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Cari Kota',
            icon: const Icon(Icons.search_rounded, color: PastelColors.textDark),
            onPressed: () {
              Navigator.push(
                context,
                _slideRoute(const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, weatherVM, child) {
          // Loading state
          if (weatherVM.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.3, end: 1.0)
                        .animate(_loadingPulse),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: PastelColors.burgundyLight.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_download_rounded,
                        size: 48,
                        color: PastelColors.burgundy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Mengambil data cuaca...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: PastelColors.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          // Error state
          if (weatherVM.errorMessage != null && weatherVM.weatherData == null) {
            return EmptyErrorView(
              title: 'Gagal Memuat Cuaca',
              message: weatherVM.errorMessage!,
              icon: Icons.cloud_off_rounded,
              onRetry: () => weatherVM.initialize(),
            );
          }

          final weatherData = weatherVM.weatherData;
          // Empty state
          if (weatherData == null) {
            return EmptyErrorView(
              title: 'Tidak Ada Data',
              message: 'Pilih lokasi kota untuk menampilkan ramalan cuaca.',
              icon: Icons.location_searching_rounded,
              retryText: 'Cari Kota',
              onRetry: () {
                Navigator.push(
                  context,
                  _slideRoute(const SearchScreen()),
                );
              },
            );
          }

          // Success state with data
          return RefreshIndicator(
            onRefresh: () => weatherVM.refresh(),
            color: PastelColors.burgundy,
            backgroundColor: PastelColors.cream,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeatherHeaderCard(
                    weatherData: weatherData,
                    isFavorite: weatherVM.isFavorite,
                    onFavoriteToggle: () async {
                      await weatherVM.toggleFavorite();
                      if (context.mounted) {
                        context.read<LocationViewModel>().loadLocalData();
                        final isFav = weatherVM.isFavorite;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFav
                                  ? '${weatherData.location.name} ditambahkan ke favorit ❤️'
                                  : '${weatherData.location.name} dihapus dari favorit',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  WeatherDetailGrid(weatherData: weatherData),

                  const SizedBox(height: 20),

                  DailyForecastList(forecasts: weatherData.dailyForecasts),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      'Data cuaca bersumber dari Open-Meteo REST API',
                      style: TextStyle(
                        fontSize: 11,
                        color: PastelColors.textLight,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: PastelColors.burgundy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.search_rounded),
        label: const Text('Ganti Kota', style: TextStyle(fontWeight: FontWeight.w600)),
        onPressed: () {
          Navigator.push(
            context,
            _slideRoute(const SearchScreen()),
          );
        },
      ),
    );
  }

  /// Slide-up page transition for navigation
  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
