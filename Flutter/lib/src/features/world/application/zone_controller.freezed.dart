// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ZoneState {

/// All available zones in the game
 List<Zone> get allZones;/// Currently active zone (where player is farming)
 Zone get currentZone;/// Kill count per zone (for unlock tracking)
 Map<String, int> get killCounts;/// Newly unlocked zone names (for notifications)
 List<String> get newlyUnlockedZoneNames;/// Whether state has been loaded from persistence
 bool get isInitialized;
/// Create a copy of ZoneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneStateCopyWith<ZoneState> get copyWith => _$ZoneStateCopyWithImpl<ZoneState>(this as ZoneState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoneState&&const DeepCollectionEquality().equals(other.allZones, allZones)&&(identical(other.currentZone, currentZone) || other.currentZone == currentZone)&&const DeepCollectionEquality().equals(other.killCounts, killCounts)&&const DeepCollectionEquality().equals(other.newlyUnlockedZoneNames, newlyUnlockedZoneNames)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(allZones),currentZone,const DeepCollectionEquality().hash(killCounts),const DeepCollectionEquality().hash(newlyUnlockedZoneNames),isInitialized);

@override
String toString() {
  return 'ZoneState(allZones: $allZones, currentZone: $currentZone, killCounts: $killCounts, newlyUnlockedZoneNames: $newlyUnlockedZoneNames, isInitialized: $isInitialized)';
}


}

/// @nodoc
abstract mixin class $ZoneStateCopyWith<$Res>  {
  factory $ZoneStateCopyWith(ZoneState value, $Res Function(ZoneState) _then) = _$ZoneStateCopyWithImpl;
@useResult
$Res call({
 List<Zone> allZones, Zone currentZone, Map<String, int> killCounts, List<String> newlyUnlockedZoneNames, bool isInitialized
});


$ZoneCopyWith<$Res> get currentZone;

}
/// @nodoc
class _$ZoneStateCopyWithImpl<$Res>
    implements $ZoneStateCopyWith<$Res> {
  _$ZoneStateCopyWithImpl(this._self, this._then);

  final ZoneState _self;
  final $Res Function(ZoneState) _then;

/// Create a copy of ZoneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allZones = null,Object? currentZone = null,Object? killCounts = null,Object? newlyUnlockedZoneNames = null,Object? isInitialized = null,}) {
  return _then(_self.copyWith(
allZones: null == allZones ? _self.allZones : allZones // ignore: cast_nullable_to_non_nullable
as List<Zone>,currentZone: null == currentZone ? _self.currentZone : currentZone // ignore: cast_nullable_to_non_nullable
as Zone,killCounts: null == killCounts ? _self.killCounts : killCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,newlyUnlockedZoneNames: null == newlyUnlockedZoneNames ? _self.newlyUnlockedZoneNames : newlyUnlockedZoneNames // ignore: cast_nullable_to_non_nullable
as List<String>,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ZoneState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZoneCopyWith<$Res> get currentZone {
  
  return $ZoneCopyWith<$Res>(_self.currentZone, (value) {
    return _then(_self.copyWith(currentZone: value));
  });
}
}


/// Adds pattern-matching-related methods to [ZoneState].
extension ZoneStatePatterns on ZoneState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZoneState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZoneState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZoneState value)  $default,){
final _that = this;
switch (_that) {
case _ZoneState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZoneState value)?  $default,){
final _that = this;
switch (_that) {
case _ZoneState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Zone> allZones,  Zone currentZone,  Map<String, int> killCounts,  List<String> newlyUnlockedZoneNames,  bool isInitialized)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZoneState() when $default != null:
return $default(_that.allZones,_that.currentZone,_that.killCounts,_that.newlyUnlockedZoneNames,_that.isInitialized);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Zone> allZones,  Zone currentZone,  Map<String, int> killCounts,  List<String> newlyUnlockedZoneNames,  bool isInitialized)  $default,) {final _that = this;
switch (_that) {
case _ZoneState():
return $default(_that.allZones,_that.currentZone,_that.killCounts,_that.newlyUnlockedZoneNames,_that.isInitialized);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Zone> allZones,  Zone currentZone,  Map<String, int> killCounts,  List<String> newlyUnlockedZoneNames,  bool isInitialized)?  $default,) {final _that = this;
switch (_that) {
case _ZoneState() when $default != null:
return $default(_that.allZones,_that.currentZone,_that.killCounts,_that.newlyUnlockedZoneNames,_that.isInitialized);case _:
  return null;

}
}

}

/// @nodoc


class _ZoneState implements ZoneState {
  const _ZoneState({required final  List<Zone> allZones, required this.currentZone, final  Map<String, int> killCounts = const {}, final  List<String> newlyUnlockedZoneNames = const [], this.isInitialized = true}): _allZones = allZones,_killCounts = killCounts,_newlyUnlockedZoneNames = newlyUnlockedZoneNames;
  

/// All available zones in the game
 final  List<Zone> _allZones;
/// All available zones in the game
@override List<Zone> get allZones {
  if (_allZones is EqualUnmodifiableListView) return _allZones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allZones);
}

/// Currently active zone (where player is farming)
@override final  Zone currentZone;
/// Kill count per zone (for unlock tracking)
 final  Map<String, int> _killCounts;
/// Kill count per zone (for unlock tracking)
@override@JsonKey() Map<String, int> get killCounts {
  if (_killCounts is EqualUnmodifiableMapView) return _killCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_killCounts);
}

/// Newly unlocked zone names (for notifications)
 final  List<String> _newlyUnlockedZoneNames;
/// Newly unlocked zone names (for notifications)
@override@JsonKey() List<String> get newlyUnlockedZoneNames {
  if (_newlyUnlockedZoneNames is EqualUnmodifiableListView) return _newlyUnlockedZoneNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_newlyUnlockedZoneNames);
}

/// Whether state has been loaded from persistence
@override@JsonKey() final  bool isInitialized;

/// Create a copy of ZoneState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoneStateCopyWith<_ZoneState> get copyWith => __$ZoneStateCopyWithImpl<_ZoneState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZoneState&&const DeepCollectionEquality().equals(other._allZones, _allZones)&&(identical(other.currentZone, currentZone) || other.currentZone == currentZone)&&const DeepCollectionEquality().equals(other._killCounts, _killCounts)&&const DeepCollectionEquality().equals(other._newlyUnlockedZoneNames, _newlyUnlockedZoneNames)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allZones),currentZone,const DeepCollectionEquality().hash(_killCounts),const DeepCollectionEquality().hash(_newlyUnlockedZoneNames),isInitialized);

@override
String toString() {
  return 'ZoneState(allZones: $allZones, currentZone: $currentZone, killCounts: $killCounts, newlyUnlockedZoneNames: $newlyUnlockedZoneNames, isInitialized: $isInitialized)';
}


}

/// @nodoc
abstract mixin class _$ZoneStateCopyWith<$Res> implements $ZoneStateCopyWith<$Res> {
  factory _$ZoneStateCopyWith(_ZoneState value, $Res Function(_ZoneState) _then) = __$ZoneStateCopyWithImpl;
@override @useResult
$Res call({
 List<Zone> allZones, Zone currentZone, Map<String, int> killCounts, List<String> newlyUnlockedZoneNames, bool isInitialized
});


@override $ZoneCopyWith<$Res> get currentZone;

}
/// @nodoc
class __$ZoneStateCopyWithImpl<$Res>
    implements _$ZoneStateCopyWith<$Res> {
  __$ZoneStateCopyWithImpl(this._self, this._then);

  final _ZoneState _self;
  final $Res Function(_ZoneState) _then;

/// Create a copy of ZoneState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allZones = null,Object? currentZone = null,Object? killCounts = null,Object? newlyUnlockedZoneNames = null,Object? isInitialized = null,}) {
  return _then(_ZoneState(
allZones: null == allZones ? _self._allZones : allZones // ignore: cast_nullable_to_non_nullable
as List<Zone>,currentZone: null == currentZone ? _self.currentZone : currentZone // ignore: cast_nullable_to_non_nullable
as Zone,killCounts: null == killCounts ? _self._killCounts : killCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,newlyUnlockedZoneNames: null == newlyUnlockedZoneNames ? _self._newlyUnlockedZoneNames : newlyUnlockedZoneNames // ignore: cast_nullable_to_non_nullable
as List<String>,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ZoneState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZoneCopyWith<$Res> get currentZone {
  
  return $ZoneCopyWith<$Res>(_self.currentZone, (value) {
    return _then(_self.copyWith(currentZone: value));
  });
}
}

// dart format on
