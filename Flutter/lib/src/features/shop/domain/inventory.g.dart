// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Inventory _$InventoryFromJson(Map<String, dynamic> json) => _Inventory(
  items:
      (json['items'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
);

Map<String, dynamic> _$InventoryToJson(_Inventory instance) =>
    <String, dynamic>{'items': instance.items};
