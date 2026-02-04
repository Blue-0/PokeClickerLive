import 'package:freezed_annotation/freezed_annotation.dart';
import 'shop_item.dart';
import 'upgrade.dart';

part 'shop_state.freezed.dart';

@freezed
abstract class ShopState with _$ShopState {
  const factory ShopState({
    required List<Upgrade> upgrades,
    required List<ShopItem> items,
  }) = _ShopState;

  factory ShopState.initial() => const ShopState(items: [], upgrades: []);
}
