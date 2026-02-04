import 'package:flutter_test/flutter_test.dart';
import 'package:pokeclickerlive/src/features/prestige/domain/prestige_data.dart';

void main() {
  group('PrestigeData Isolated', () {
    test('permanentBonus calculation', () {
      const state = PrestigeData(prestigeLevel: 5);
      expect(state.permanentBonus, 1.5);
    });
  });
}
