import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
      context.read<LocationViewModel>().loadLocalData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_sync_rounded, color: Color(0xFF3B82F6), size: 24),
            SizedBox(width: 8),
            Text('Responsi Cuaca'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Lokasi Favorit',
            icon: const Icon(Icons.star_rounded, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Cari Kota',
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, weatherVM, child) {
          // Kondisi 1: Sedang Loading data awal
          if (weatherVM.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF3B82F6),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Mengambil data cuaca...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Kondisi 2: Terjadi error saat request API
          if (weatherVM.errorMessage != null && weatherVM.weatherData == null) {
            return EmptyErrorView(
              title: 'Gagal Memuat Cuaca',
              message: weatherVM.errorMessage!,
              icon: Icons.cloud_off_rounded,
              onRetry: () => weatherVM.initialize(),
            );
          }

          final weatherData = weatherVM.weatherData;
          // Kondisi 3: Data kosong atau belum termuat
          if (weatherData == null) {
            return EmptyErrorView(
              title: 'Tidak Ada Data',
              message: 'Pilih lokasi kota untuk menampilkan ramalan cuaca.',
              icon: Icons.location_searching_rounded,
              retryText: 'Cari Kota',
              onRetry: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            );
          }

          // Kondisi 4: Data berhasil didapat dari Open-Meteo API
          return RefreshIndicator(
            onRefresh: () => weatherVM.refresh(),
            color: const Color(0xFF3B82F6),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu Utama Cuaca Terkini
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
                                  ? '${weatherData.location.name} ditambahkan ke favorit'
                                  : '${weatherData.location.name} dihapus dari favorit',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Grid Informasi Tambahan (Kelembapan, Angin, Kemungkinan Hujan, Suhu Terasa, Presipitasi)
                  WeatherDetailGrid(weatherData: weatherData),

                  const SizedBox(height: 20),

                  // Prakiraan Cuaca Harian (Next days forecast)
                  DailyForecastList(forecasts: weatherData.dailyForecasts),

                  const SizedBox(height: 28),

                  // Footer Sumber Data
                  Center(
                    child: Text(
                      'Data cuaca bersumber dari Open-Meteo REST API',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
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
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.search_rounded),
        label: const Text('Ganti Kota'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        },
      ),
    );
  }
}
