// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VotingState {

/// 残り時間（秒）
 int get remainingSeconds;/// 残り持ち点
 int get remainingPoints;/// タイムアップフラグ
 bool get isTimeUp;/// 送信待ちキュー {targetUid: 今回の増分count}
 Map<String, int> get sendQueue;/// 累積送信カウント {targetUid: 累積count}
/// tapUserに渡すための累積値を管理
 Map<String, int> get sentCounts;/// 最後にキューをフラッシュした時間
 DateTime? get lastFlushTime;
/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VotingStateCopyWith<VotingState> get copyWith => _$VotingStateCopyWithImpl<VotingState>(this as VotingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VotingState&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.remainingPoints, remainingPoints) || other.remainingPoints == remainingPoints)&&(identical(other.isTimeUp, isTimeUp) || other.isTimeUp == isTimeUp)&&const DeepCollectionEquality().equals(other.sendQueue, sendQueue)&&const DeepCollectionEquality().equals(other.sentCounts, sentCounts)&&(identical(other.lastFlushTime, lastFlushTime) || other.lastFlushTime == lastFlushTime));
}


@override
int get hashCode => Object.hash(runtimeType,remainingSeconds,remainingPoints,isTimeUp,const DeepCollectionEquality().hash(sendQueue),const DeepCollectionEquality().hash(sentCounts),lastFlushTime);

@override
String toString() {
  return 'VotingState(remainingSeconds: $remainingSeconds, remainingPoints: $remainingPoints, isTimeUp: $isTimeUp, sendQueue: $sendQueue, sentCounts: $sentCounts, lastFlushTime: $lastFlushTime)';
}


}

/// @nodoc
abstract mixin class $VotingStateCopyWith<$Res>  {
  factory $VotingStateCopyWith(VotingState value, $Res Function(VotingState) _then) = _$VotingStateCopyWithImpl;
@useResult
$Res call({
 int remainingSeconds, int remainingPoints, bool isTimeUp, Map<String, int> sendQueue, Map<String, int> sentCounts, DateTime? lastFlushTime
});




}
/// @nodoc
class _$VotingStateCopyWithImpl<$Res>
    implements $VotingStateCopyWith<$Res> {
  _$VotingStateCopyWithImpl(this._self, this._then);

  final VotingState _self;
  final $Res Function(VotingState) _then;

/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? remainingSeconds = null,Object? remainingPoints = null,Object? isTimeUp = null,Object? sendQueue = null,Object? sentCounts = null,Object? lastFlushTime = freezed,}) {
  return _then(_self.copyWith(
remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingPoints: null == remainingPoints ? _self.remainingPoints : remainingPoints // ignore: cast_nullable_to_non_nullable
as int,isTimeUp: null == isTimeUp ? _self.isTimeUp : isTimeUp // ignore: cast_nullable_to_non_nullable
as bool,sendQueue: null == sendQueue ? _self.sendQueue : sendQueue // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sentCounts: null == sentCounts ? _self.sentCounts : sentCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,lastFlushTime: freezed == lastFlushTime ? _self.lastFlushTime : lastFlushTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VotingState].
extension VotingStatePatterns on VotingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VotingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VotingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VotingState value)  $default,){
final _that = this;
switch (_that) {
case _VotingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VotingState value)?  $default,){
final _that = this;
switch (_that) {
case _VotingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int remainingSeconds,  int remainingPoints,  bool isTimeUp,  Map<String, int> sendQueue,  Map<String, int> sentCounts,  DateTime? lastFlushTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VotingState() when $default != null:
return $default(_that.remainingSeconds,_that.remainingPoints,_that.isTimeUp,_that.sendQueue,_that.sentCounts,_that.lastFlushTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int remainingSeconds,  int remainingPoints,  bool isTimeUp,  Map<String, int> sendQueue,  Map<String, int> sentCounts,  DateTime? lastFlushTime)  $default,) {final _that = this;
switch (_that) {
case _VotingState():
return $default(_that.remainingSeconds,_that.remainingPoints,_that.isTimeUp,_that.sendQueue,_that.sentCounts,_that.lastFlushTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int remainingSeconds,  int remainingPoints,  bool isTimeUp,  Map<String, int> sendQueue,  Map<String, int> sentCounts,  DateTime? lastFlushTime)?  $default,) {final _that = this;
switch (_that) {
case _VotingState() when $default != null:
return $default(_that.remainingSeconds,_that.remainingPoints,_that.isTimeUp,_that.sendQueue,_that.sentCounts,_that.lastFlushTime);case _:
  return null;

}
}

}

/// @nodoc


class _VotingState implements VotingState {
  const _VotingState({this.remainingSeconds = 60, this.remainingPoints = 100, this.isTimeUp = false, final  Map<String, int> sendQueue = const {}, final  Map<String, int> sentCounts = const {}, this.lastFlushTime}): _sendQueue = sendQueue,_sentCounts = sentCounts;
  

/// 残り時間（秒）
@override@JsonKey() final  int remainingSeconds;
/// 残り持ち点
@override@JsonKey() final  int remainingPoints;
/// タイムアップフラグ
@override@JsonKey() final  bool isTimeUp;
/// 送信待ちキュー {targetUid: 今回の増分count}
 final  Map<String, int> _sendQueue;
/// 送信待ちキュー {targetUid: 今回の増分count}
@override@JsonKey() Map<String, int> get sendQueue {
  if (_sendQueue is EqualUnmodifiableMapView) return _sendQueue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_sendQueue);
}

/// 累積送信カウント {targetUid: 累積count}
/// tapUserに渡すための累積値を管理
 final  Map<String, int> _sentCounts;
/// 累積送信カウント {targetUid: 累積count}
/// tapUserに渡すための累積値を管理
@override@JsonKey() Map<String, int> get sentCounts {
  if (_sentCounts is EqualUnmodifiableMapView) return _sentCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_sentCounts);
}

/// 最後にキューをフラッシュした時間
@override final  DateTime? lastFlushTime;

/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VotingStateCopyWith<_VotingState> get copyWith => __$VotingStateCopyWithImpl<_VotingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VotingState&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.remainingPoints, remainingPoints) || other.remainingPoints == remainingPoints)&&(identical(other.isTimeUp, isTimeUp) || other.isTimeUp == isTimeUp)&&const DeepCollectionEquality().equals(other._sendQueue, _sendQueue)&&const DeepCollectionEquality().equals(other._sentCounts, _sentCounts)&&(identical(other.lastFlushTime, lastFlushTime) || other.lastFlushTime == lastFlushTime));
}


@override
int get hashCode => Object.hash(runtimeType,remainingSeconds,remainingPoints,isTimeUp,const DeepCollectionEquality().hash(_sendQueue),const DeepCollectionEquality().hash(_sentCounts),lastFlushTime);

@override
String toString() {
  return 'VotingState(remainingSeconds: $remainingSeconds, remainingPoints: $remainingPoints, isTimeUp: $isTimeUp, sendQueue: $sendQueue, sentCounts: $sentCounts, lastFlushTime: $lastFlushTime)';
}


}

/// @nodoc
abstract mixin class _$VotingStateCopyWith<$Res> implements $VotingStateCopyWith<$Res> {
  factory _$VotingStateCopyWith(_VotingState value, $Res Function(_VotingState) _then) = __$VotingStateCopyWithImpl;
@override @useResult
$Res call({
 int remainingSeconds, int remainingPoints, bool isTimeUp, Map<String, int> sendQueue, Map<String, int> sentCounts, DateTime? lastFlushTime
});




}
/// @nodoc
class __$VotingStateCopyWithImpl<$Res>
    implements _$VotingStateCopyWith<$Res> {
  __$VotingStateCopyWithImpl(this._self, this._then);

  final _VotingState _self;
  final $Res Function(_VotingState) _then;

/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? remainingSeconds = null,Object? remainingPoints = null,Object? isTimeUp = null,Object? sendQueue = null,Object? sentCounts = null,Object? lastFlushTime = freezed,}) {
  return _then(_VotingState(
remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingPoints: null == remainingPoints ? _self.remainingPoints : remainingPoints // ignore: cast_nullable_to_non_nullable
as int,isTimeUp: null == isTimeUp ? _self.isTimeUp : isTimeUp // ignore: cast_nullable_to_non_nullable
as bool,sendQueue: null == sendQueue ? _self._sendQueue : sendQueue // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sentCounts: null == sentCounts ? _self._sentCounts : sentCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,lastFlushTime: freezed == lastFlushTime ? _self.lastFlushTime : lastFlushTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
