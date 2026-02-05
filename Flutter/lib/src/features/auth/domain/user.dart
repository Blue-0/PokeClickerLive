import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required dynamic id, // API returns int, we'll convert to String
    required String username,
    required String email,
    @Default(0) int pokedollars,
    @JsonKey(name: 'lifetime_earnings') @Default(0) int lifetimeEarnings,
    @JsonKey(name: 'total_clicks') @Default(0) int totalClicks,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'contact_person') String? contactPerson,
    @JsonKey(name: 'profile_photo') String? profilePhoto,
    @JsonKey(name: 'last_sync') String? lastSync,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _User;

  const User._();

  /// Get id as String
  String get idString => id.toString();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
