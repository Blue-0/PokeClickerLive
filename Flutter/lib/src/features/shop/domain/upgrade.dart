import 'package:freezed_annotation/freezed_annotation.dart';

part 'upgrade.freezed.dart';

@freezed
abstract class Upgrade with _$Upgrade {
  const Upgrade._();

  const factory Upgrade({
    required String id,
    required String name,
    required String description,
    required String icon,
    @Default(0) int level,
    required int baseCost,
    @Default(1.5) double costMultiplier,
    @Default(1) int effectValue,
  }) = _Upgrade;

  /// Calculate current cost based on level
  int get currentCost => (baseCost * (costMultiplier.pow(level))).round();

  /// Calculate next level effect
  int get nextEffect => effectValue * (level + 1);
}

extension DoublePow on double {
  double pow(int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= this;
    }
    return result;
  }
}
