import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokeclickerlive/src/features/collection/application/team_controller.dart';
import 'package:pokeclickerlive/src/features/collection/data/team_repository.dart';

class MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  late MockTeamRepository mockRepo;

  setUp(() {
    mockRepo = MockTeamRepository();
    when(() => mockRepo.getTeam()).thenReturn([]);
    when(() => mockRepo.saveTeam(any())).thenAnswer((_) async {});
  });

  group('TeamController', () {
    test('initial state loads from repository', () {
      when(() => mockRepo.getTeam()).thenReturn(['p1', 'p2']);

      final container = ProviderContainer(
        overrides: [teamRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      final state = container.read(teamControllerProvider);
      expect(state.activePokemonIds, equals(['p1', 'p2']));
      verify(() => mockRepo.getTeam()).called(1);
    });

    test('addToTeam adds a pokemon ID and saves to repo', () {
      final container = ProviderContainer(
        overrides: [teamRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(teamControllerProvider.notifier);
      notifier.addToTeam('p1');

      final state = container.read(teamControllerProvider);
      expect(state.activePokemonIds, contains('p1'));
      verify(() => mockRepo.saveTeam(['p1'])).called(1);
    });

    test('addToTeam limits to 6 pokemon', () {
      final container = ProviderContainer(
        overrides: [teamRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(teamControllerProvider.notifier);
      for (var i = 1; i <= 7; i++) {
        notifier.addToTeam('p$i');
      }

      final state = container.read(teamControllerProvider);
      expect(state.activePokemonIds.length, 6);
      verify(() => mockRepo.saveTeam(any())).called(6);
    });

    test('removeFromTeam removes a pokemon ID and saves to repo', () {
      final container = ProviderContainer(
        overrides: [teamRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(teamControllerProvider.notifier);
      notifier.addToTeam('p1');
      notifier.removeFromTeam('p1');

      final state = container.read(teamControllerProvider);
      expect(state.activePokemonIds, isEmpty);
      verify(() => mockRepo.saveTeam([])).called(1);
    });

    test('swapSlots swaps two positions and saves to repo', () {
      final container = ProviderContainer(
        overrides: [teamRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(teamControllerProvider.notifier);
      notifier.addToTeam('p1');
      notifier.addToTeam('p2');

      notifier.swapSlots(0, 1);

      final state = container.read(teamControllerProvider);
      expect(state.activePokemonIds[0], 'p2');
      expect(state.activePokemonIds[1], 'p1');
      verify(() => mockRepo.saveTeam(['p2', 'p1'])).called(1);
    });
  });
}
