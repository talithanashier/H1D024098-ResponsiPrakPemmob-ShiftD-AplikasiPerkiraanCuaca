import 'package:flutter/material.dart';
import '../models/location_model.dart';

class SearchResultTile extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const SearchResultTile({
    super.key,
    required this.location,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.location_city_rounded,
            color: Colors.blue.shade700,
            size: 24,
          ),
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.displayName,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'Lat: ${location.latitude.toStringAsFixed(2)}, Lon: ${location.longitude.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: location.isFavorite ? 'Hapus favorit' : 'Simpan favorit',
          icon: Icon(
            location.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            color: location.isFavorite ? Colors.amber : Colors.grey,
            size: 26,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}
