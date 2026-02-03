import 'package:flutter_test/flutter_test.dart';
import 'package:pokeclickerlive/src/features/world/domain/zone.dart';
import 'package:pokeclickerlive/src/features/world/domain/zone_type.dart';

void main() {
  group('Zone Model', () {
    test('should have boss properties', () {
      const zone = Zone(
        id: 'test_zone',
        name: 'Test Zone',
        type: ZoneType.route,
        bossPokemonId: 402,
        bossTimerSeconds: 30,
      );

      expect(zone.bossPokemonId, 402);
      expect(zone.bossTimerSeconds, 30);
    });
  });
}
