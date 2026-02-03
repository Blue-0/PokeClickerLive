// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clicker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClickerState {

 int get currency; int get currentHp; int get maxHp; int get level; bool get isLoading; int get clickPower; int get dps; int get teamDps; int get critChance; bool get isBoss; int get remainingBossTime; Pokemon? get currentPokemon;
/// Create a copy of ClickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClickerStateCopyWith<ClickerState> get copyWith => _$ClickerStateCopyWithImpl<ClickerState>(this as ClickerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClickerState&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentHp, currentHp) || other.currentHp == currentHp)&&(identical(other.maxHp, maxHp) || other.maxHp == maxHp)&&(identical(other.level, level) || other.level == level)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.clickPower, clickPower) || other.clickPower == clickPower)&&(identical(other.dps, dps) || other.dps == dps)&&(identical(other.teamDps, teamDps) || other.teamDps == teamDps)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.isBoss, isBoss) || other.isBoss == isBoss)&&(identical(other.remainingBossTime, remainingBossTime) || other.remainingBossTime == remainingBossTime)&&(identical(other.currentPokemon, currentPokemon) || other.currentPokemon == currentPokemon));
}


@override
int get hashCode => Object.hash(runtimeType,currency,currentHp,maxHp,level,isLoading,clickPower,dps,teamDps,critChance,isBoss,remainingBossTime,currentPokemon);

@override
String toString() {
  return 'ClickerState(currency: $currency, currentHp: $currentHp, maxHp: $maxHp, level: $level, isLoading: $isLoading, clickPower: $clickPower, dps: $dps, teamDps: $teamDps, critChance: $critChance, isBoss: $isBoss, remainingBossTime: $remainingBossTime, currentPokemon: $currentPokemon)';
}


}

/// @nodoc
abstract mixin class $ClickerStateCopyWith<$Res>  {
  factory $ClickerStateCopyWith(ClickerState value, $Res Function(ClickerState) _then) = _$ClickerStateCopyWithImpl;
@useResult
$Res call({
 int currency, int currentHp, int maxHp, int level, bool isLoading, int clickPower, int dps, int teamDps, int critChance, bool isBoss, int remainingBossTime, Pokemon? currentPokemon
});


$PokemonCopyWith<$Res>? get currentPokemon;

}
/// @nodoc
class _$ClickerStateCopyWithImpl<$Res>
    implements $ClickerStateCopyWith<$Res> {
  _$ClickerStateCopyWithImpl(this._self, this._then);

  final ClickerState _self;
  final $Res Function(ClickerState) _then;

/// Create a copy of ClickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? currentHp = null,Object? maxHp = null,Object? level = null,Object? isLoading = null,Object? clickPower = null,Object? dps = null,Object? teamDps = null,Object? critChance = null,Object? isBoss = null,Object? remainingBossTime = null,Object? currentPokemon = freezed,}) {
  return _then(_self.copyWith(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as int,currentHp: null == currentHp ? _self.currentHp : currentHp // ignore: cast_nullable_to_non_nullable
as int,maxHp: null == maxHp ? _self.maxHp : maxHp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,clickPower: null == clickPower ? _self.clickPower : clickPower // ignore: cast_nullable_to_non_nullable
as int,dps: null == dps ? _self.dps : dps // ignore: cast_nullable_to_non_nullable
as int,teamDps: null == teamDps ? _self.teamDps : teamDps // ignore: cast_nullable_to_non_nullable
as int,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as int,isBoss: null == isBoss ? _self.isBoss : isBoss // ignore: cast_nullable_to_non_nullable
as bool,remainingBossTime: null == remainingBossTime ? _self.remainingBossTime : remainingBossTime // ignore: cast_nullable_to_non_nullable
as int,currentPokemon: freezed == currentPokemon ? _self.currentPokemon : currentPokemon // ignore: cast_nullable_to_non_nullable
as Pokemon?,
  ));
}
/// Create a copy of ClickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonCopyWith<$Res>? get currentPokemon {
    if (_self.currentPokemon == null) {
    return null;
  }

  return $PokemonCopyWith<$Res>(_self.currentPokemon!, (value) {
    return _then(_self.copyWith(currentPokemon: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClickerState].
extension ClickerStatePatterns on ClickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClickerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClickerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClickerState value)  $default,){
final _that = this;
switch (_that) {
case _ClickerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClickerState value)?  $default,){
final _that = this;
switch (_that) {
case _ClickerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currency,  int currentHp,  int maxHp,  int level,  bool isLoading,  int clickPower,  int dps,  int teamDps,  int critChance,  bool isBoss,  int remainingBossTime,  Pokemon? currentPokemon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClickerState() when $default != null:
return $default(_that.currency,_that.currentHp,_that.maxHp,_that.level,_that.isLoading,_that.clickPower,_that.dps,_that.teamDps,_that.critChance,_that.isBoss,_that.remainingBossTime,_that.currentPokemon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currency,  int currentHp,  int maxHp,  int level,  bool isLoading,  int clickPower,  int dps,  int teamDps,  int critChance,  bool isBoss,  int remainingBossTime,  Pokemon? currentPokemon)  $default,) {final _that = this;
switch (_that) {
case _ClickerState():
return $default(_that.currency,_that.currentHp,_that.maxHp,_that.level,_that.isLoading,_that.clickPower,_that.dps,_that.teamDps,_that.critChance,_that.isBoss,_that.remainingBossTime,_that.currentPokemon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currency,  int currentHp,  int maxHp,  int level,  bool isLoading,  int clickPower,  int dps,  int teamDps,  int critChance,  bool isBoss,  int remainingBossTime,  Pokemon? currentPokemon)?  $default,) {final _that = this;
switch (_that) {
case _ClickerState() when $default != null:
return $default(_that.currency,_that.currentHp,_that.maxHp,_that.level,_that.isLoading,_that.clickPower,_that.dps,_that.teamDps,_that.critChance,_that.isBoss,_that.remainingBossTime,_that.currentPokemon);case _:
  return null;

}
}

}

/// @nodoc


class _ClickerState implements ClickerState {
  const _ClickerState({this.currency = 0, this.currentHp = 10, this.maxHp = 10, this.level = 1, this.isLoading = false, this.clickPower = 1, this.dps = 0, this.teamDps = 0, this.critChance = 0, this.isBoss = false, this.remainingBossTime = 0, this.currentPokemon});
  

@override@JsonKey() final  int currency;
@override@JsonKey() final  int currentHp;
@override@JsonKey() final  int maxHp;
@override@JsonKey() final  int level;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int clickPower;
@override@JsonKey() final  int dps;
@override@JsonKey() final  int teamDps;
@override@JsonKey() final  int critChance;
@override@JsonKey() final  bool isBoss;
@override@JsonKey() final  int remainingBossTime;
@override final  Pokemon? currentPokemon;

/// Create a copy of ClickerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClickerStateCopyWith<_ClickerState> get copyWith => __$ClickerStateCopyWithImpl<_ClickerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClickerState&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentHp, currentHp) || other.currentHp == currentHp)&&(identical(other.maxHp, maxHp) || other.maxHp == maxHp)&&(identical(other.level, level) || other.level == level)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.clickPower, clickPower) || other.clickPower == clickPower)&&(identical(other.dps, dps) || other.dps == dps)&&(identical(other.teamDps, teamDps) || other.teamDps == teamDps)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.isBoss, isBoss) || other.isBoss == isBoss)&&(identical(other.remainingBossTime, remainingBossTime) || other.remainingBossTime == remainingBossTime)&&(identical(other.currentPokemon, currentPokemon) || other.currentPokemon == currentPokemon));
}


@override
int get hashCode => Object.hash(runtimeType,currency,currentHp,maxHp,level,isLoading,clickPower,dps,teamDps,critChance,isBoss,remainingBossTime,currentPokemon);

@override
String toString() {
  return 'ClickerState(currency: $currency, currentHp: $currentHp, maxHp: $maxHp, level: $level, isLoading: $isLoading, clickPower: $clickPower, dps: $dps, teamDps: $teamDps, critChance: $critChance, isBoss: $isBoss, remainingBossTime: $remainingBossTime, currentPokemon: $currentPokemon)';
}


}

/// @nodoc
abstract mixin class _$ClickerStateCopyWith<$Res> implements $ClickerStateCopyWith<$Res> {
  factory _$ClickerStateCopyWith(_ClickerState value, $Res Function(_ClickerState) _then) = __$ClickerStateCopyWithImpl;
@override @useResult
$Res call({
 int currency, int currentHp, int maxHp, int level, bool isLoading, int clickPower, int dps, int teamDps, int critChance, bool isBoss, int remainingBossTime, Pokemon? currentPokemon
});


@override $PokemonCopyWith<$Res>? get currentPokemon;

}
/// @nodoc
class __$ClickerStateCopyWithImpl<$Res>
    implements _$ClickerStateCopyWith<$Res> {
  __$ClickerStateCopyWithImpl(this._self, this._then);

  final _ClickerState _self;
  final $Res Function(_ClickerState) _then;

/// Create a copy of ClickerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? currentHp = null,Object? maxHp = null,Object? level = null,Object? isLoading = null,Object? clickPower = null,Object? dps = null,Object? teamDps = null,Object? critChance = null,Object? isBoss = null,Object? remainingBossTime = null,Object? currentPokemon = freezed,}) {
  return _then(_ClickerState(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as int,currentHp: null == currentHp ? _self.currentHp : currentHp // ignore: cast_nullable_to_non_nullable
as int,maxHp: null == maxHp ? _self.maxHp : maxHp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,clickPower: null == clickPower ? _self.clickPower : clickPower // ignore: cast_nullable_to_non_nullable
as int,dps: null == dps ? _self.dps : dps // ignore: cast_nullable_to_non_nullable
as int,teamDps: null == teamDps ? _self.teamDps : teamDps // ignore: cast_nullable_to_non_nullable
as int,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as int,isBoss: null == isBoss ? _self.isBoss : isBoss // ignore: cast_nullable_to_non_nullable
as bool,remainingBossTime: null == remainingBossTime ? _self.remainingBossTime : remainingBossTime // ignore: cast_nullable_to_non_nullable
as int,currentPokemon: freezed == currentPokemon ? _self.currentPokemon : currentPokemon // ignore: cast_nullable_to_non_nullable
as Pokemon?,
  ));
}

/// Create a copy of ClickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonCopyWith<$Res>? get currentPokemon {
    if (_self.currentPokemon == null) {
    return null;
  }

  return $PokemonCopyWith<$Res>(_self.currentPokemon!, (value) {
    return _then(_self.copyWith(currentPokemon: value));
  });
}
}

// dart format on
