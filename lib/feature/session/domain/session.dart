import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/timestamp_converter.dart';

part 'session.freezed.dart';
part 'session.g.dart';

/// Firestoreのセッションドキュメント
@freezed
abstract class Session with _$Session {
  const factory Session({
    String? id, // Firestoreドキュメントのid
    String? name,
    required String hostUid,
    required String qrCode,
    @Default('waiting') String status,
    @TimestampConverter() required DateTime joinedAt,
    @TimestampConverter() required DateTime lastActiveAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}
