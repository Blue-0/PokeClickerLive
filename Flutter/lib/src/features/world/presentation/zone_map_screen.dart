import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/zone_controller.dart';
import '../domain/zone.dart';
import 'widgets/zone_tile.dart';

/// Screen for selecting and navigating between zones.
class ZoneMapScreen extends ConsumerWidget {
  const ZoneMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoneState = ref.watch(zoneControllerProvider);
    final controller = ref.read(zoneControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('World Map'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.blue.shade50],
          ),
        ),
        child: Column(
          children: [
            // Header with current zone info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.place, color: Colors.red, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Location',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          zoneState.currentZone.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (zoneState.currentZone.pokemonIds.isNotEmpty)
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
                        '${zoneState.currentZone.pokemonIds.length} species',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Zone list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: zoneState.allZones.length,
                itemBuilder: (context, index) {
                  final zone = zoneState.allZones[index];
                  final isActive = zone.id == zoneState.currentZone.id;
                  // Use zone.isUnlocked directly - controller already manages unlock state
                  final isUnlocked = zone.isUnlocked;

                  // Get unlock progress if locked
                  int? killProgress;
                  int? killRequired;
                  if (!isUnlocked && zone.unlockCondition != null) {
                    killRequired = zone.unlockCondition!.killCount;
                    killProgress =
                        zoneState.killCounts[zone
                            .unlockCondition!
                            .sourceZoneId] ??
                        0;
                  }

                  return ZoneTile(
                    zone: zone,
                    isActive: isActive,
                    isUnlocked: isUnlocked,
                    killProgress: killProgress,
                    killRequired: killRequired,
                    onTap: () => _onZoneTap(context, controller, zone),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onZoneTap(BuildContext context, ZoneController controller, Zone zone) {
    final success = controller.selectZone(zone.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moved to ${zone.name}'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green.shade600,
        ),
      );
    }
  }
}
