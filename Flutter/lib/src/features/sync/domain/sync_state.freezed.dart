// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncState {

 bool get isSyncing; int get lastSyncTimestamp; String? get lastError; bool get hasPendingSync; int get consecutiveFailures;// M4: Track repeated failures
 Map<String, dynamic>? get cloudDataReceived;
/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStateCopyWith<SyncState> get copyWith => _$SyncStateCopyWithImpl<SyncState>(this as SyncState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncState&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.hasPendingSync, hasPendingSync) || other.hasPendingSync == hasPendingSync)&&(identical(other.consecutiveFailures, consecutiveFailures) || other.consecutiveFailures == consecutiveFailures)&&const DeepCollectionEquality().equals(other.cloudDataReceived, cloudDataReceived));
}


@override
int get hashCode => Object.hash(runtimeType,isSyncing,lastSyncTimestamp,lastError,hasPendingSync,consecutiveFailures,const DeepCollectionEquality().hash(cloudDataReceived));

@override
String toString() {
  return 'SyncState(isSyncing: $isSyncing, lastSyncTimestamp: $lastSyncTimestamp, lastError: $lastError, hasPendingSync: $hasPendingSync, consecutiveFailures: $consecutiveFailures, cloudDataReceived: $cloudDataReceived)';
}


}

/// @nodoc
abstract mixin class $SyncStateCopyWith<$Res>  {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) _then) = _$SyncStateCopyWithImpl;
@useResult
$Res call({
 bool isSyncing, int lastSyncTimestamp, String? lastError, bool hasPendingSync, int consecutiveFailures, Map<String, dynamic>? cloudDataReceived
});




}
/// @nodoc
class _$SyncStateCopyWithImpl<$Res>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._self, this._then);

  final SyncState _self;
  final $Res Function(SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSyncing = null,Object? lastSyncTimestamp = null,Object? lastError = freezed,Object? hasPendingSync = null,Object? consecutiveFailures = null,Object? cloudDataReceived = freezed,}) {
  return _then(_self.copyWith(
isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncTimestamp: null == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as int,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,hasPendingSync: null == hasPendingSync ? _self.hasPendingSync : hasPendingSync // ignore: cast_nullable_to_non_nullable
as bool,consecutiveFailures: null == consecutiveFailures ? _self.consecutiveFailures : consecutiveFailures // ignore: cast_nullable_to_non_nullable
as int,cloudDataReceived: freezed == cloudDataReceived ? _self.cloudDataReceived : cloudDataReceived // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncState value)  $default,){
final _that = this;
switch (_that) {
case _SyncState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSyncing,  int lastSyncTimestamp,  String? lastError,  bool hasPendingSync,  int consecutiveFailures,  Map<String, dynamic>? cloudDataReceived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.isSyncing,_that.lastSyncTimestamp,_that.lastError,_that.hasPendingSync,_that.consecutiveFailures,_that.cloudDataReceived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSyncing,  int lastSyncTimestamp,  String? lastError,  bool hasPendingSync,  int consecutiveFailures,  Map<String, dynamic>? cloudDataReceived)  $default,) {final _that = this;
switch (_that) {
case _SyncState():
return $default(_that.isSyncing,_that.lastSyncTimestamp,_that.lastError,_that.hasPendingSync,_that.consecutiveFailures,_that.cloudDataReceived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSyncing,  int lastSyncTimestamp,  String? lastError,  bool hasPendingSync,  int consecutiveFailures,  Map<String, dynamic>? cloudDataReceived)?  $default,) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.isSyncing,_that.lastSyncTimestamp,_that.lastError,_that.hasPendingSync,_that.consecutiveFailures,_that.cloudDataReceived);case _:
  return null;

}
}

}

/// @nodoc


class _SyncState extends SyncState {
  const _SyncState({this.isSyncing = false, this.lastSyncTimestamp = 0, this.lastError, this.hasPendingSync = false, this.consecutiveFailures = 0, final  Map<String, dynamic>? cloudDataReceived}): _cloudDataReceived = cloudDataReceived,super._();
  

@override@JsonKey() final  bool isSyncing;
@override@JsonKey() final  int lastSyncTimestamp;
@override final  String? lastError;
@override@JsonKey() final  bool hasPendingSync;
@override@JsonKey() final  int consecutiveFailures;
// M4: Track repeated failures
 final  Map<String, dynamic>? _cloudDataReceived;
// M4: Track repeated failures
@override Map<String, dynamic>? get cloudDataReceived {
  final value = _cloudDataReceived;
  if (value == null) return null;
  if (_cloudDataReceived is EqualUnmodifiableMapView) return _cloudDataReceived;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStateCopyWith<_SyncState> get copyWith => __$SyncStateCopyWithImpl<_SyncState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncState&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.hasPendingSync, hasPendingSync) || other.hasPendingSync == hasPendingSync)&&(identical(other.consecutiveFailures, consecutiveFailures) || other.consecutiveFailures == consecutiveFailures)&&const DeepCollectionEquality().equals(other._cloudDataReceived, _cloudDataReceived));
}


@override
int get hashCode => Object.hash(runtimeType,isSyncing,lastSyncTimestamp,lastError,hasPendingSync,consecutiveFailures,const DeepCollectionEquality().hash(_cloudDataReceived));

@override
String toString() {
  return 'SyncState(isSyncing: $isSyncing, lastSyncTimestamp: $lastSyncTimestamp, lastError: $lastError, hasPendingSync: $hasPendingSync, consecutiveFailures: $consecutiveFailures, cloudDataReceived: $cloudDataReceived)';
}


}

/// @nodoc
abstract mixin class _$SyncStateCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory _$SyncStateCopyWith(_SyncState value, $Res Function(_SyncState) _then) = __$SyncStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSyncing, int lastSyncTimestamp, String? lastError, bool hasPendingSync, int consecutiveFailures, Map<String, dynamic>? cloudDataReceived
});




}
/// @nodoc
class __$SyncStateCopyWithImpl<$Res>
    implements _$SyncStateCopyWith<$Res> {
  __$SyncStateCopyWithImpl(this._self, this._then);

  final _SyncState _self;
  final $Res Function(_SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSyncing = null,Object? lastSyncTimestamp = null,Object? lastError = freezed,Object? hasPendingSync = null,Object? consecutiveFailures = null,Object? cloudDataReceived = freezed,}) {
  return _then(_SyncState(
isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncTimestamp: null == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as int,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,hasPendingSync: null == hasPendingSync ? _self.hasPendingSync : hasPendingSync // ignore: cast_nullable_to_non_nullable
as bool,consecutiveFailures: null == consecutiveFailures ? _self.consecutiveFailures : consecutiveFailures // ignore: cast_nullable_to_non_nullable
as int,cloudDataReceived: freezed == cloudDataReceived ? _self._cloudDataReceived : cloudDataReceived // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
