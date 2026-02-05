// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'],
  username: json['username'] as String,
  email: json['email'] as String,
  pokedollars: (json['pokedollars'] as num?)?.toInt() ?? 0,
  lifetimeEarnings: (json['lifetime_earnings'] as num?)?.toInt() ?? 0,
  totalClicks: (json['total_clicks'] as num?)?.toInt() ?? 0,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  contactPerson: json['contact_person'] as String?,
  profilePhoto: json['profile_photo'] as String?,
  lastSync: json['last_sync'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'pokedollars': instance.pokedollars,
  'lifetime_earnings': instance.lifetimeEarnings,
  'total_clicks': instance.totalClicks,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'contact_person': instance.contactPerson,
  'profile_photo': instance.profilePhoto,
  'last_sync': instance.lastSync,
  'created_at': instance.createdAt,
};
