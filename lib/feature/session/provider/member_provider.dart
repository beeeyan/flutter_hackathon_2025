import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/member.dart';
import '../infra/member_repository.dart';

/// メンバー管理のコントローラー
class MemberController {
  MemberController(this._repository);
  
  final MemberRepository _repository;
  
  /// セッションに参加する
  Future<void> joinSession({
    required String sessionId,
    required String iconUrl,
    required String nickname,
    required String bio,
    String role = 'member',
  }) async {
    await _repository.joinSession(
      sessionId: sessionId,
      iconUrl: iconUrl,
      nickname: nickname,
      bio: bio,
      role: role,
    );
  }
  
  /// セッションから退出する
  Future<void> leaveSession(String sessionId) async {
    await _repository.leaveSession(sessionId);
  }
  
  /// ユーザーをタップする
  Future<void> tapUser({
    required String sessionId,
    required String targetUid,
    required int allTapCounts,
  }) async {
    await _repository.tapUser(
      sessionId: sessionId,
      targetUid: targetUid,
      allTapCounts: allTapCounts,
    );
  }
}

/// メンバーコントローラーのプロバイダー
final memberControllerProvider = Provider<MemberController>((ref) {
  final repository = ref.read(memberRepositoryProvider);
  return MemberController(repository);
});

/// 自分のメンバー情報を監視するプロバイダー
final StreamProviderFamily<Member?, String> watchMyMemberProvider =
    StreamProvider.family<Member?, String>((
      ref,
      sessionId,
    ) {
      final repository = ref.read(memberRepositoryProvider);
      return repository.watchMyMember(sessionId);
    });

/// セッションのアクティブなメンバー一覧を監視するプロバイダー
final StreamProviderFamily<List<Member>, String>
watchActiveSessionMembersProvider = StreamProvider.family<List<Member>, String>(
  (
    ref,
    sessionId,
  ) {
    final repository = ref.read(memberRepositoryProvider);
    return repository.watchActiveSessionMembers(sessionId);
  },
);
