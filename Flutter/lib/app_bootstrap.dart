import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pokeclickerlive/src/features/collection/data/user_pokemon_adapter.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';
import 'package:pokeclickerlive/src/features/shop/data/inventory_adapter.dart';
import 'package:pokeclickerlive/src/features/shop/domain/inventory.dart';
import 'package:pokeclickerlive/src/features/prestige/data/prestige_repository.dart';
import 'package:pokeclickerlive/src/features/auth/data/auth_repository.dart';

Future<ProviderContainer> bootstrap() async {
  await Hive.initFlutter();

  // Initialize Supabase
  // Ensure to pass these variables at build time: --dart-define=SUPABASE_URL=...
  // Or replace with your actual keys for development.
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://xyz.supabase.co');
  const supabaseKey = String.fromEnvironment('SUPABASE_KEY', defaultValue: 'public-anon-key');

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  } catch (e) {
    // Handle initialization error (e.g. if keys are missing in dev)
    print('Supabase initialization failed: $e');
  }

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

  // Pre-load SharedPreferences so that AuthRepository.getToken() works
  // synchronously from the very first frame (enables auto-login).
  final authRepo = AuthRepository();
  await authRepo.init();

  final container = ProviderContainer(
    overrides: [
      prestigeRepositoryProvider.overrideWithValue(
        PrestigeRepository(prestigeBox),
      ),
      authRepositoryProvider.overrideWithValue(authRepo),
    ],
  );
  return container;
}
