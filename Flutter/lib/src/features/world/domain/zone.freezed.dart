// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Zone {

/// Unique identifier for the zone (e.g., 'route-201')
 String get id;/// Display name (e.g., 'Route 201')
 String get name;/// Type of zone (route, town, dungeon)
 ZoneType get type;/// Whether the zone is currently unlocked for the player
 bool get isUnlocked;/// Condition to unlock this zone (null if always unlocked)
 UnlockCondition? get unlockCondition;/// IDs of Pokémon that can spawn in this zone
 List<int> get pokemonIds;/// ID of the Boss Pokémon for this zone (null if no boss)
 int? get bossPokemonId;/// Duration of the boss timer in seconds (null if using default)
 int? get bossTimerSeconds;
/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneCopyWith<Zone> get copyWith => _$ZoneCopyWithImpl<Zone>(this as Zone, _$identity);

  /// Serializes this Zone to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Zone&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isUnlocked, isUnlocked) || other.isUnlocked == isUnlocked)&&(identical(other.unlockCondition, unlockCondition) || other.unlockCondition == unlockCondition)&&const DeepCollectionEquality().equals(other.pokemonIds, pokemonIds)&&(identical(other.bossPokemonId, bossPokemonId) || other.bossPokemonId == bossPokemonId)&&(identical(other.bossTimerSeconds, bossTimerSeconds) || other.bossTimerSeconds == bossTimerSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isUnlocked,unlockCondition,const DeepCollectionEquality().hash(pokemonIds),bossPokemonId,bossTimerSeconds);

@override
String toString() {
  return 'Zone(id: $id, name: $name, type: $type, isUnlocked: $isUnlocked, unlockCondition: $unlockCondition, pokemonIds: $pokemonIds, bossPokemonId: $bossPokemonId, bossTimerSeconds: $bossTimerSeconds)';
}


}

/// @nodoc
abstract mixin class $ZoneCopyWith<$Res>  {
  factory $ZoneCopyWith(Zone value, $Res Function(Zone) _then) = _$ZoneCopyWithImpl;
@useResult
$Res call({
 String id, String name, ZoneType type, bool isUnlocked, UnlockCondition? unlockCondition, List<int> pokemonIds, int? bossPokemonId, int? bossTimerSeconds
});


$UnlockConditionCopyWith<$Res>? get unlockCondition;

}
/// @nodoc
class _$ZoneCopyWithImpl<$Res>
    implements $ZoneCopyWith<$Res> {
  _$ZoneCopyWithImpl(this._self, this._then);

  final Zone _self;
  final $Res Function(Zone) _then;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isUnlocked = null,Object? unlockCondition = freezed,Object? pokemonIds = null,Object? bossPokemonId = freezed,Object? bossTimerSeconds = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ZoneType,isUnlocked: null == isUnlocked ? _self.isUnlocked : isUnlocked // ignore: cast_nullable_to_non_nullable
as bool,unlockCondition: freezed == unlockCondition ? _self.unlockCondition : unlockCondition // ignore: cast_nullable_to_non_nullable
as UnlockCondition?,pokemonIds: null == pokemonIds ? _self.pokemonIds : pokemonIds // ignore: cast_nullable_to_non_nullable
as List<int>,bossPokemonId: freezed == bossPokemonId ? _self.bossPokemonId : bossPokemonId // ignore: cast_nullable_to_non_nullable
as int?,bossTimerSeconds: freezed == bossTimerSeconds ? _self.bossTimerSeconds : bossTimerSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnlockConditionCopyWith<$Res>? get unlockCondition {
    if (_self.unlockCondition == null) {
    return null;
  }

  return $UnlockConditionCopyWith<$Res>(_self.unlockCondition!, (value) {
    return _then(_self.copyWith(unlockCondition: value));
  });
}
}


/// Adds pattern-matching-related methods to [Zone].
extension ZonePatterns on Zone {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Zone value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Zone() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Zone value)  $default,){
final _that = this;
switch (_that) {
case _Zone():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Zone value)?  $default,){
final _that = this;
switch (_that) {
case _Zone() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ZoneType type,  bool isUnlocked,  UnlockCondition? unlockCondition,  List<int> pokemonIds,  int? bossPokemonId,  int? bossTimerSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Zone() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isUnlocked,_that.unlockCondition,_that.pokemonIds,_that.bossPokemonId,_that.bossTimerSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ZoneType type,  bool isUnlocked,  UnlockCondition? unlockCondition,  List<int> pokemonIds,  int? bossPokemonId,  int? bossTimerSeconds)  $default,) {final _that = this;
switch (_that) {
case _Zone():
return $default(_that.id,_that.name,_that.type,_that.isUnlocked,_that.unlockCondition,_that.pokemonIds,_that.bossPokemonId,_that.bossTimerSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ZoneType type,  bool isUnlocked,  UnlockCondition? unlockCondition,  List<int> pokemonIds,  int? bossPokemonId,  int? bossTimerSeconds)?  $default,) {final _that = this;
switch (_that) {
case _Zone() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isUnlocked,_that.unlockCondition,_that.pokemonIds,_that.bossPokemonId,_that.bossTimerSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Zone implements Zone {
  const _Zone({required this.id, required this.name, required this.type, this.isUnlocked = false, this.unlockCondition, final  List<int> pokemonIds = const [], this.bossPokemonId, this.bossTimerSeconds}): _pokemonIds = pokemonIds;
  factory _Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);

/// Unique identifier for the zone (e.g., 'route-201')
@override final  String id;
/// Display name (e.g., 'Route 201')
@override final  String name;
/// Type of zone (route, town, dungeon)
@override final  ZoneType type;
/// Whether the zone is currently unlocked for the player
@override@JsonKey() final  bool isUnlocked;
/// Condition to unlock this zone (null if always unlocked)
@override final  UnlockCondition? unlockCondition;
/// IDs of Pokémon that can spawn in this zone
 final  List<int> _pokemonIds;
/// IDs of Pokémon that can spawn in this zone
@override@JsonKey() List<int> get pokemonIds {
  if (_pokemonIds is EqualUnmodifiableListView) return _pokemonIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pokemonIds);
}

/// ID of the Boss Pokémon for this zone (null if no boss)
@override final  int? bossPokemonId;
/// Duration of the boss timer in seconds (null if using default)
@override final  int? bossTimerSeconds;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoneCopyWith<_Zone> get copyWith => __$ZoneCopyWithImpl<_Zone>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZoneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Zone&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isUnlocked, isUnlocked) || other.isUnlocked == isUnlocked)&&(identical(other.unlockCondition, unlockCondition) || other.unlockCondition == unlockCondition)&&const DeepCollectionEquality().equals(other._pokemonIds, _pokemonIds)&&(identical(other.bossPokemonId, bossPokemonId) || other.bossPokemonId == bossPokemonId)&&(identical(other.bossTimerSeconds, bossTimerSeconds) || other.bossTimerSeconds == bossTimerSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isUnlocked,unlockCondition,const DeepCollectionEquality().hash(_pokemonIds),bossPokemonId,bossTimerSeconds);

@override
String toString() {
  return 'Zone(id: $id, name: $name, type: $type, isUnlocked: $isUnlocked, unlockCondition: $unlockCondition, pokemonIds: $pokemonIds, bossPokemonId: $bossPokemonId, bossTimerSeconds: $bossTimerSeconds)';
}


}

/// @nodoc
abstract mixin class _$ZoneCopyWith<$Res> implements $ZoneCopyWith<$Res> {
  factory _$ZoneCopyWith(_Zone value, $Res Function(_Zone) _then) = __$ZoneCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ZoneType type, bool isUnlocked, UnlockCondition? unlockCondition, List<int> pokemonIds, int? bossPokemonId, int? bossTimerSeconds
});


@override $UnlockConditionCopyWith<$Res>? get unlockCondition;

}
/// @nodoc
class __$ZoneCopyWithImpl<$Res>
    implements _$ZoneCopyWith<$Res> {
  __$ZoneCopyWithImpl(this._self, this._then);

  final _Zone _self;
  final $Res Function(_Zone) _then;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isUnlocked = null,Object? unlockCondition = freezed,Object? pokemonIds = null,Object? bossPokemonId = freezed,Object? bossTimerSeconds = freezed,}) {
  return _then(_Zone(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ZoneType,isUnlocked: null == isUnlocked ? _self.isUnlocked : isUnlocked // ignore: cast_nullable_to_non_nullable
as bool,unlockCondition: freezed == unlockCondition ? _self.unlockCondition : unlockCondition // ignore: cast_nullable_to_non_nullable
as UnlockCondition?,pokemonIds: null == pokemonIds ? _self._pokemonIds : pokemonIds // ignore: cast_nullable_to_non_nullable
as List<int>,bossPokemonId: freezed == bossPokemonId ? _self.bossPokemonId : bossPokemonId // ignore: cast_nullable_to_non_nullable
as int?,bossTimerSeconds: freezed == bossTimerSeconds ? _self.bossTimerSeconds : bossTimerSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnlockConditionCopyWith<$Res>? get unlockCondition {
    if (_self.unlockCondition == null) {
    return null;
  }

  return $UnlockConditionCopyWith<$Res>(_self.unlockCondition!, (value) {
    return _then(_self.copyWith(unlockCondition: value));
  });
}
}

// dart format on
