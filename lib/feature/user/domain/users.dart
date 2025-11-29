import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/timestamp_converter.dart';

part 'users.freezed.dart';
part 'users.g.dart';

/// Firestoreのユーザードキュメント
@freezed
abstract class Users with _$Users {
  const factory Users({
    /// アイコン画像のURL
    required String iconUrl,

    /// ニックネーム
    required String nickname,

    /// 一言コメント（自己紹介）
    required String bio,

    /// 作成日時
    @TimestampConverter() required DateTime createdAt,

    /// 更新日時
    @TimestampConverter() required DateTime updatedAt,
  }) = _Users;

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);
}
