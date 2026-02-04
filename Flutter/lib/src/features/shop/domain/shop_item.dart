import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_item.freezed.dart';
part 'shop_item.g.dart';

@freezed
abstract class ShopItem with _$ShopItem {
  const factory ShopItem({
    required String id,
    required String name,
    required String description,
    required int price,
    required String spriteUrl,
    @Default(1) int minLevel,
  }) = _ShopItem;

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);
}
