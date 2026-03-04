import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../clicker/application/clicker_controller.dart';
import '../data/shop_repository.dart';
import '../domain/shop_item.dart';
import '../domain/shop_state.dart';
import '../domain/upgrade.dart';
import 'inventory_controller.dart';

part 'shop_controller.g.dart';

@Riverpod(keepAlive: true)
class ShopController extends _$ShopController {
  late Box<Map> _upgradeBox;

  @override
  ShopState build() {
    _upgradeBox = Hive.box<Map>('upgrade_levels');
    final repository = ref.read(shopRepositoryProvider);
    final savedLevels = _loadUpgradeLevels();

    // Apply saved levels to upgrades
    final upgrades = repository.getAvailableUpgrades().map((upgrade) {
      final savedLevel = savedLevels[upgrade.id] ?? 0;
      return upgrade.copyWith(level: savedLevel);
    }).toList();

    return ShopState(items: repository.getAvailableItems(), upgrades: upgrades);
  }

  Map<String, int> _loadUpgradeLevels() {
    final saved = _upgradeBox.get('levels');
    if (saved == null) return {};
    return Map<String, int>.from(saved);
  }

  void _saveUpgradeLevels() {
    final levels = <String, int>{};
    for (final upgrade in state.upgrades) {
      levels[upgrade.id] = upgrade.level;
    }
    _upgradeBox.put('levels', levels);
  }

  /// Restores shop upgrade levels from a cloud save snapshot.
  /// Only updates the persisted levels and displayed state – the actual clicker
  /// stats (clickPower, dps, critChance) are restored separately via ClickerController.
  void restoreFromCloud(Map<String, dynamic> shopData) {
    final levels = shopData.map((k, v) => MapEntry(k, (v as num).toInt()));
    _upgradeBox.put('levels', levels);

    final repository = ref.read(shopRepositoryProvider);
    final upgrades = repository.getAvailableUpgrades().map((upgrade) {
      final savedLevel = levels[upgrade.id] ?? 0;
      return upgrade.copyWith(level: savedLevel);
    }).toList();

    state = state.copyWith(upgrades: upgrades);
  }

  bool purchaseUpgrade(String upgradeId) {
    final clickerController = ref.read(clickerControllerProvider.notifier);
    final clickerState = ref.read(clickerControllerProvider);

    final upgradeIndex = state.upgrades.indexWhere((u) => u.id == upgradeId);
    if (upgradeIndex == -1) return false;

    final upgrade = state.upgrades[upgradeIndex];
    final cost = upgrade.currentCost;

    if (clickerState.currency >= cost) {
      // 1. Deduct currency
      clickerController.spendCurrency(cost);

      // 2. Apply effect to clicker
      _applyUpgradeEffect(upgrade);

      // 3. Increment upgrade level
      final updatedUpgrades = List<Upgrade>.from(state.upgrades);
      updatedUpgrades[upgradeIndex] = upgrade.copyWith(
        level: upgrade.level + 1,
      );
      state = state.copyWith(upgrades: updatedUpgrades);

      // 4. Persist upgrade levels
      _saveUpgradeLevels();

      return true;
    }
    return false;
  }

  void _applyUpgradeEffect(Upgrade upgrade) {
    final clickerController = ref.read(clickerControllerProvider.notifier);
    switch (upgrade.id) {
      case 'click_power':
        clickerController.increaseClickPower(upgrade.effectValue);
        break;
      case 'auto_clicker':
        clickerController.increaseDps(upgrade.effectValue);
        break;
      case 'critical_hit':
        clickerController.increaseCritChance(upgrade.effectValue);
        break;
    }
  }

  bool purchaseItem(ShopItem item) {
    final clickerController = ref.read(clickerControllerProvider.notifier);
    final clickerState = ref.read(clickerControllerProvider);
    final inventoryController = ref.read(inventoryControllerProvider.notifier);

    // 1. Check if user has enough currency
    if (clickerState.currency < item.price) {
      return false;
    }

    // 2. Check if user meets level requirement
    if (clickerState.level < item.minLevel) {
      return false;
    }

    // 3. Deduct currency
    clickerController.spendCurrency(item.price);

    // 4. Add to inventory
    inventoryController.addItem(item.id);

    return true;
  }
}
