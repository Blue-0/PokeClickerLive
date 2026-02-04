/// Gameplay constants extracted per project-context.md guidelines
/// All prices, costs, and multipliers should be defined here
class ShopConstants {
  ShopConstants._();

  // Item Prices (in PokéDollars)
  static const int pokeballPrice = 200;
  static const int potionPrice = 300;
  static const int greatBallPrice = 600;

  // Upgrade Base Costs
  static const int clickPowerBaseCost = 10;
  static const int autoClickerBaseCost = 50;
  static const int criticalHitBaseCost = 100;

  // Upgrade Cost Multipliers
  static const double clickPowerMultiplier = 1.5;
  static const double autoClickerMultiplier = 1.8;
  static const double criticalHitMultiplier = 2.0;

  // Upgrade Effect Values
  static const int clickPowerEffect = 1;
  static const int autoClickerEffect = 1;
  static const int criticalHitEffect = 5;

  // Level Requirements
  static const int greatBallMinLevel = 10;
}
