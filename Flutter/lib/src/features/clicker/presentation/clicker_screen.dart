import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokeclickerlive/src/features/shop/presentation/shop_screen.dart';
import 'package:pokeclickerlive/src/features/world/presentation/zone_map_screen.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';
import 'package:pokeclickerlive/src/features/world/domain/zone_type.dart';
import '../application/clicker_controller.dart';
import '../application/pokemon_cache_service.dart';
import '../domain/clicker_state.dart';
import 'widgets/poke_currency.dart';

class ClickerScreen extends ConsumerStatefulWidget {
  const ClickerScreen({super.key});

  @override
  ConsumerState<ClickerScreen> createState() => _ClickerScreenState();
}

class _ClickerScreenState extends ConsumerState<ClickerScreen>
    with TickerProviderStateMixin {
  final List<_FloatingTextItem> _floatingTexts = [];
  final Random _random = Random();

  void _spawnFloatingText(Offset position, String text) {
    // Limit concurrent texts
    if (_floatingTexts.length > 20) {
      final removed = _floatingTexts.removeAt(0);
      removed.animationController.dispose();
    }

    final id = DateTime.now().microsecondsSinceEpoch;
    setState(() {
      _floatingTexts.add(
        _FloatingTextItem(
          id: id,
          position: position,
          text: text,
          animationController:
              AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 800),
                )
                ..forward().whenComplete(() {
                  _removeFloatingText(id);
                }),
        ),
      );
    });
  }

  void _removeFloatingText(int id) {
    if (!mounted) return;
    setState(() {
      final index = _floatingTexts.indexWhere((item) => item.id == id);
      if (index != -1) {
        _floatingTexts[index].animationController.dispose();
        _floatingTexts.removeAt(index);
      }
    });
  }

  @override
  void dispose() {
    for (var item in _floatingTexts) {
      item.animationController.dispose();
    }
    super.dispose();
  }

  void _handleTap(TapUpDetails details) {
    ref.read(clickerControllerProvider.notifier).click();

    // Record kill for zone progression
    ref.read(zoneControllerProvider.notifier).recordKill();

    // Add randomness to position
    final randomOffset = Offset(
      (_random.nextDouble() - 0.5) * 40,
      (_random.nextDouble() - 0.5) * 40,
    );

    final damage = ref.read(clickerControllerProvider).clickPower;
    _spawnFloatingText(details.globalPosition + randomOffset, "+$damage");
  }

  /// Get zone-specific gradient based on zone type
  LinearGradient _getZoneGradient(ZoneType type) {
    switch (type) {
      case ZoneType.route:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade100, Colors.green.shade100],
        );
      case ZoneType.town:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade50, Colors.amber.shade100],
        );
      case ZoneType.dungeon:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple.shade100, Colors.deepPurple.shade200],
        );
    }
  }

  /// Build town view (no wild Pokémon)
  Widget _buildTownView(String townName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_city, size: 120, color: Colors.orange.shade700),
          const SizedBox(height: 24),
          Text(
            'Welcome to $townName!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'No wild Pokémon here',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Travel to a route to encounter Pokémon',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build combat view (with wild Pokémon)
  Widget _buildCombatView(
    ClickerState state,
    dynamic cacheManager,
    ZoneState zoneState,
    int? targetKills,
  ) {
    final currentKills = zoneState.killCounts[zoneState.currentZone.id] ?? 0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Kill Progress indicator
          if (targetKills != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Kills: $currentKills / $targetKills',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),

          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatChip(
                  icon: '⚔️',
                  label: 'DMG',
                  value: '${state.clickPower}',
                ),
                _StatChip(icon: '⚡', label: 'DPS', value: '${state.dps}'),
                _StatChip(
                  icon: '🎯',
                  label: 'CRIT',
                  value: '${state.critChance}%',
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Pokémon Display
          if (state.isLoading)
            const CircularProgressIndicator()
          else if (state.currentPokemon != null)
            Column(
              children: [
                // Pokémon Name
                Text(
                  state.currentPokemon!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // HP Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('HP'),
                          Text('${state.currentHp} / ${state.maxHp}'),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: state.currentHp / state.maxHp,
                          minHeight: 20,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            state.currentHp / state.maxHp > 0.5
                                ? Colors.green
                                : state.currentHp / state.maxHp > 0.2
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Pokémon Sprite (Tappable)
                GestureDetector(
                  onTapUp: _handleTap,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: state.currentPokemon!.spriteUrl,
                        cacheManager: cacheManager,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            const Text('No Pokémon encountered'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clickerControllerProvider);
    final cacheManager = ref.watch(pokemonCacheManagerProvider);
    final zoneState = ref.watch(zoneControllerProvider);

    // Listen for new unlocks to show notification
    ref.listen(zoneControllerProvider.select((s) => s.newlyUnlockedZoneNames), (
      previous,
      next,
    ) {
      if (next.isNotEmpty) {
        for (final zoneName in next) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🎉 New Zone Unlocked: $zoneName!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        // Clear after showing
        ref.read(zoneControllerProvider.notifier).clearUnlockNotification();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(zoneState.currentZone.name),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          // Map button
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ZoneMapScreen()));
            },
          ),
          // Currency display
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PokeCurrency(currency: state.currency),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ShopScreen()));
        },
        backgroundColor: Colors.amber.shade700,
        icon: const Icon(Icons.store),
        label: const Text('Shop'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: _getZoneGradient(zoneState.currentZone.type),
            ),
            child: zoneState.currentZone.pokemonIds.isEmpty
                ? _buildTownView(zoneState.currentZone.name)
                : _buildCombatView(
                    state,
                    cacheManager,
                    zoneState,
                    ref
                        .read(zoneControllerProvider.notifier)
                        .getKillTargetForCurrentZone(),
                  ),
          ),

          // Floating damage texts
          ..._floatingTexts.map((item) {
            return _FloatingText(
              key: ValueKey(item.id),
              position: item.position,
              text: item.text,
              animationController: item.animationController,
            );
          }),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FloatingTextItem {
  final int id;
  final Offset position;
  final String text;
  final AnimationController animationController;

  _FloatingTextItem({
    required this.id,
    required this.position,
    required this.text,
    required this.animationController,
  });
}

class _FloatingText extends StatelessWidget {
  final Offset position;
  final String text;
  final AnimationController animationController;

  const _FloatingText({
    super.key,
    required this.position,
    required this.text,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final opacity = 1.0 - animationController.value;
        final yOffset = -50 * animationController.value;

        return Positioned(
          left: position.dx,
          top: position.dy + yOffset,
          child: Opacity(
            opacity: opacity,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
