import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/search_result_tile.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationVM = context.watch<LocationViewModel>();
    final favorites = locationVM.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kota Favorit Saya'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star_border_rounded,
                        size: 72,
                        color: Colors.amber.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Belum Ada Lokasi Favorit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tandai kota favorit Anda dengan menekan ikon bintang di halaman beranda atau hasil pencarian untuk akses cepat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final loc = favorites[index];
                return Dismissible(
                  key: Key('fav_${loc.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    locationVM.toggleFavorite(loc);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${loc.name} dihapus dari favorit'),
                      ),
                    );
                  },
                  child: SearchResultTile(
                    location: loc,
                    onTap: () {
                      context.read<WeatherViewModel>().selectLocation(loc);
                      Navigator.pop(context);
                    },
                    onFavoriteToggle: () {
                      locationVM.toggleFavorite(loc);
                    },
                  ),
                );
              },
            ),
    );
  }
}
