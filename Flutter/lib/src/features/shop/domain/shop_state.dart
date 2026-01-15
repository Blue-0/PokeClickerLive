import 'package:freezed_annotation/freezed_annotation.dart';
import 'upgrade.dart';

part 'shop_state.freezed.dart';

@freezed
abstract class ShopState with _$ShopState {
  const factory ShopState({required List<Upgrade> upgrades}) = _ShopState;

  factory ShopState.initial() => ShopState(
    upgrades: [
      const Upgrade(
        id: 'click_power',
        name: 'Click Power',
        description: '+1 damage per click',
        icon: '⚔️',
        baseCost: 10,
        costMultiplier: 1.5,
        effectValue: 1,
      ),
      const Upgrade(
        id: 'auto_clicker',
        name: 'Auto Clicker',
        description: '+1 DPS (damage per second)',
        icon: '🤖',
        baseCost: 50,
        costMultiplier: 1.8,
        effectValue: 1,
      ),
      const Upgrade(
        id: 'critical_hit',
        name: 'Critical Hit',
        description: '+5% critical chance',
        icon: '💥',
        baseCost: 100,
        costMultiplier: 2.0,
        effectValue: 5,
      ),
    ],
  );
}
