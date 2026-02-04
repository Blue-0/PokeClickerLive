import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/shop/application/shop_controller.dart';
import 'package:pokeclickerlive/src/features/shop/application/inventory_controller.dart';
import 'package:pokeclickerlive/src/features/clicker/application/clicker_controller.dart';
import 'package:pokeclickerlive/src/features/shop/domain/shop_item.dart';
import 'package:pokeclickerlive/src/features/shop/domain/shop_state.dart';
import 'package:pokeclickerlive/src/features/shop/domain/inventory.dart';
import 'package:pokeclickerlive/src/features/shop/domain/upgrade.dart';
import 'package:pokeclickerlive/src/features/shop/domain/shop_constants.dart';
import 'package:pokeclickerlive/src/features/clicker/domain/clicker_state.dart';

// Fake implementations instead of Mocks to avoid Riverpod/Mocktail conflicts
class FakeClickerController extends ClickerController {
  final ClickerState initialState;
  int spendCalls = 0;
  int clickPowerCalls = 0;
  int dpsCalls = 0;
  int critCalls = 0;

  FakeClickerController({
    this.initialState = const ClickerState(currency: 500, level: 1),
  });

  @override
  ClickerState build() {
    return initialState;
  }

  @override
  void spendCurrency(int amount) {
    spendCalls++;
    state = state.copyWith(currency: state.currency - amount);
  }

  @override
  void increaseClickPower(int amount) {
    clickPowerCalls++;
    state = state.copyWith(clickPower: state.clickPower + amount);
  }

  @override
  void increaseDps(int amount) {
    dpsCalls++;
    state = state.copyWith(dps: state.dps + amount);
  }

  @override
  void increaseCritChance(int amount) {
    critCalls++;
    state = state.copyWith(critChance: state.critChance + amount);
  }
}

class FakeInventoryController extends InventoryController {
  final Inventory initialState;
  int addItemCalls = 0;

  FakeInventoryController({this.initialState = const Inventory()});

  @override
  Inventory build() {
    return initialState;
  }

  @override
  void addItem(String itemId, {int quantity = 1}) {
    addItemCalls++;
    final newItems = Map<String, int>.from(state.items);
    newItems[itemId] = (newItems[itemId] ?? 0) + quantity;
    state = state.copyWith(items: newItems);
  }
}

/// Fake ShopController without Hive dependency for testing
class FakeShopController extends ShopController {
  @override
  ShopState build() {
    // No Hive usage - direct in-memory state
    return ShopState(
      items: [
        const ShopItem(
          id: 'pokeball',
          name: 'Poké Ball',
          description: 'Test item',
          price: ShopConstants.pokeballPrice,
          spriteUrl: '',
        ),
      ],
      upgrades: [
        const Upgrade(
          id: 'click_power',
          name: 'Click Power',
          description: '+1 damage per click',
          icon: '⚔️',
          baseCost: ShopConstants.clickPowerBaseCost,
          costMultiplier: ShopConstants.clickPowerMultiplier,
          effectValue: ShopConstants.clickPowerEffect,
        ),
        const Upgrade(
          id: 'auto_clicker',
          name: 'Auto Clicker',
          description: '+1 DPS',
          icon: '🤖',
          baseCost: ShopConstants.autoClickerBaseCost,
          costMultiplier: ShopConstants.autoClickerMultiplier,
          effectValue: ShopConstants.autoClickerEffect,
        ),
        const Upgrade(
          id: 'critical_hit',
          name: 'Critical Hit',
          description: '+5% crit',
          icon: '💥',
          baseCost: ShopConstants.criticalHitBaseCost,
          costMultiplier: ShopConstants.criticalHitMultiplier,
          effectValue: ShopConstants.criticalHitEffect,
        ),
      ],
    );
  }

  @override
  bool purchaseUpgrade(String upgradeId) {
    final clickerController = ref.read(clickerControllerProvider.notifier);
    final clickerState = ref.read(clickerControllerProvider);

    final upgradeIndex = state.upgrades.indexWhere((u) => u.id == upgradeId);
    if (upgradeIndex == -1) return false;

    final upgrade = state.upgrades[upgradeIndex];
    final cost = upgrade.currentCost;

    if (clickerState.currency >= cost) {
      clickerController.spendCurrency(cost);
      _applyUpgradeEffect(upgrade);

      final updatedUpgrades = List<Upgrade>.from(state.upgrades);
      updatedUpgrades[upgradeIndex] = upgrade.copyWith(
        level: upgrade.level + 1,
      );
      state = state.copyWith(upgrades: updatedUpgrades);
      // No Hive save in test
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
}

void main() {
  group('ShopController', () {
    late FakeClickerController fakeClickerController;
    late FakeInventoryController fakeInventoryController;
    late ProviderContainer container;

    final testItem = const ShopItem(
      id: 'pokeball',
      name: 'Poké Ball',
      description: 'Test',
      price: 200,
      spriteUrl: '',
    );

    // Helper to setup container with specific initial states
    void setup({ClickerState? clickerState}) {
      fakeClickerController = FakeClickerController(
        initialState:
            clickerState ?? const ClickerState(currency: 500, level: 1),
      );
      fakeInventoryController = FakeInventoryController();

      container = ProviderContainer(
        overrides: [
          clickerControllerProvider.overrideWith(() => fakeClickerController),
          inventoryControllerProvider.overrideWith(
            () => fakeInventoryController,
          ),
          shopControllerProvider.overrideWith(() => FakeShopController()),
        ],
      );
    }

    tearDown(() {
      container.dispose();
    });

    group('purchaseItem', () {
      test('should succeed if enough currency', () {
        setup();
        final controller = container.read(shopControllerProvider.notifier);

        final result = controller.purchaseItem(testItem);

        expect(result, true);
        expect(fakeClickerController.state.currency, 300); // 500 - 200
        expect(fakeInventoryController.state.items['pokeball'], 1);
        expect(fakeClickerController.spendCalls, 1);
        expect(fakeInventoryController.addItemCalls, 1);
      });

      test('should fail if not enough currency', () {
        setup(clickerState: const ClickerState(currency: 100, level: 1));
        final controller = container.read(shopControllerProvider.notifier);

        final result = controller.purchaseItem(testItem);

        expect(result, false);
        expect(fakeClickerController.spendCalls, 0);
        expect(fakeInventoryController.addItemCalls, 0);
      });

      test('should fail if level too low', () {
        setup(clickerState: const ClickerState(currency: 500, level: 1));
        final highLevelItem = testItem.copyWith(minLevel: 10);
        final controller = container.read(shopControllerProvider.notifier);

        final result = controller.purchaseItem(highLevelItem);

        expect(result, false);
        expect(fakeClickerController.spendCalls, 0);
        expect(fakeInventoryController.addItemCalls, 0);
      });
    });

    group('purchaseUpgrade', () {
      test('should succeed if enough currency', () {
        setup(clickerState: const ClickerState(currency: 100, level: 1));
        final controller = container.read(shopControllerProvider.notifier);

        // Initial state has click_power upgrade with baseCost 10
        final result = controller.purchaseUpgrade('click_power');

        expect(result, true);
        expect(fakeClickerController.spendCalls, 1);
        expect(fakeClickerController.clickPowerCalls, 1);
        // Verify upgrade level increased
        final updatedUpgrade = container
            .read(shopControllerProvider)
            .upgrades
            .firstWhere((u) => u.id == 'click_power');
        expect(updatedUpgrade.level, 1);
      });

      test('should fail if not enough currency', () {
        setup(clickerState: const ClickerState(currency: 5, level: 1));
        final controller = container.read(shopControllerProvider.notifier);

        final result = controller.purchaseUpgrade('click_power');

        expect(result, false);
        expect(fakeClickerController.spendCalls, 0);
        expect(fakeClickerController.clickPowerCalls, 0);
      });

      test('should fail for non-existent upgrade', () {
        setup(clickerState: const ClickerState(currency: 1000, level: 1));
        final controller = container.read(shopControllerProvider.notifier);

        final result = controller.purchaseUpgrade('non_existent');

        expect(result, false);
        expect(fakeClickerController.spendCalls, 0);
      });

      test('should apply correct effect for auto_clicker', () {
        setup(clickerState: const ClickerState(currency: 100, level: 1));
        final controller = container.read(shopControllerProvider.notifier);

        final result = controller.purchaseUpgrade('auto_clicker');

        expect(result, true);
        expect(fakeClickerController.dpsCalls, 1);
      });

      test('should apply correct effect for critical_hit', () {
        setup(clickerState: const ClickerState(currency: 200, level: 1));
        final controller = container.read(shopControllerProvider.notifier);

        final result = controller.purchaseUpgrade('critical_hit');

        expect(result, true);
        expect(fakeClickerController.critCalls, 1);
      });

      test('cost should increase with level', () {
        setup(clickerState: const ClickerState(currency: 1000, level: 1));
        final controller = container.read(shopControllerProvider.notifier);

        // Buy first upgrade
        controller.purchaseUpgrade('click_power');
        final state1 = container.read(shopControllerProvider);
        final upgrade1 = state1.upgrades.firstWhere(
          (u) => u.id == 'click_power',
        );
        expect(upgrade1.level, 1);

        // Buy second upgrade - cost should be higher
        controller.purchaseUpgrade('click_power');
        final state2 = container.read(shopControllerProvider);
        final upgrade2 = state2.upgrades.firstWhere(
          (u) => u.id == 'click_power',
        );
        expect(upgrade2.level, 2);
        // Cost for level 2 should be baseCost * multiplier^2 = 10 * 1.5^2 = 22.5 rounded
        expect(upgrade2.currentCost, 23); // 10 * 1.5^2 = 22.5 rounded
      });
    });
  });
}
