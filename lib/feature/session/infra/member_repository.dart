import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/state/auth_state.dart';
import '../domain/member.dart';

/// セッションリポジトリを提供するプロバイダー
final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  // TODO(beeeyan): 挙動を後で確認する必要がある。
  if (uid == null) {
    throw Exception('User not authenticated');
  }
  return MemberRepository(firestore: FirebaseFirestore.instance, uid: uid);
});

/// Firestore のセッションリポジトリ
class MemberRepository {
  MemberRepository({required FirebaseFirestore firestore, required String uid})
    : _firestore = firestore,
      _uid = uid;

  final FirebaseFirestore _firestore;
  final String _uid;

  /// セッションのメンバーコレクションへの参照
  CollectionReference<Map<String, dynamic>> _membersCollection(
    String sessionId,
  ) => _firestore.collection('sessions').doc(sessionId).collection('members');

  /// セッションに参加する
  Future<void> joinSession({
    required String sessionId,
    required String iconUrl,
    required String nickname,
    required String bio,
    String role = 'member',
  }) async {
    try {
      debugPrint('User $_uid joining session: $sessionId as $role');
      
      final member = Member(
        uid: _uid,
        iconUrl: iconUrl,
        nickname: nickname,
        bio: bio,
        joinedAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
        role: role,
      );

      await _membersCollection(sessionId).doc(_uid).set(member.toJson());
      debugPrint('Successfully joined session: $sessionId');
    } catch (e) {
      debugPrint('Failed to join session: $e');
      throw Exception('Failed to join session: $e');
    }
  }

  /// セッションから退出する
  Future<void> leaveSession(String sessionId) async {
    try {
      debugPrint('User $_uid leaving session: $sessionId');
      
      // メンバー情報を削除
      await _membersCollection(sessionId).doc(_uid).delete();
      
      debugPrint('Successfully left session: $sessionId');
    } catch (e) {
      debugPrint('Failed to leave session: $e');
      throw Exception('Failed to leave session: $e');
    }
  }

  /// 自分のメンバー情報を取得（Stream）
  Stream<Member?> watchMyMember(String sessionId) {
    debugPrint('Starting to watch member $_uid in session: $sessionId');
    return _membersCollection(sessionId)
        .doc(_uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        debugPrint('Member data updated for $_uid');
        return Member.fromJson(doc.data()!);
      } else {
        debugPrint('Member $_uid not found in session $sessionId');
        return null;
      }
    });
  }

  /// セッションのアクティブなメンバー一覧を取得（Stream）
  Stream<List<Member>> watchActiveSessionMembers(String sessionId) {
    debugPrint('Starting to watch active members in session: $sessionId');
    return _membersCollection(sessionId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final activeMembers = snapshot.docs
          .map((doc) => Member.fromJson(doc.data()))
          .toList();
      debugPrint('Session $sessionId active members updated: ${activeMembers.length} active members');
      return activeMembers;
    });
  }

  /// 特定のユーザーにタップする
  /// データの更新回数をある程度おさえるために、allTapCountsを引数で受け取る
  Future<void> tapUser({
    required String sessionId,
    required String targetUid,
    required int allTapCounts,
  }) async {
    try {
      debugPrint('User $_uid tapping $targetUid in session $sessionId (count: $allTapCounts)');
      
      final targetMemberRef = _membersCollection(sessionId).doc(targetUid);
      final myMemberRef = _membersCollection(sessionId).doc(_uid);

      // 相手の bySender を更新
      await targetMemberRef.update({
        'bySender.$_uid': allTapCounts,
      });

      // 自分の sended を更新（自分が誰をタップしたか）
      await myMemberRef.update({
        'sended.$targetUid': allTapCounts,
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
      
      debugPrint('Successfully updated tap counts for $_uid -> $targetUid');
    } catch (e) {
      debugPrint('Failed to update tap counts: $e');
      throw Exception('Failed to tap user: $e');
    }
  }

  /// セッションのメンバー数を取得
  Future<int> getMemberCount(String sessionId) async {
    try {
      debugPrint('Getting member count for session: $sessionId');
      final snapshot = await _membersCollection(sessionId).get();
      final count = snapshot.docs.length;
      debugPrint('Member count for session $sessionId: $count');
      return count;
    } catch (e) {
      debugPrint('Failed to get member count: $e');
      throw Exception('Failed to get member count: $e');
    }
  }

  /// 特定のメンバー情報を取得
  Future<Member?> getMember(String sessionId, String memberUid) async {
    try {
      debugPrint('Getting member $memberUid from session: $sessionId');
      final doc = await _membersCollection(sessionId).doc(memberUid).get();
      if (!doc.exists) {
        debugPrint('Member $memberUid not found in session $sessionId');
        return null;
      }
      
      final member = Member.fromJson(doc.data()!);
      debugPrint('Member found: ${member.nickname}');
      return member;
    } catch (e) {
      debugPrint('Failed to get member: $e');
      throw Exception('Failed to get member: $e');
    }
  }

}
