import 'package:flutter_test/flutter_test.dart';
import 'package:pokeclickerlive/src/features/clicker/domain/clicker_state.dart';

void main() {
  group('ClickerState', () {
    test('should have boss properties', () {
      const state = ClickerState(isBoss: true, remainingBossTime: 30);

      expect(state.isBoss, true);
      expect(state.remainingBossTime, 30);
    });
  });
}
