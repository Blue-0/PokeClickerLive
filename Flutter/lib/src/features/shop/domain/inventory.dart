import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

@freezed
abstract class Inventory with _$Inventory {
  const factory Inventory({
    /// Map of item ID to quantity owned
    @Default({}) Map<String, int> items,
  }) = _Inventory;

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);
}
