// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {

 String? get id;// Firestoreドキュメントのid
 String? get name; String get hostUid; String get qrCode; String get status;@TimestampConverter() DateTime get joinedAt;@TimestampConverter() DateTime get lastActiveAt;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hostUid, hostUid) || other.hostUid == hostUid)&&(identical(other.qrCode, qrCode) || other.qrCode == qrCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hostUid,qrCode,status,joinedAt,lastActiveAt);

@override
String toString() {
  return 'Session(id: $id, name: $name, hostUid: $hostUid, qrCode: $qrCode, status: $status, joinedAt: $joinedAt, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String hostUid, String qrCode, String status,@TimestampConverter() DateTime joinedAt,@TimestampConverter() DateTime lastActiveAt
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? hostUid = null,Object? qrCode = null,Object? status = null,Object? joinedAt = null,Object? lastActiveAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,hostUid: null == hostUid ? _self.hostUid : hostUid // ignore: cast_nullable_to_non_nullable
as String,qrCode: null == qrCode ? _self.qrCode : qrCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: null == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String hostUid,  String qrCode,  String status, @TimestampConverter()  DateTime joinedAt, @TimestampConverter()  DateTime lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.name,_that.hostUid,_that.qrCode,_that.status,_that.joinedAt,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String hostUid,  String qrCode,  String status, @TimestampConverter()  DateTime joinedAt, @TimestampConverter()  DateTime lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.id,_that.name,_that.hostUid,_that.qrCode,_that.status,_that.joinedAt,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String hostUid,  String qrCode,  String status, @TimestampConverter()  DateTime joinedAt, @TimestampConverter()  DateTime lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.name,_that.hostUid,_that.qrCode,_that.status,_that.joinedAt,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({this.id, this.name, required this.hostUid, required this.qrCode, this.status = 'waiting', @TimestampConverter() required this.joinedAt, @TimestampConverter() required this.lastActiveAt});
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String? id;
// Firestoreドキュメントのid
@override final  String? name;
@override final  String hostUid;
@override final  String qrCode;
@override@JsonKey() final  String status;
@override@TimestampConverter() final  DateTime joinedAt;
@override@TimestampConverter() final  DateTime lastActiveAt;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hostUid, hostUid) || other.hostUid == hostUid)&&(identical(other.qrCode, qrCode) || other.qrCode == qrCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hostUid,qrCode,status,joinedAt,lastActiveAt);

@override
String toString() {
  return 'Session(id: $id, name: $name, hostUid: $hostUid, qrCode: $qrCode, status: $status, joinedAt: $joinedAt, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String hostUid, String qrCode, String status,@TimestampConverter() DateTime joinedAt,@TimestampConverter() DateTime lastActiveAt
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? hostUid = null,Object? qrCode = null,Object? status = null,Object? joinedAt = null,Object? lastActiveAt = null,}) {
  return _then(_Session(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,hostUid: null == hostUid ? _self.hostUid : hostUid // ignore: cast_nullable_to_non_nullable
as String,qrCode: null == qrCode ? _self.qrCode : qrCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: null == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
