// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prestige_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrestigeData {

 int get prestigeLevel; int get badgesAmount;
/// Create a copy of PrestigeData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrestigeDataCopyWith<PrestigeData> get copyWith => _$PrestigeDataCopyWithImpl<PrestigeData>(this as PrestigeData, _$identity);

  /// Serializes this PrestigeData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrestigeData&&(identical(other.prestigeLevel, prestigeLevel) || other.prestigeLevel == prestigeLevel)&&(identical(other.badgesAmount, badgesAmount) || other.badgesAmount == badgesAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prestigeLevel,badgesAmount);

@override
String toString() {
  return 'PrestigeData(prestigeLevel: $prestigeLevel, badgesAmount: $badgesAmount)';
}


}

/// @nodoc
abstract mixin class $PrestigeDataCopyWith<$Res>  {
  factory $PrestigeDataCopyWith(PrestigeData value, $Res Function(PrestigeData) _then) = _$PrestigeDataCopyWithImpl;
@useResult
$Res call({
 int prestigeLevel, int badgesAmount
});




}
/// @nodoc
class _$PrestigeDataCopyWithImpl<$Res>
    implements $PrestigeDataCopyWith<$Res> {
  _$PrestigeDataCopyWithImpl(this._self, this._then);

  final PrestigeData _self;
  final $Res Function(PrestigeData) _then;

/// Create a copy of PrestigeData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prestigeLevel = null,Object? badgesAmount = null,}) {
  return _then(_self.copyWith(
prestigeLevel: null == prestigeLevel ? _self.prestigeLevel : prestigeLevel // ignore: cast_nullable_to_non_nullable
as int,badgesAmount: null == badgesAmount ? _self.badgesAmount : badgesAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrestigeData].
extension PrestigeDataPatterns on PrestigeData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrestigeData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrestigeData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrestigeData value)  $default,){
final _that = this;
switch (_that) {
case _PrestigeData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrestigeData value)?  $default,){
final _that = this;
switch (_that) {
case _PrestigeData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int prestigeLevel,  int badgesAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrestigeData() when $default != null:
return $default(_that.prestigeLevel,_that.badgesAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int prestigeLevel,  int badgesAmount)  $default,) {final _that = this;
switch (_that) {
case _PrestigeData():
return $default(_that.prestigeLevel,_that.badgesAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int prestigeLevel,  int badgesAmount)?  $default,) {final _that = this;
switch (_that) {
case _PrestigeData() when $default != null:
return $default(_that.prestigeLevel,_that.badgesAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrestigeData extends PrestigeData {
  const _PrestigeData({this.prestigeLevel = 0, this.badgesAmount = 0}): super._();
  factory _PrestigeData.fromJson(Map<String, dynamic> json) => _$PrestigeDataFromJson(json);

@override@JsonKey() final  int prestigeLevel;
@override@JsonKey() final  int badgesAmount;

/// Create a copy of PrestigeData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrestigeDataCopyWith<_PrestigeData> get copyWith => __$PrestigeDataCopyWithImpl<_PrestigeData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrestigeDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrestigeData&&(identical(other.prestigeLevel, prestigeLevel) || other.prestigeLevel == prestigeLevel)&&(identical(other.badgesAmount, badgesAmount) || other.badgesAmount == badgesAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prestigeLevel,badgesAmount);

@override
String toString() {
  return 'PrestigeData(prestigeLevel: $prestigeLevel, badgesAmount: $badgesAmount)';
}


}

/// @nodoc
abstract mixin class _$PrestigeDataCopyWith<$Res> implements $PrestigeDataCopyWith<$Res> {
  factory _$PrestigeDataCopyWith(_PrestigeData value, $Res Function(_PrestigeData) _then) = __$PrestigeDataCopyWithImpl;
@override @useResult
$Res call({
 int prestigeLevel, int badgesAmount
});




}
/// @nodoc
class __$PrestigeDataCopyWithImpl<$Res>
    implements _$PrestigeDataCopyWith<$Res> {
  __$PrestigeDataCopyWithImpl(this._self, this._then);

  final _PrestigeData _self;
  final $Res Function(_PrestigeData) _then;

/// Create a copy of PrestigeData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prestigeLevel = null,Object? badgesAmount = null,}) {
  return _then(_PrestigeData(
prestigeLevel: null == prestigeLevel ? _self.prestigeLevel : prestigeLevel // ignore: cast_nullable_to_non_nullable
as int,badgesAmount: null == badgesAmount ? _self.badgesAmount : badgesAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
