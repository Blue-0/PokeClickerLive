import 'package:flutter/material.dart';
import '../../domain/zone.dart';
import '../../domain/zone_type.dart';

/// Individual tile widget for displaying a zone in the map/selector.
class ZoneTile extends StatelessWidget {
  final Zone zone;
  final bool isActive;
  final bool isUnlocked;
  final int? killProgress;
  final int? killRequired;
  final VoidCallback? onTap;

  const ZoneTile({
    super.key,
    required this.zone,
    required this.isActive,
    required this.isUnlocked,
    this.killProgress,
    this.killRequired,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.amber.shade700 : Colors.transparent,
            width: isActive ? 3 : 0,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          children: [
            // Zone icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: isUnlocked
                    ? Icon(_getZoneIcon(), color: Colors.white, size: 28)
                    : const Icon(Icons.lock, color: Colors.white70, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            // Zone info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getZoneTypeLabel(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isUnlocked ? Colors.grey.shade600 : Colors.grey,
                    ),
                  ),
                  if (!isUnlocked &&
                      killProgress != null &&
                      killRequired != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Defeat $killRequired Pokémon to unlock',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: killProgress! / killRequired!,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.orange.shade400,
                            ),
                          ),
                          Text(
                            '$killProgress / $killRequired',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Active indicator or Pokemon count
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'CURRENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              )
            else if (isUnlocked && zone.pokemonIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${zone.pokemonIds.length} species',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!isUnlocked) return Colors.grey.shade200;
    if (isActive) return Colors.amber.shade50;
    return Colors.white;
  }

  Color _getIconBackgroundColor() {
    if (!isUnlocked) return Colors.grey;
    switch (zone.type) {
      case ZoneType.route:
        return Colors.green.shade600;
      case ZoneType.town:
        return Colors.blue.shade600;
      case ZoneType.dungeon:
        return Colors.purple.shade600;
    }
  }

  IconData _getZoneIcon() {
    switch (zone.type) {
      case ZoneType.route:
        return Icons.nature;
      case ZoneType.town:
        return Icons.location_city;
      case ZoneType.dungeon:
        return Icons.terrain;
    }
  }

  String _getZoneTypeLabel() {
    switch (zone.type) {
      case ZoneType.route:
        return 'Route • Wild Pokémon';
      case ZoneType.town:
        return 'Town • Hub Area';
      case ZoneType.dungeon:
        return 'Dungeon • Challenge';
    }
  }
}
