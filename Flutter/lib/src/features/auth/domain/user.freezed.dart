// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 dynamic get id;// API returns int, we'll convert to String
 String get username; String get email; int get pokedollars;@JsonKey(name: 'lifetime_earnings') int get lifetimeEarnings;@JsonKey(name: 'total_clicks') int get totalClicks; double? get latitude; double? get longitude;@JsonKey(name: 'contact_person') String? get contactPerson;@JsonKey(name: 'profile_photo') String? get profilePhoto;@JsonKey(name: 'last_sync') String? get lastSync;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&const DeepCollectionEquality().equals(other.id, id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.pokedollars, pokedollars) || other.pokedollars == pokedollars)&&(identical(other.lifetimeEarnings, lifetimeEarnings) || other.lifetimeEarnings == lifetimeEarnings)&&(identical(other.totalClicks, totalClicks) || other.totalClicks == totalClicks)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.profilePhoto, profilePhoto) || other.profilePhoto == profilePhoto)&&(identical(other.lastSync, lastSync) || other.lastSync == lastSync)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(id),username,email,pokedollars,lifetimeEarnings,totalClicks,latitude,longitude,contactPerson,profilePhoto,lastSync,createdAt);

@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, pokedollars: $pokedollars, lifetimeEarnings: $lifetimeEarnings, totalClicks: $totalClicks, latitude: $latitude, longitude: $longitude, contactPerson: $contactPerson, profilePhoto: $profilePhoto, lastSync: $lastSync, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 dynamic id, String username, String email, int pokedollars,@JsonKey(name: 'lifetime_earnings') int lifetimeEarnings,@JsonKey(name: 'total_clicks') int totalClicks, double? latitude, double? longitude,@JsonKey(name: 'contact_person') String? contactPerson,@JsonKey(name: 'profile_photo') String? profilePhoto,@JsonKey(name: 'last_sync') String? lastSync,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? username = null,Object? email = null,Object? pokedollars = null,Object? lifetimeEarnings = null,Object? totalClicks = null,Object? latitude = freezed,Object? longitude = freezed,Object? contactPerson = freezed,Object? profilePhoto = freezed,Object? lastSync = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as dynamic,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,pokedollars: null == pokedollars ? _self.pokedollars : pokedollars // ignore: cast_nullable_to_non_nullable
as int,lifetimeEarnings: null == lifetimeEarnings ? _self.lifetimeEarnings : lifetimeEarnings // ignore: cast_nullable_to_non_nullable
as int,totalClicks: null == totalClicks ? _self.totalClicks : totalClicks // ignore: cast_nullable_to_non_nullable
as int,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,profilePhoto: freezed == profilePhoto ? _self.profilePhoto : profilePhoto // ignore: cast_nullable_to_non_nullable
as String?,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( dynamic id,  String username,  String email,  int pokedollars, @JsonKey(name: 'lifetime_earnings')  int lifetimeEarnings, @JsonKey(name: 'total_clicks')  int totalClicks,  double? latitude,  double? longitude, @JsonKey(name: 'contact_person')  String? contactPerson, @JsonKey(name: 'profile_photo')  String? profilePhoto, @JsonKey(name: 'last_sync')  String? lastSync, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.pokedollars,_that.lifetimeEarnings,_that.totalClicks,_that.latitude,_that.longitude,_that.contactPerson,_that.profilePhoto,_that.lastSync,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( dynamic id,  String username,  String email,  int pokedollars, @JsonKey(name: 'lifetime_earnings')  int lifetimeEarnings, @JsonKey(name: 'total_clicks')  int totalClicks,  double? latitude,  double? longitude, @JsonKey(name: 'contact_person')  String? contactPerson, @JsonKey(name: 'profile_photo')  String? profilePhoto, @JsonKey(name: 'last_sync')  String? lastSync, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.username,_that.email,_that.pokedollars,_that.lifetimeEarnings,_that.totalClicks,_that.latitude,_that.longitude,_that.contactPerson,_that.profilePhoto,_that.lastSync,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( dynamic id,  String username,  String email,  int pokedollars, @JsonKey(name: 'lifetime_earnings')  int lifetimeEarnings, @JsonKey(name: 'total_clicks')  int totalClicks,  double? latitude,  double? longitude, @JsonKey(name: 'contact_person')  String? contactPerson, @JsonKey(name: 'profile_photo')  String? profilePhoto, @JsonKey(name: 'last_sync')  String? lastSync, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.pokedollars,_that.lifetimeEarnings,_that.totalClicks,_that.latitude,_that.longitude,_that.contactPerson,_that.profilePhoto,_that.lastSync,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({required this.id, required this.username, required this.email, this.pokedollars = 0, @JsonKey(name: 'lifetime_earnings') this.lifetimeEarnings = 0, @JsonKey(name: 'total_clicks') this.totalClicks = 0, this.latitude, this.longitude, @JsonKey(name: 'contact_person') this.contactPerson, @JsonKey(name: 'profile_photo') this.profilePhoto, @JsonKey(name: 'last_sync') this.lastSync, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  dynamic id;
// API returns int, we'll convert to String
@override final  String username;
@override final  String email;
@override@JsonKey() final  int pokedollars;
@override@JsonKey(name: 'lifetime_earnings') final  int lifetimeEarnings;
@override@JsonKey(name: 'total_clicks') final  int totalClicks;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey(name: 'contact_person') final  String? contactPerson;
@override@JsonKey(name: 'profile_photo') final  String? profilePhoto;
@override@JsonKey(name: 'last_sync') final  String? lastSync;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&const DeepCollectionEquality().equals(other.id, id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.pokedollars, pokedollars) || other.pokedollars == pokedollars)&&(identical(other.lifetimeEarnings, lifetimeEarnings) || other.lifetimeEarnings == lifetimeEarnings)&&(identical(other.totalClicks, totalClicks) || other.totalClicks == totalClicks)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.profilePhoto, profilePhoto) || other.profilePhoto == profilePhoto)&&(identical(other.lastSync, lastSync) || other.lastSync == lastSync)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(id),username,email,pokedollars,lifetimeEarnings,totalClicks,latitude,longitude,contactPerson,profilePhoto,lastSync,createdAt);

@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, pokedollars: $pokedollars, lifetimeEarnings: $lifetimeEarnings, totalClicks: $totalClicks, latitude: $latitude, longitude: $longitude, contactPerson: $contactPerson, profilePhoto: $profilePhoto, lastSync: $lastSync, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 dynamic id, String username, String email, int pokedollars,@JsonKey(name: 'lifetime_earnings') int lifetimeEarnings,@JsonKey(name: 'total_clicks') int totalClicks, double? latitude, double? longitude,@JsonKey(name: 'contact_person') String? contactPerson,@JsonKey(name: 'profile_photo') String? profilePhoto,@JsonKey(name: 'last_sync') String? lastSync,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? username = null,Object? email = null,Object? pokedollars = null,Object? lifetimeEarnings = null,Object? totalClicks = null,Object? latitude = freezed,Object? longitude = freezed,Object? contactPerson = freezed,Object? profilePhoto = freezed,Object? lastSync = freezed,Object? createdAt = freezed,}) {
  return _then(_User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as dynamic,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,pokedollars: null == pokedollars ? _self.pokedollars : pokedollars // ignore: cast_nullable_to_non_nullable
as int,lifetimeEarnings: null == lifetimeEarnings ? _self.lifetimeEarnings : lifetimeEarnings // ignore: cast_nullable_to_non_nullable
as int,totalClicks: null == totalClicks ? _self.totalClicks : totalClicks // ignore: cast_nullable_to_non_nullable
as int,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,profilePhoto: freezed == profilePhoto ? _self.profilePhoto : profilePhoto // ignore: cast_nullable_to_non_nullable
as String?,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
