// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Users _$UsersFromJson(Map<String, dynamic> json) => _Users(
  iconUrl: json['iconUrl'] as String,
  nickname: json['nickname'] as String,
  bio: json['bio'] as String,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$UsersToJson(_Users instance) => <String, dynamic>{
  'iconUrl': instance.iconUrl,
  'nickname': instance.nickname,
  'bio': instance.bio,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
