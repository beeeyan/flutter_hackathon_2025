import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/timestamp_converter.dart';

part 'member.freezed.dart';
part 'member.g.dart';


/// Firestoreのメンバードキュメント
@freezed
abstract class Member with _$Member {
  const factory Member({
    required String uid,
    
    // ユーザー情報のコピー（セッション参加時またはプロフィール編集時に保存）
    required String iconUrl,
    required String nickname,
    required String bio,
    @TimestampConverter() required DateTime joinedAt,
    @TimestampConverter() required DateTime lastActiveAt,
    @Default(true) bool isActive,
    @Default('member') String role,  // "host" または "member"
    
    // タップ履歴：誰が自分をタップしたか
    @Default({}) Map<String, int> bySender,
    
    // 自分が誰にタップしたか
    @Default({}) Map<String, int> sended,
    
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
