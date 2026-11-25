import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/location_model.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/empty_error_view.dart';
import '../widgets/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationViewModel>().loadLocalData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onLocationSelected(LocationModel location) {
    context.read<WeatherViewModel>().selectLocation(location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final locationVM = context.watch<LocationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari & Pilih Lokasi'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF3B82F6),
          indicatorWeight: 3,
          tabs: [
            const Tab(
              icon: Icon(Icons.search_rounded),
              text: 'Pencarian',
            ),
            Tab(
              icon: const Icon(Icons.star_rounded),
              text: 'Favorit (${locationVM.favorites.length})',
            ),
            Tab(
              icon: const Icon(Icons.history_rounded),
              text: 'Riwayat (${locationVM.searchHistory.length})',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Input Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Ketik nama kota (contoh: Yogyakarta, Bandung)...',
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.blueAccent),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          locationVM.clearSearch();
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                locationVM.onSearchChanged(val);
                if (_tabController.index != 0) {
                  _tabController.animateTo(0);
                }
              },
              onSubmitted: (val) {
                locationVM.performSearch(val);
              },
            ),
          ),

          // Tab Bar View (Pencarian, Favorit, Riwayat)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Hasil Pencarian
                _buildSearchResultsTab(locationVM),

                // Tab 2: Lokasi Favorit
                _buildFavoritesTab(locationVM),

                // Tab 3: Riwayat Pencarian
                _buildHistoryTab(locationVM),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsTab(LocationViewModel locationVM) {
    if (locationVM.isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 3),
            SizedBox(height: 16),
            Text('Mencari kota di Open-Meteo...'),
          ],
        ),
      );
    }

    if (locationVM.errorMessage != null && locationVM.searchResults.isEmpty) {
      return EmptyErrorView(
        title: 'Hasil Tidak Ditemukan',
        message: locationVM.errorMessage!,
        icon: Icons.search_off_rounded,
      );
    }

    if (locationVM.searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_city_rounded, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Mulai Mencari Kota',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Ketikkan nama kota atau daerah pada kolom pencarian di atas.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: locationVM.searchResults.length,
      itemBuilder: (context, index) {
        final loc = locationVM.searchResults[index];
        return SearchResultTile(
          location: loc,
          onTap: () => _onLocationSelected(loc),
          onFavoriteToggle: () async {
            await locationVM.toggleFavorite(loc);
            if (context.mounted) {
              final isFav = loc.isFavorite;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav
                        ? '${loc.name} ditambahkan ke favorit'
                        : '${loc.name} dihapus dari favorit',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildFavoritesTab(LocationViewModel locationVM) {
    if (locationVM.favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_outline_rounded, size: 64, color: Colors.amber.shade300),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Lokasi Favorit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Klik ikon bintang pada hasil pencarian atau halaman utama untuk menyimpan lokasi favorit.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: locationVM.favorites.length,
      itemBuilder: (context, index) {
        final loc = locationVM.favorites[index];
        return SearchResultTile(
          location: loc,
          onTap: () => _onLocationSelected(loc),
          onFavoriteToggle: () async {
            await locationVM.toggleFavorite(loc);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${loc.name} dihapus dari favorit'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildHistoryTab(LocationViewModel locationVM) {
    if (locationVM.searchHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Riwayat Pencarian Kosong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Kota yang Anda pilih akan otomatis tersimpan di riwayat ini.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pernah Dicari (${locationVM.searchHistory.length})',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              TextButton.icon(
                onPressed: () => locationVM.clearHistory(),
                icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                label: const Text('Hapus Semua', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            itemCount: locationVM.searchHistory.length,
            itemBuilder: (context, index) {
              final loc = locationVM.searchHistory[index];
              return SearchResultTile(
                location: loc,
                onTap: () => _onLocationSelected(loc),
                onFavoriteToggle: () => locationVM.toggleFavorite(loc),
              );
            },
          ),
        ),
      ],
    );
  }
}
