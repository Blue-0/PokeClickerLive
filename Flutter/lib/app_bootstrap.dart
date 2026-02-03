import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokeclickerlive/src/features/collection/data/user_pokemon_adapter.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';

Future<ProviderContainer> bootstrap() async {
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(UserPokemonAdapter());

  // Open core boxes
  await Hive.openBox<UserPokemon>('user_pokemon');
  await Hive.openBox<List<String>>('team');

  final container = ProviderContainer();
  return container;
}
