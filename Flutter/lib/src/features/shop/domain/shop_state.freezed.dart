// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShopState {

 List<Upgrade> get upgrades; List<ShopItem> get items;
/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopStateCopyWith<ShopState> get copyWith => _$ShopStateCopyWithImpl<ShopState>(this as ShopState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopState&&const DeepCollectionEquality().equals(other.upgrades, upgrades)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(upgrades),const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ShopState(upgrades: $upgrades, items: $items)';
}


}

/// @nodoc
abstract mixin class $ShopStateCopyWith<$Res>  {
  factory $ShopStateCopyWith(ShopState value, $Res Function(ShopState) _then) = _$ShopStateCopyWithImpl;
@useResult
$Res call({
 List<Upgrade> upgrades, List<ShopItem> items
});




}
/// @nodoc
class _$ShopStateCopyWithImpl<$Res>
    implements $ShopStateCopyWith<$Res> {
  _$ShopStateCopyWithImpl(this._self, this._then);

  final ShopState _self;
  final $Res Function(ShopState) _then;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? upgrades = null,Object? items = null,}) {
  return _then(_self.copyWith(
upgrades: null == upgrades ? _self.upgrades : upgrades // ignore: cast_nullable_to_non_nullable
as List<Upgrade>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ShopItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopState].
extension ShopStatePatterns on ShopState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopState value)  $default,){
final _that = this;
switch (_that) {
case _ShopState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopState value)?  $default,){
final _that = this;
switch (_that) {
case _ShopState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Upgrade> upgrades,  List<ShopItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopState() when $default != null:
return $default(_that.upgrades,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Upgrade> upgrades,  List<ShopItem> items)  $default,) {final _that = this;
switch (_that) {
case _ShopState():
return $default(_that.upgrades,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Upgrade> upgrades,  List<ShopItem> items)?  $default,) {final _that = this;
switch (_that) {
case _ShopState() when $default != null:
return $default(_that.upgrades,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ShopState implements ShopState {
  const _ShopState({required final  List<Upgrade> upgrades, required final  List<ShopItem> items}): _upgrades = upgrades,_items = items;
  

 final  List<Upgrade> _upgrades;
@override List<Upgrade> get upgrades {
  if (_upgrades is EqualUnmodifiableListView) return _upgrades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upgrades);
}

 final  List<ShopItem> _items;
@override List<ShopItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopStateCopyWith<_ShopState> get copyWith => __$ShopStateCopyWithImpl<_ShopState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopState&&const DeepCollectionEquality().equals(other._upgrades, _upgrades)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_upgrades),const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ShopState(upgrades: $upgrades, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ShopStateCopyWith<$Res> implements $ShopStateCopyWith<$Res> {
  factory _$ShopStateCopyWith(_ShopState value, $Res Function(_ShopState) _then) = __$ShopStateCopyWithImpl;
@override @useResult
$Res call({
 List<Upgrade> upgrades, List<ShopItem> items
});




}
/// @nodoc
class __$ShopStateCopyWithImpl<$Res>
    implements _$ShopStateCopyWith<$Res> {
  __$ShopStateCopyWithImpl(this._self, this._then);

  final _ShopState _self;
  final $Res Function(_ShopState) _then;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? upgrades = null,Object? items = null,}) {
  return _then(_ShopState(
upgrades: null == upgrades ? _self._upgrades : upgrades // ignore: cast_nullable_to_non_nullable
as List<Upgrade>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ShopItem>,
  ));
}


}

// dart format on
