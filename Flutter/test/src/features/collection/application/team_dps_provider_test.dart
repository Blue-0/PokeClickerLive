import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokeclickerlive/src/features/collection/application/collection_controller.dart';
import 'package:pokeclickerlive/src/features/collection/application/team_controller.dart';
import 'package:pokeclickerlive/src/features/collection/application/team_dps_provider.dart';
import 'package:pokeclickerlive/src/features/collection/domain/collection_state.dart';
import 'package:pokeclickerlive/src/features/collection/domain/team_state.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';
import 'package:pokeclickerlive/src/features/pokemon/application/pokemon_provider.dart';
import 'package:pokeclickerlive/src/features/pokemon/data/pokemon_repository.dart';
import 'package:pokeclickerlive/src/features/pokemon/domain/pokemon.dart';
import 'package:fpdart/fpdart.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

class FakeTeamController extends TeamController {
  final List<String> ids;
  FakeTeamController(this.ids);
  @override
  TeamState build() => TeamState(activePokemonIds: ids);
}

class FakeCollectionController extends CollectionController {
  final List<UserPokemon> pokemon;
  FakeCollectionController(this.pokemon);
  @override
  CollectionState build() => CollectionState(ownedPokemon: pokemon);
}

void main() {
  late MockPokemonRepository mockRepo;

  setUp(() {
    mockRepo = MockPokemonRepository();
  });

  test('teamDpsProvider calculates 10% of total attack', () async {
    final now = DateTime.now();
    final container = ProviderContainer(
      overrides: [
        pokemonRepositoryProvider.overrideWithValue(mockRepo),
        teamControllerProvider.overrideWith(
          () => FakeTeamController(['1', '2']),
        ),
        collectionControllerProvider.overrideWith(
          () => FakeCollectionController([
            UserPokemon(id: '1', pokemonId: 10, acquiredAt: now),
            UserPokemon(id: '2', pokemonId: 20, acquiredAt: now),
          ]),
        ),
      ],
    );

    when(() => mockRepo.getPokemon(10)).thenAnswer(
      (_) async => Right(
        Pokemon(id: 10, name: 'P1', spriteUrl: '', hp: 100, attack: 50),
      ),
    );
    when(() => mockRepo.getPokemon(20)).thenAnswer(
      (_) async => Right(
        Pokemon(id: 20, name: 'P2', spriteUrl: '', hp: 100, attack: 30),
      ),
    );

    final dps = await container.read(teamDpsProvider.future);
    expect(dps, 8); // (50 + 30) / 10 = 8
  });
}
