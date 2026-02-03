import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/collection/application/collection_controller.dart';
import 'package:pokeclickerlive/src/features/collection/data/collection_repository.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';
import 'package:pokeclickerlive/src/features/collection/application/capture_service.dart';

class MockCollectionRepository extends Mock implements CollectionRepository {}

void main() {
  group('CollectionController', () {
    late MockCollectionRepository mockRepository;
    late ProviderContainer container;

    setUpAll(() {
      registerFallbackValue(
        UserPokemon(id: '123', pokemonId: 1, acquiredAt: DateTime.now()),
      );
      registerFallbackValue(CaptureResult.success);
    });

    setUp(() {
      mockRepository = MockCollectionRepository();

      // Default behavior for mock repo
      when(() => mockRepository.getAllPokemon()).thenReturn([]);
      when(() => mockRepository.addPokemon(any())).thenAnswer((_) async => {});

      container = ProviderContainer(
        overrides: [
          collectionRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    test(
      'recordCaptureAttempt on success should add to repository and update state',
      () async {
        final controller = container.read(
          collectionControllerProvider.notifier,
        );

        await controller.recordCaptureAttempt(25, CaptureResult.success);

        verify(() => mockRepository.addPokemon(any())).called(1);
        final state = container.read(collectionControllerProvider);
        expect(state.ownedPokemon.length, 1);
        expect(state.ownedPokemon.first.pokemonId, 25);
        expect(state.lastCaptureResult, CaptureResult.success);
      },
    );

    test(
      'recordCaptureAttempt on escape should only update notification state',
      () async {
        final controller = container.read(
          collectionControllerProvider.notifier,
        );

        await controller.recordCaptureAttempt(25, CaptureResult.escaped);

        verifyNever(() => mockRepository.addPokemon(any()));
        final state = container.read(collectionControllerProvider);
        expect(state.ownedPokemon, isEmpty);
        expect(state.lastCaptureResult, CaptureResult.escaped);
      },
    );
  });
}
