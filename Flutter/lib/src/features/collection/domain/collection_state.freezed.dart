// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectionState {

 List<UserPokemon> get ownedPokemon; bool get isLoading; CaptureResult? get lastCaptureResult;
/// Create a copy of CollectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionStateCopyWith<CollectionState> get copyWith => _$CollectionStateCopyWithImpl<CollectionState>(this as CollectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionState&&const DeepCollectionEquality().equals(other.ownedPokemon, ownedPokemon)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.lastCaptureResult, lastCaptureResult) || other.lastCaptureResult == lastCaptureResult));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ownedPokemon),isLoading,lastCaptureResult);

@override
String toString() {
  return 'CollectionState(ownedPokemon: $ownedPokemon, isLoading: $isLoading, lastCaptureResult: $lastCaptureResult)';
}


}

/// @nodoc
abstract mixin class $CollectionStateCopyWith<$Res>  {
  factory $CollectionStateCopyWith(CollectionState value, $Res Function(CollectionState) _then) = _$CollectionStateCopyWithImpl;
@useResult
$Res call({
 List<UserPokemon> ownedPokemon, bool isLoading, CaptureResult? lastCaptureResult
});




}
/// @nodoc
class _$CollectionStateCopyWithImpl<$Res>
    implements $CollectionStateCopyWith<$Res> {
  _$CollectionStateCopyWithImpl(this._self, this._then);

  final CollectionState _self;
  final $Res Function(CollectionState) _then;

/// Create a copy of CollectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ownedPokemon = null,Object? isLoading = null,Object? lastCaptureResult = freezed,}) {
  return _then(_self.copyWith(
ownedPokemon: null == ownedPokemon ? _self.ownedPokemon : ownedPokemon // ignore: cast_nullable_to_non_nullable
as List<UserPokemon>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,lastCaptureResult: freezed == lastCaptureResult ? _self.lastCaptureResult : lastCaptureResult // ignore: cast_nullable_to_non_nullable
as CaptureResult?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionState].
extension CollectionStatePatterns on CollectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionState value)  $default,){
final _that = this;
switch (_that) {
case _CollectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionState value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserPokemon> ownedPokemon,  bool isLoading,  CaptureResult? lastCaptureResult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionState() when $default != null:
return $default(_that.ownedPokemon,_that.isLoading,_that.lastCaptureResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserPokemon> ownedPokemon,  bool isLoading,  CaptureResult? lastCaptureResult)  $default,) {final _that = this;
switch (_that) {
case _CollectionState():
return $default(_that.ownedPokemon,_that.isLoading,_that.lastCaptureResult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserPokemon> ownedPokemon,  bool isLoading,  CaptureResult? lastCaptureResult)?  $default,) {final _that = this;
switch (_that) {
case _CollectionState() when $default != null:
return $default(_that.ownedPokemon,_that.isLoading,_that.lastCaptureResult);case _:
  return null;

}
}

}

/// @nodoc


class _CollectionState implements CollectionState {
  const _CollectionState({final  List<UserPokemon> ownedPokemon = const <UserPokemon>[], this.isLoading = false, this.lastCaptureResult}): _ownedPokemon = ownedPokemon;
  

 final  List<UserPokemon> _ownedPokemon;
@override@JsonKey() List<UserPokemon> get ownedPokemon {
  if (_ownedPokemon is EqualUnmodifiableListView) return _ownedPokemon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ownedPokemon);
}

@override@JsonKey() final  bool isLoading;
@override final  CaptureResult? lastCaptureResult;

/// Create a copy of CollectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionStateCopyWith<_CollectionState> get copyWith => __$CollectionStateCopyWithImpl<_CollectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionState&&const DeepCollectionEquality().equals(other._ownedPokemon, _ownedPokemon)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.lastCaptureResult, lastCaptureResult) || other.lastCaptureResult == lastCaptureResult));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ownedPokemon),isLoading,lastCaptureResult);

@override
String toString() {
  return 'CollectionState(ownedPokemon: $ownedPokemon, isLoading: $isLoading, lastCaptureResult: $lastCaptureResult)';
}


}

/// @nodoc
abstract mixin class _$CollectionStateCopyWith<$Res> implements $CollectionStateCopyWith<$Res> {
  factory _$CollectionStateCopyWith(_CollectionState value, $Res Function(_CollectionState) _then) = __$CollectionStateCopyWithImpl;
@override @useResult
$Res call({
 List<UserPokemon> ownedPokemon, bool isLoading, CaptureResult? lastCaptureResult
});




}
/// @nodoc
class __$CollectionStateCopyWithImpl<$Res>
    implements _$CollectionStateCopyWith<$Res> {
  __$CollectionStateCopyWithImpl(this._self, this._then);

  final _CollectionState _self;
  final $Res Function(_CollectionState) _then;

/// Create a copy of CollectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ownedPokemon = null,Object? isLoading = null,Object? lastCaptureResult = freezed,}) {
  return _then(_CollectionState(
ownedPokemon: null == ownedPokemon ? _self._ownedPokemon : ownedPokemon // ignore: cast_nullable_to_non_nullable
as List<UserPokemon>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,lastCaptureResult: freezed == lastCaptureResult ? _self.lastCaptureResult : lastCaptureResult // ignore: cast_nullable_to_non_nullable
as CaptureResult?,
  ));
}


}

// dart format on
