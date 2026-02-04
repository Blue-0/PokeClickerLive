import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/shop_item.dart';
import '../domain/upgrade.dart';
import '../domain/shop_constants.dart';

part 'shop_repository.g.dart';

@Riverpod(keepAlive: true)
ShopRepository shopRepository(Ref ref) {
  return ShopRepository();
}

class ShopRepository {
  List<ShopItem> getAvailableItems() {
    return [
      const ShopItem(
        id: 'pokeball',
        name: 'Poké Ball',
        description: 'A device for catching wild Pokémon.',
        price: ShopConstants.pokeballPrice,
        spriteUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
      ),
      const ShopItem(
        id: 'potion',
        name: 'Potion',
        description: 'Restores 20 HP to a Pokémon.',
        price: ShopConstants.potionPrice,
        spriteUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/potion.png',
      ),
      const ShopItem(
        id: 'great-ball',
        name: 'Great Ball',
        description: 'An improved Poké Ball with a higher success rate.',
        price: ShopConstants.greatBallPrice,
        spriteUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/great-ball.png',
        minLevel: ShopConstants.greatBallMinLevel,
      ),
    ];
  }

  List<Upgrade> getAvailableUpgrades() {
    return [
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
        description: '+1 DPS (damage per second)',
        icon: '🤖',
        baseCost: ShopConstants.autoClickerBaseCost,
        costMultiplier: ShopConstants.autoClickerMultiplier,
        effectValue: ShopConstants.autoClickerEffect,
      ),
      const Upgrade(
        id: 'critical_hit',
        name: 'Critical Hit',
        description: '+5% critical chance',
        icon: '💥',
        baseCost: ShopConstants.criticalHitBaseCost,
        costMultiplier: ShopConstants.criticalHitMultiplier,
        effectValue: ShopConstants.criticalHitEffect,
      ),
    ];
  }
}
