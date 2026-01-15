import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pokeclickerlive/src/features/clicker/application/clicker_controller.dart';
import '../domain/shop_state.dart';
import '../domain/upgrade.dart';

part 'shop_controller.g.dart';

@riverpod
class ShopController extends _$ShopController {
  @override
  ShopState build() {
    return ShopState.initial();
  }

  /// Try to purchase an upgrade
  bool purchaseUpgrade(String upgradeId) {
    final clickerNotifier = ref.read(clickerControllerProvider.notifier);
    final currency = ref.read(clickerControllerProvider).currency;

    final upgradeIndex = state.upgrades.indexWhere((u) => u.id == upgradeId);
    if (upgradeIndex == -1) return false;

    final upgrade = state.upgrades[upgradeIndex];
    final cost = upgrade.currentCost;

    if (currency < cost) return false;

    // Deduct currency
    clickerNotifier.spendCurrency(cost);

    // Level up the upgrade
    final newUpgrades = List<Upgrade>.from(state.upgrades);
    newUpgrades[upgradeIndex] = Upgrade(
      id: upgrade.id,
      name: upgrade.name,
      description: upgrade.description,
      icon: upgrade.icon,
      level: upgrade.level + 1,
      baseCost: upgrade.baseCost,
      costMultiplier: upgrade.costMultiplier,
      effectValue: upgrade.effectValue,
    );

    state = state.copyWith(upgrades: newUpgrades);

    // Apply upgrade effect
    _applyUpgradeEffect(upgradeId);

    return true;
  }

  void _applyUpgradeEffect(String upgradeId) {
    final clickerNotifier = ref.read(clickerControllerProvider.notifier);

    switch (upgradeId) {
      case 'click_power':
        clickerNotifier.increaseClickPower(1);
        break;
      case 'auto_clicker':
        clickerNotifier.increaseDps(1);
        break;
      case 'critical_hit':
        clickerNotifier.increaseCritChance(5);
        break;
    }
  }

  Upgrade? getUpgrade(String id) {
    return state.upgrades.where((u) => u.id == id).firstOrNull;
  }
}
