import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:pokeclickerlive/src/features/collection/data/collection_repository.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';

class MockBox extends Mock implements Box<UserPokemon> {}

void main() {
  group('Collection Repository', () {
    late MockBox mockBox;
    late CollectionRepository repository;

    setUpAll(() {
      registerFallbackValue(
        UserPokemon(id: 'dummy', pokemonId: 0, acquiredAt: DateTime.now()),
      );
    });

    setUp(() {
      mockBox = MockBox();
      repository = CollectionRepository(mockBox);
    });

    test('addPokemon should save to box', () async {
      final pokemon = UserPokemon(
        id: '123',
        pokemonId: 25,
        acquiredAt: DateTime.now(),
      );

      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

      await repository.addPokemon(pokemon);

      verify(() => mockBox.put(pokemon.id, pokemon)).called(1);
    });
  });
}
