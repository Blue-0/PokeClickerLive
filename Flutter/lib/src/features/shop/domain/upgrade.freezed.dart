// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upgrade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Upgrade {

 String get id; String get name; String get description; String get icon; int get level; int get baseCost; double get costMultiplier; int get effectValue;
/// Create a copy of Upgrade
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpgradeCopyWith<Upgrade> get copyWith => _$UpgradeCopyWithImpl<Upgrade>(this as Upgrade, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Upgrade&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.level, level) || other.level == level)&&(identical(other.baseCost, baseCost) || other.baseCost == baseCost)&&(identical(other.costMultiplier, costMultiplier) || other.costMultiplier == costMultiplier)&&(identical(other.effectValue, effectValue) || other.effectValue == effectValue));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,level,baseCost,costMultiplier,effectValue);

@override
String toString() {
  return 'Upgrade(id: $id, name: $name, description: $description, icon: $icon, level: $level, baseCost: $baseCost, costMultiplier: $costMultiplier, effectValue: $effectValue)';
}


}

/// @nodoc
abstract mixin class $UpgradeCopyWith<$Res>  {
  factory $UpgradeCopyWith(Upgrade value, $Res Function(Upgrade) _then) = _$UpgradeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String icon, int level, int baseCost, double costMultiplier, int effectValue
});




}
/// @nodoc
class _$UpgradeCopyWithImpl<$Res>
    implements $UpgradeCopyWith<$Res> {
  _$UpgradeCopyWithImpl(this._self, this._then);

  final Upgrade _self;
  final $Res Function(Upgrade) _then;

/// Create a copy of Upgrade
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? icon = null,Object? level = null,Object? baseCost = null,Object? costMultiplier = null,Object? effectValue = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,baseCost: null == baseCost ? _self.baseCost : baseCost // ignore: cast_nullable_to_non_nullable
as int,costMultiplier: null == costMultiplier ? _self.costMultiplier : costMultiplier // ignore: cast_nullable_to_non_nullable
as double,effectValue: null == effectValue ? _self.effectValue : effectValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Upgrade].
extension UpgradePatterns on Upgrade {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Upgrade value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Upgrade() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Upgrade value)  $default,){
final _that = this;
switch (_that) {
case _Upgrade():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Upgrade value)?  $default,){
final _that = this;
switch (_that) {
case _Upgrade() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String icon,  int level,  int baseCost,  double costMultiplier,  int effectValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Upgrade() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.level,_that.baseCost,_that.costMultiplier,_that.effectValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String icon,  int level,  int baseCost,  double costMultiplier,  int effectValue)  $default,) {final _that = this;
switch (_that) {
case _Upgrade():
return $default(_that.id,_that.name,_that.description,_that.icon,_that.level,_that.baseCost,_that.costMultiplier,_that.effectValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String icon,  int level,  int baseCost,  double costMultiplier,  int effectValue)?  $default,) {final _that = this;
switch (_that) {
case _Upgrade() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.level,_that.baseCost,_that.costMultiplier,_that.effectValue);case _:
  return null;

}
}

}

/// @nodoc


class _Upgrade extends Upgrade {
  const _Upgrade({required this.id, required this.name, required this.description, required this.icon, this.level = 0, required this.baseCost, this.costMultiplier = 1.5, this.effectValue = 1}): super._();
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String icon;
@override@JsonKey() final  int level;
@override final  int baseCost;
@override@JsonKey() final  double costMultiplier;
@override@JsonKey() final  int effectValue;

/// Create a copy of Upgrade
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpgradeCopyWith<_Upgrade> get copyWith => __$UpgradeCopyWithImpl<_Upgrade>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Upgrade&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.level, level) || other.level == level)&&(identical(other.baseCost, baseCost) || other.baseCost == baseCost)&&(identical(other.costMultiplier, costMultiplier) || other.costMultiplier == costMultiplier)&&(identical(other.effectValue, effectValue) || other.effectValue == effectValue));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,level,baseCost,costMultiplier,effectValue);

@override
String toString() {
  return 'Upgrade(id: $id, name: $name, description: $description, icon: $icon, level: $level, baseCost: $baseCost, costMultiplier: $costMultiplier, effectValue: $effectValue)';
}


}

/// @nodoc
abstract mixin class _$UpgradeCopyWith<$Res> implements $UpgradeCopyWith<$Res> {
  factory _$UpgradeCopyWith(_Upgrade value, $Res Function(_Upgrade) _then) = __$UpgradeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String icon, int level, int baseCost, double costMultiplier, int effectValue
});




}
/// @nodoc
class __$UpgradeCopyWithImpl<$Res>
    implements _$UpgradeCopyWith<$Res> {
  __$UpgradeCopyWithImpl(this._self, this._then);

  final _Upgrade _self;
  final $Res Function(_Upgrade) _then;

/// Create a copy of Upgrade
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? icon = null,Object? level = null,Object? baseCost = null,Object? costMultiplier = null,Object? effectValue = null,}) {
  return _then(_Upgrade(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,baseCost: null == baseCost ? _self.baseCost : baseCost // ignore: cast_nullable_to_non_nullable
as int,costMultiplier: null == costMultiplier ? _self.costMultiplier : costMultiplier // ignore: cast_nullable_to_non_nullable
as double,effectValue: null == effectValue ? _self.effectValue : effectValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
