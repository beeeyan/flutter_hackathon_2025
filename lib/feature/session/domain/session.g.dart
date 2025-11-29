// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  id: json['id'] as String?,
  name: json['name'] as String?,
  hostUid: json['hostUid'] as String,
  qrCode: json['qrCode'] as String,
  status: json['status'] as String? ?? 'waiting',
  joinedAt: const TimestampConverter().fromJson(json['joinedAt'] as Timestamp),
  lastActiveAt: const TimestampConverter().fromJson(
    json['lastActiveAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'hostUid': instance.hostUid,
  'qrCode': instance.qrCode,
  'status': instance.status,
  'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
  'lastActiveAt': const TimestampConverter().toJson(instance.lastActiveAt),
};
