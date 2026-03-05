import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokeclickerlive/src/features/collection/application/collection_controller.dart';
import 'package:pokeclickerlive/src/features/collection/application/team_controller.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';
import 'package:pokeclickerlive/src/features/pokemon/application/pokemon_provider.dart';

class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  /// Number of collection items to display. Grows by [_pageSize] each time
  /// the user taps "Load more".
  static const int _pageSize = 20;
  int _visibleCount = _pageSize;

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamControllerProvider);
    final collectionState = ref.watch(collectionControllerProvider);

    final allPokemon = collectionState.ownedPokemon;
    final visiblePokemon = allPokemon.take(_visibleCount).toList();
    final hasMore = allPokemon.length > _visibleCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Team'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ── Active Team (6 Slots) ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Team (Max 6)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final pokemonId = index < teamState.activePokemonIds.length
                        ? teamState.activePokemonIds[index]
                        : null;
                    return _TeamSlot(pokemonId: pokemonId, index: index);
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Collection (PC) ───────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        'Collection (PC)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${allPokemon.length} Pokémon',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: visiblePokemon.length,
                        itemBuilder: (context, index) {
                          final userPokemon = visiblePokemon[index];
                          final isActive = teamState.activePokemonIds
                              .contains(userPokemon.id);
                          return _CollectionItem(
                            userPokemon: userPokemon,
                            isActive: isActive,
                          );
                        },
                      ),

                      // ── Load-more button ──────────────────────────────
                      if (hasMore)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _visibleCount += _pageSize;
                                });
                              },
                              icon: const Icon(Icons.expand_more),
                              label: Text(
                                'Load more'
                                ' (${allPokemon.length - _visibleCount} remaining)',
                              ),
                            ),
                          ),
                        ),

                      if (!hasMore && allPokemon.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              'All ${allPokemon.length} Pokémon shown',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamSlot extends ConsumerWidget {
  final String? pokemonId;
  final int index;

  const _TeamSlot({this.pokemonId, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionState = ref.watch(collectionControllerProvider);

    UserPokemon? userPokemon;
    if (pokemonId != null) {
      try {
        userPokemon = collectionState.ownedPokemon.firstWhere(
          (p) => p.id == pokemonId,
        );
      } catch (_) {
        // Pokemon might have been deleted? Or not loaded yet.
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: pokemonId != null ? Colors.red.shade300 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          if (pokemonId != null)
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        children: [
          if (userPokemon != null)
            _PokemonSprite(
              speciesId: userPokemon.pokemonId,
              onTap: () {
                ref
                    .read(teamControllerProvider.notifier)
                    .removeFromTeam(pokemonId!);
              },
            )
          else
            const Center(child: Icon(Icons.add, color: Colors.grey)),
          Positioned(
            top: 4,
            left: 4,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
          ),
          if (pokemonId != null)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.remove_circle,
                  size: 20,
                  color: Colors.red,
                ),
                onPressed: () {
                  ref
                      .read(teamControllerProvider.notifier)
                      .removeFromTeam(pokemonId!);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _CollectionItem extends ConsumerWidget {
  final UserPokemon userPokemon;
  final bool isActive;

  const _CollectionItem({required this.userPokemon, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          ref
              .read(teamControllerProvider.notifier)
              .removeFromTeam(userPokemon.id);
        } else {
          final team = ref.read(teamControllerProvider);
          if (team.activePokemonIds.length < 6) {
            ref.read(teamControllerProvider.notifier).addToTeam(userPokemon.id);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Team is full!')));
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.red.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.red.shade400 : Colors.grey.shade300,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            _PokemonSprite(speciesId: userPokemon.pokemonId),
            if (isActive)
              const Positioned(
                bottom: 2,
                right: 2,
                child: Icon(Icons.check_circle, size: 16, color: Colors.red),
          ),
          ],
        ),
      ),
    );
  }
}

class _PokemonSprite extends ConsumerWidget {
  final int speciesId;
  final VoidCallback? onTap;

  const _PokemonSprite({required this.speciesId, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonAsync = ref.watch(pokemonDetailsProvider(speciesId));

    return pokemonAsync.when(
      data: (pokemon) {
        if (pokemon == null) return const Icon(Icons.error);
        return Center(
          child: CachedNetworkImage(
            imageUrl: pokemon.spriteUrl,
            placeholder: (context, url) => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
          ),
        );
      },
      loading: () => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (err, stack) => const Icon(Icons.error),
    );
  }
}
