import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/member.dart';
import '../infra/member_repository.dart';

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
