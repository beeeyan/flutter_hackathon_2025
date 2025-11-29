// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Member {

 String get uid;// ユーザー情報のコピー（セッション参加時またはプロフィール編集時に保存）
 String get iconUrl; String get nickname; String get bio;@TimestampConverter() DateTime get joinedAt;@TimestampConverter() DateTime get lastActiveAt; bool get isActive; String get role;// "host" または "member"
// タップ履歴：誰が自分をタップしたか
 Map<String, int> get bySender;// 自分が誰にタップしたか
 Map<String, int> get sended;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.bySender, bySender)&&const DeepCollectionEquality().equals(other.sended, sended));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,iconUrl,nickname,bio,joinedAt,lastActiveAt,isActive,role,const DeepCollectionEquality().hash(bySender),const DeepCollectionEquality().hash(sended));

@override
String toString() {
  return 'Member(uid: $uid, iconUrl: $iconUrl, nickname: $nickname, bio: $bio, joinedAt: $joinedAt, lastActiveAt: $lastActiveAt, isActive: $isActive, role: $role, bySender: $bySender, sended: $sended)';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
 String uid, String iconUrl, String nickname, String bio,@TimestampConverter() DateTime joinedAt,@TimestampConverter() DateTime lastActiveAt, bool isActive, String role, Map<String, int> bySender, Map<String, int> sended
});




}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? iconUrl = null,Object? nickname = null,Object? bio = null,Object? joinedAt = null,Object? lastActiveAt = null,Object? isActive = null,Object? role = null,Object? bySender = null,Object? sended = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: null == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,bySender: null == bySender ? _self.bySender : bySender // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sended: null == sended ? _self.sended : sended // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String iconUrl,  String nickname,  String bio, @TimestampConverter()  DateTime joinedAt, @TimestampConverter()  DateTime lastActiveAt,  bool isActive,  String role,  Map<String, int> bySender,  Map<String, int> sended)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.uid,_that.iconUrl,_that.nickname,_that.bio,_that.joinedAt,_that.lastActiveAt,_that.isActive,_that.role,_that.bySender,_that.sended);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String iconUrl,  String nickname,  String bio, @TimestampConverter()  DateTime joinedAt, @TimestampConverter()  DateTime lastActiveAt,  bool isActive,  String role,  Map<String, int> bySender,  Map<String, int> sended)  $default,) {final _that = this;
switch (_that) {
case _Member():
return $default(_that.uid,_that.iconUrl,_that.nickname,_that.bio,_that.joinedAt,_that.lastActiveAt,_that.isActive,_that.role,_that.bySender,_that.sended);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String iconUrl,  String nickname,  String bio, @TimestampConverter()  DateTime joinedAt, @TimestampConverter()  DateTime lastActiveAt,  bool isActive,  String role,  Map<String, int> bySender,  Map<String, int> sended)?  $default,) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.uid,_that.iconUrl,_that.nickname,_that.bio,_that.joinedAt,_that.lastActiveAt,_that.isActive,_that.role,_that.bySender,_that.sended);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Member implements Member {
  const _Member({required this.uid, required this.iconUrl, required this.nickname, required this.bio, @TimestampConverter() required this.joinedAt, @TimestampConverter() required this.lastActiveAt, this.isActive = true, this.role = 'member', final  Map<String, int> bySender = const {}, final  Map<String, int> sended = const {}}): _bySender = bySender,_sended = sended;
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

@override final  String uid;
// ユーザー情報のコピー（セッション参加時またはプロフィール編集時に保存）
@override final  String iconUrl;
@override final  String nickname;
@override final  String bio;
@override@TimestampConverter() final  DateTime joinedAt;
@override@TimestampConverter() final  DateTime lastActiveAt;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  String role;
// "host" または "member"
// タップ履歴：誰が自分をタップしたか
 final  Map<String, int> _bySender;
// "host" または "member"
// タップ履歴：誰が自分をタップしたか
@override@JsonKey() Map<String, int> get bySender {
  if (_bySender is EqualUnmodifiableMapView) return _bySender;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bySender);
}

// 自分が誰にタップしたか
 final  Map<String, int> _sended;
// 自分が誰にタップしたか
@override@JsonKey() Map<String, int> get sended {
  if (_sended is EqualUnmodifiableMapView) return _sended;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_sended);
}


/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._bySender, _bySender)&&const DeepCollectionEquality().equals(other._sended, _sended));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,iconUrl,nickname,bio,joinedAt,lastActiveAt,isActive,role,const DeepCollectionEquality().hash(_bySender),const DeepCollectionEquality().hash(_sended));

@override
String toString() {
  return 'Member(uid: $uid, iconUrl: $iconUrl, nickname: $nickname, bio: $bio, joinedAt: $joinedAt, lastActiveAt: $lastActiveAt, isActive: $isActive, role: $role, bySender: $bySender, sended: $sended)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
 String uid, String iconUrl, String nickname, String bio,@TimestampConverter() DateTime joinedAt,@TimestampConverter() DateTime lastActiveAt, bool isActive, String role, Map<String, int> bySender, Map<String, int> sended
});




}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? iconUrl = null,Object? nickname = null,Object? bio = null,Object? joinedAt = null,Object? lastActiveAt = null,Object? isActive = null,Object? role = null,Object? bySender = null,Object? sended = null,}) {
  return _then(_Member(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: null == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,bySender: null == bySender ? _self._bySender : bySender // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sended: null == sended ? _self._sended : sended // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
