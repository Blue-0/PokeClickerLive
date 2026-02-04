import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokeclickerlive/src/features/prestige/data/prestige_repository.dart';
import 'package:pokeclickerlive/src/features/prestige/domain/prestige_data.dart';

class MockPrestigeRepository extends Mock implements PrestigeRepository {}

void main() {
  late MockPrestigeRepository mockRepository;

  setUp(() {
    mockRepository = MockPrestigeRepository();
  });

  group('PrestigeData', () {
    test('permanentBonus calculation is correct', () {
      const state0 = PrestigeData(prestigeLevel: 0);
      expect(state0.permanentBonus, 1.0);

      const state1 = PrestigeData(prestigeLevel: 1);
      expect(state1.permanentBonus, 1.1);

      const state5 = PrestigeData(prestigeLevel: 5);
      expect(state5.permanentBonus, 1.5);

      const state10 = PrestigeData(prestigeLevel: 10);
      expect(state10.permanentBonus, 2.0);
    });

    test('toJson and fromJson work correctly', () {
      const state = PrestigeData(prestigeLevel: 2, badgesAmount: 3);
      final json = state.toJson();
      final fromJson = PrestigeData.fromJson(json);

      expect(fromJson.prestigeLevel, 2);
      expect(fromJson.badgesAmount, 3);
      expect(fromJson.permanentBonus, 1.2);
    });
  });

  group('PrestigeRepository', () {
    test('getPrestige returns default state when no data exists', () {
      when(() => mockRepository.getPrestige()).thenReturn(const PrestigeData());

      final state = mockRepository.getPrestige();

      expect(state.prestigeLevel, 0);
      expect(state.badgesAmount, 0);
    });
  });
}
