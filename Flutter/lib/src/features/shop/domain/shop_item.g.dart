// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShopItem _$ShopItemFromJson(Map<String, dynamic> json) => _ShopItem(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toInt(),
  spriteUrl: json['spriteUrl'] as String,
  minLevel: (json['minLevel'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$ShopItemToJson(_ShopItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'spriteUrl': instance.spriteUrl,
  'minLevel': instance.minLevel,
};
