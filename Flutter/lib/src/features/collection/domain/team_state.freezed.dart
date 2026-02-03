// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeamState {

 List<String> get activePokemonIds;
/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStateCopyWith<TeamState> get copyWith => _$TeamStateCopyWithImpl<TeamState>(this as TeamState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamState&&const DeepCollectionEquality().equals(other.activePokemonIds, activePokemonIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(activePokemonIds));

@override
String toString() {
  return 'TeamState(activePokemonIds: $activePokemonIds)';
}


}

/// @nodoc
abstract mixin class $TeamStateCopyWith<$Res>  {
  factory $TeamStateCopyWith(TeamState value, $Res Function(TeamState) _then) = _$TeamStateCopyWithImpl;
@useResult
$Res call({
 List<String> activePokemonIds
});




}
/// @nodoc
class _$TeamStateCopyWithImpl<$Res>
    implements $TeamStateCopyWith<$Res> {
  _$TeamStateCopyWithImpl(this._self, this._then);

  final TeamState _self;
  final $Res Function(TeamState) _then;

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activePokemonIds = null,}) {
  return _then(_self.copyWith(
activePokemonIds: null == activePokemonIds ? _self.activePokemonIds : activePokemonIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamState].
extension TeamStatePatterns on TeamState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamState value)  $default,){
final _that = this;
switch (_that) {
case _TeamState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamState value)?  $default,){
final _that = this;
switch (_that) {
case _TeamState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> activePokemonIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamState() when $default != null:
return $default(_that.activePokemonIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> activePokemonIds)  $default,) {final _that = this;
switch (_that) {
case _TeamState():
return $default(_that.activePokemonIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> activePokemonIds)?  $default,) {final _that = this;
switch (_that) {
case _TeamState() when $default != null:
return $default(_that.activePokemonIds);case _:
  return null;

}
}

}

/// @nodoc


class _TeamState implements TeamState {
  const _TeamState({final  List<String> activePokemonIds = const <String>[]}): _activePokemonIds = activePokemonIds;
  

 final  List<String> _activePokemonIds;
@override@JsonKey() List<String> get activePokemonIds {
  if (_activePokemonIds is EqualUnmodifiableListView) return _activePokemonIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activePokemonIds);
}


/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStateCopyWith<_TeamState> get copyWith => __$TeamStateCopyWithImpl<_TeamState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamState&&const DeepCollectionEquality().equals(other._activePokemonIds, _activePokemonIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_activePokemonIds));

@override
String toString() {
  return 'TeamState(activePokemonIds: $activePokemonIds)';
}


}

/// @nodoc
abstract mixin class _$TeamStateCopyWith<$Res> implements $TeamStateCopyWith<$Res> {
  factory _$TeamStateCopyWith(_TeamState value, $Res Function(_TeamState) _then) = __$TeamStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> activePokemonIds
});




}
/// @nodoc
class __$TeamStateCopyWithImpl<$Res>
    implements _$TeamStateCopyWith<$Res> {
  __$TeamStateCopyWithImpl(this._self, this._then);

  final _TeamState _self;
  final $Res Function(_TeamState) _then;

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activePokemonIds = null,}) {
  return _then(_TeamState(
activePokemonIds: null == activePokemonIds ? _self._activePokemonIds : activePokemonIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
