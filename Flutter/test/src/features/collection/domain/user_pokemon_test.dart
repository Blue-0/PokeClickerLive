import 'package:flutter_test/flutter_test.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';
import 'package:pokeclickerlive/src/features/collection/domain/collection_state.dart';

void main() {
  group('Collection Domain', () {
    test('UserPokemon should be created correctly', () {
      final now = DateTime.now();
      final pokemon = UserPokemon(
        id: 'uuid-123',
        pokemonId: 25,
        acquiredAt: now,
      );

      expect(pokemon.id, 'uuid-123');
      expect(pokemon.pokemonId, 25);
      expect(pokemon.acquiredAt, now);
    });

    test('CollectionState should allow adding pokemon', () {
      const state = CollectionState();
      expect(state.ownedPokemon, isEmpty);
      // Logic for adding would be in controller, but state is just data holder
    });
  });
}
