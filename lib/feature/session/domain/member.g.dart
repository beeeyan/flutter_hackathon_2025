// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  uid: json['uid'] as String,
  iconUrl: json['iconUrl'] as String,
  nickname: json['nickname'] as String,
  bio: json['bio'] as String,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt'] as Timestamp),
  lastActiveAt: const TimestampConverter().fromJson(
    json['lastActiveAt'] as Timestamp,
  ),
  isActive: json['isActive'] as bool? ?? true,
  role: json['role'] as String? ?? 'member',
  bySender:
      (json['bySender'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  sended:
      (json['sended'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'uid': instance.uid,
  'iconUrl': instance.iconUrl,
  'nickname': instance.nickname,
  'bio': instance.bio,
  'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
  'lastActiveAt': const TimestampConverter().toJson(instance.lastActiveAt),
  'isActive': instance.isActive,
  'role': instance.role,
  'bySender': instance.bySender,
  'sended': instance.sended,
};
