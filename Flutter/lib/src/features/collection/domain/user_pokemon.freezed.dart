// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_pokemon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserPokemon {

 String get id; int get pokemonId; DateTime get acquiredAt;
/// Create a copy of UserPokemon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPokemonCopyWith<UserPokemon> get copyWith => _$UserPokemonCopyWithImpl<UserPokemon>(this as UserPokemon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPokemon&&(identical(other.id, id) || other.id == id)&&(identical(other.pokemonId, pokemonId) || other.pokemonId == pokemonId)&&(identical(other.acquiredAt, acquiredAt) || other.acquiredAt == acquiredAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,pokemonId,acquiredAt);

@override
String toString() {
  return 'UserPokemon(id: $id, pokemonId: $pokemonId, acquiredAt: $acquiredAt)';
}


}

/// @nodoc
abstract mixin class $UserPokemonCopyWith<$Res>  {
  factory $UserPokemonCopyWith(UserPokemon value, $Res Function(UserPokemon) _then) = _$UserPokemonCopyWithImpl;
@useResult
$Res call({
 String id, int pokemonId, DateTime acquiredAt
});




}
/// @nodoc
class _$UserPokemonCopyWithImpl<$Res>
    implements $UserPokemonCopyWith<$Res> {
  _$UserPokemonCopyWithImpl(this._self, this._then);

  final UserPokemon _self;
  final $Res Function(UserPokemon) _then;

/// Create a copy of UserPokemon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pokemonId = null,Object? acquiredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pokemonId: null == pokemonId ? _self.pokemonId : pokemonId // ignore: cast_nullable_to_non_nullable
as int,acquiredAt: null == acquiredAt ? _self.acquiredAt : acquiredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPokemon].
extension UserPokemonPatterns on UserPokemon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPokemon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPokemon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPokemon value)  $default,){
final _that = this;
switch (_that) {
case _UserPokemon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPokemon value)?  $default,){
final _that = this;
switch (_that) {
case _UserPokemon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int pokemonId,  DateTime acquiredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPokemon() when $default != null:
return $default(_that.id,_that.pokemonId,_that.acquiredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int pokemonId,  DateTime acquiredAt)  $default,) {final _that = this;
switch (_that) {
case _UserPokemon():
return $default(_that.id,_that.pokemonId,_that.acquiredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int pokemonId,  DateTime acquiredAt)?  $default,) {final _that = this;
switch (_that) {
case _UserPokemon() when $default != null:
return $default(_that.id,_that.pokemonId,_that.acquiredAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserPokemon implements UserPokemon {
  const _UserPokemon({required this.id, required this.pokemonId, required this.acquiredAt});
  

@override final  String id;
@override final  int pokemonId;
@override final  DateTime acquiredAt;

/// Create a copy of UserPokemon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPokemonCopyWith<_UserPokemon> get copyWith => __$UserPokemonCopyWithImpl<_UserPokemon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPokemon&&(identical(other.id, id) || other.id == id)&&(identical(other.pokemonId, pokemonId) || other.pokemonId == pokemonId)&&(identical(other.acquiredAt, acquiredAt) || other.acquiredAt == acquiredAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,pokemonId,acquiredAt);

@override
String toString() {
  return 'UserPokemon(id: $id, pokemonId: $pokemonId, acquiredAt: $acquiredAt)';
}


}

/// @nodoc
abstract mixin class _$UserPokemonCopyWith<$Res> implements $UserPokemonCopyWith<$Res> {
  factory _$UserPokemonCopyWith(_UserPokemon value, $Res Function(_UserPokemon) _then) = __$UserPokemonCopyWithImpl;
@override @useResult
$Res call({
 String id, int pokemonId, DateTime acquiredAt
});




}
/// @nodoc
class __$UserPokemonCopyWithImpl<$Res>
    implements _$UserPokemonCopyWith<$Res> {
  __$UserPokemonCopyWithImpl(this._self, this._then);

  final _UserPokemon _self;
  final $Res Function(_UserPokemon) _then;

/// Create a copy of UserPokemon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pokemonId = null,Object? acquiredAt = null,}) {
  return _then(_UserPokemon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pokemonId: null == pokemonId ? _self.pokemonId : pokemonId // ignore: cast_nullable_to_non_nullable
as int,acquiredAt: null == acquiredAt ? _self.acquiredAt : acquiredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
