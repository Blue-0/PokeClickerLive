import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokeclickerlive/src/features/collection/data/user_pokemon_adapter.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';
import 'package:pokeclickerlive/src/features/shop/data/inventory_adapter.dart';
import 'package:pokeclickerlive/src/features/shop/domain/inventory.dart';
import 'package:pokeclickerlive/src/features/prestige/data/prestige_repository.dart';

Future<ProviderContainer> bootstrap() async {
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(UserPokemonAdapter());
  Hive.registerAdapter(InventoryAdapter());

  // Open core boxes
  await Hive.openBox<UserPokemon>('user_pokemon');
  await Hive.openBox<List<String>>('team');
  await Hive.openBox<Inventory>('inventory');
  await Hive.openBox<Map>('upgrade_levels');
  await Hive.openBox('auth');
  final prestigeBox = await Hive.openBox<Map<dynamic, dynamic>>('prestige');

  final container = ProviderContainer(
    overrides: [
      prestigeRepositoryProvider.overrideWithValue(
        PrestigeRepository(prestigeBox),
      ),
    ],
  );
  return container;
}
