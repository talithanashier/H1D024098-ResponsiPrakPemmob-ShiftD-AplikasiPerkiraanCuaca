import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../theme/app_theme.dart';

class SearchResultTile extends StatefulWidget {
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
  State<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = widget.location;
    final isFav = loc.isFavorite;

    return ScaleTransition(
      scale: _bounceController,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isFav
                ? PastelColors.burgundyLight
                : PastelColors.oliveLight.withValues(alpha: 0.6),
          ),
        ),
        color: isFav
            ? PastelColors.burgundyLight.withValues(alpha: 0.3)
            : PastelColors.cardBg,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTapDown: (_) => _bounceController.reverse(),
          onTapUp: (_) {
            _bounceController.forward();
            widget.onTap();
          },
          onTapCancel: () => _bounceController.forward(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Leading icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isFav
                        ? PastelColors.burgundyLight
                        : PastelColors.pastelBlue.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.location_city_rounded,
                    color: isFav
                        ? PastelColors.burgundy
                        : PastelColors.pastelBlueDark,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: PastelColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loc.displayName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: PastelColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lat: ${loc.latitude.toStringAsFixed(2)}, Lon: ${loc.longitude.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: PastelColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                // Favorite star
                _AnimatedStar(
                  isFavorite: isFav,
                  onPressed: widget.onFavoriteToggle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedStar extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _AnimatedStar({required this.isFavorite, required this.onPressed});

  @override
  State<_AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<_AnimatedStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _ctrl.forward(from: 0);
        widget.onPressed();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final scale = 1.0 + 0.4 * (1 - (_ctrl.value * 2 - 1).abs());
          return Transform.scale(scale: scale, child: child);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: widget.isFavorite ? PastelColors.burgundy : PastelColors.textLight,
            size: 26,
          ),
        ),
      ),
    );
  }
}
