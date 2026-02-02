// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unlock_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnlockCondition {

/// Number of Pokémon defeats required in the source zone
 int get killCount;/// The zone where kills must be made to unlock this zone
 String get sourceZoneId;
/// Create a copy of UnlockCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnlockConditionCopyWith<UnlockCondition> get copyWith => _$UnlockConditionCopyWithImpl<UnlockCondition>(this as UnlockCondition, _$identity);

  /// Serializes this UnlockCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnlockCondition&&(identical(other.killCount, killCount) || other.killCount == killCount)&&(identical(other.sourceZoneId, sourceZoneId) || other.sourceZoneId == sourceZoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,killCount,sourceZoneId);

@override
String toString() {
  return 'UnlockCondition(killCount: $killCount, sourceZoneId: $sourceZoneId)';
}


}

/// @nodoc
abstract mixin class $UnlockConditionCopyWith<$Res>  {
  factory $UnlockConditionCopyWith(UnlockCondition value, $Res Function(UnlockCondition) _then) = _$UnlockConditionCopyWithImpl;
@useResult
$Res call({
 int killCount, String sourceZoneId
});




}
/// @nodoc
class _$UnlockConditionCopyWithImpl<$Res>
    implements $UnlockConditionCopyWith<$Res> {
  _$UnlockConditionCopyWithImpl(this._self, this._then);

  final UnlockCondition _self;
  final $Res Function(UnlockCondition) _then;

/// Create a copy of UnlockCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? killCount = null,Object? sourceZoneId = null,}) {
  return _then(_self.copyWith(
killCount: null == killCount ? _self.killCount : killCount // ignore: cast_nullable_to_non_nullable
as int,sourceZoneId: null == sourceZoneId ? _self.sourceZoneId : sourceZoneId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnlockCondition].
extension UnlockConditionPatterns on UnlockCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnlockCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnlockCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnlockCondition value)  $default,){
final _that = this;
switch (_that) {
case _UnlockCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnlockCondition value)?  $default,){
final _that = this;
switch (_that) {
case _UnlockCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int killCount,  String sourceZoneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnlockCondition() when $default != null:
return $default(_that.killCount,_that.sourceZoneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int killCount,  String sourceZoneId)  $default,) {final _that = this;
switch (_that) {
case _UnlockCondition():
return $default(_that.killCount,_that.sourceZoneId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int killCount,  String sourceZoneId)?  $default,) {final _that = this;
switch (_that) {
case _UnlockCondition() when $default != null:
return $default(_that.killCount,_that.sourceZoneId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnlockCondition implements UnlockCondition {
  const _UnlockCondition({required this.killCount, required this.sourceZoneId});
  factory _UnlockCondition.fromJson(Map<String, dynamic> json) => _$UnlockConditionFromJson(json);

/// Number of Pokémon defeats required in the source zone
@override final  int killCount;
/// The zone where kills must be made to unlock this zone
@override final  String sourceZoneId;

/// Create a copy of UnlockCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnlockConditionCopyWith<_UnlockCondition> get copyWith => __$UnlockConditionCopyWithImpl<_UnlockCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnlockConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnlockCondition&&(identical(other.killCount, killCount) || other.killCount == killCount)&&(identical(other.sourceZoneId, sourceZoneId) || other.sourceZoneId == sourceZoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,killCount,sourceZoneId);

@override
String toString() {
  return 'UnlockCondition(killCount: $killCount, sourceZoneId: $sourceZoneId)';
}


}

/// @nodoc
abstract mixin class _$UnlockConditionCopyWith<$Res> implements $UnlockConditionCopyWith<$Res> {
  factory _$UnlockConditionCopyWith(_UnlockCondition value, $Res Function(_UnlockCondition) _then) = __$UnlockConditionCopyWithImpl;
@override @useResult
$Res call({
 int killCount, String sourceZoneId
});




}
/// @nodoc
class __$UnlockConditionCopyWithImpl<$Res>
    implements _$UnlockConditionCopyWith<$Res> {
  __$UnlockConditionCopyWithImpl(this._self, this._then);

  final _UnlockCondition _self;
  final $Res Function(_UnlockCondition) _then;

/// Create a copy of UnlockCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? killCount = null,Object? sourceZoneId = null,}) {
  return _then(_UnlockCondition(
killCount: null == killCount ? _self.killCount : killCount // ignore: cast_nullable_to_non_nullable
as int,sourceZoneId: null == sourceZoneId ? _self.sourceZoneId : sourceZoneId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
