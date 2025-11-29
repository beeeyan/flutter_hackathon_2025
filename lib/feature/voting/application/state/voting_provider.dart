import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/application/state/auth_state.dart';
import '../../../session/domain/member.dart';
import '../../../session/domain/session.dart';
import '../../../session/provider/member_provider.dart';
import '../../../session/provider/session_provider.dart';
import 'voting_state.dart';

// =============================================================================
// Session / Member Providers (モック版)
// TODO: infra層完成後に実際のFirestoreストリームに差し替え
// =============================================================================

/// 現在参加中のセッションID
final currentSessionIdProvider = StateProviderFamily<String, String>((
  ref,
  qrCode,
) {
  return ref.watch(watchSessionProvider(qrCode)).value!.id!;
});

/// 現在のユーザーUID
final currentUserUidProvider = StateProvider<String>((ref) {
  return ref.watch(authStateProvider).value!.uid;
});

/// セッションのリアルタイム監視
final sessionStreamProvider = StreamProviderFamily<Session?, String>((
  ref,
  qrCode,
) {
  final res = ref.watch(watchSessionProvider(qrCode));
  return res.when(
    data: Stream.value,
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// メンバー一覧のリアルタイム監視
final membersStreamProvider = StreamProviderFamily<List<Member>, String>((
  ref,
  qrCode,
) {
  final sessionId = ref.watch(currentSessionIdProvider(qrCode));
  final res = ref.watch(watchActiveSessionMembersProvider(sessionId));

  return res.when(
    data: (members) {
      return Stream.value(members);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

/// 自分のメンバー情報のリアルタイム監視
final myMemberStreamProvider = StreamProviderFamily<Member?, String>((
  ref,
  qrCode,
) {
  final sessionId = ref.watch(currentSessionIdProvider(qrCode));

  final res = ref.watch(watchMyMemberProvider(sessionId));

  return res.when(
    data: (member) {
      return Stream.value(member);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// 現在のユーザーがホストかどうか
final isHostProvider = ProviderFamily<bool, String>((ref, qrCode) {
  final session = ref.watch(sessionStreamProvider(qrCode)).valueOrNull;
  final myUid = ref.watch(currentUserUidProvider);
  return session?.hostUid == myUid;
});

// =============================================================================
// Voting State Provider
// =============================================================================

/// 投票状態管理のNotifier
class VotingStateNotifier extends StateNotifier<VotingState> {
  VotingStateNotifier(this._ref, this._sessionId) : super(const VotingState()) {
    _startTimer();
  }

  final Ref _ref;
  final String _sessionId;
  Timer? _countdownTimer;
  Timer? _flushTimer;

  /// カウントダウンタイマー開始
  void _startTimer() {
    state = state.copyWith(
      remainingSeconds: VotingConfig.votingDurationSeconds,
      lastFlushTime: DateTime.now(),
    );

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        timer.cancel();
        _onTimeUp();
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      }
    });

    // フラッシュタイマー（1秒ごとにキューをチェック）
    _flushTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkAndFlushQueue();
    });
  }

  /// タイムアップ処理
  void _onTimeUp() {
    state = state.copyWith(isTimeUp: true);
    _flushTimer?.cancel();
    _flushQueue(); // 残りキューをフラッシュ
  }

  /// タップ処理
  void onTap(String targetUid) {
    if (state.isTimeUp || state.remainingPoints <= 0) return;

    final newQueue = Map<String, int>.from(state.sendQueue);
    newQueue[targetUid] = (newQueue[targetUid] ?? 0) + 1;

    state = state.copyWith(
      remainingPoints: state.remainingPoints - 1,
      sendQueue: newQueue,
    );

    // 閾値到達でフラッシュ
    final totalInQueue = newQueue.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );
    if (totalInQueue >= VotingConfig.flushThresholdCount) {
      _flushQueue();
    }
  }

  /// キューのフラッシュをチェック
  void _checkAndFlushQueue() {
    if (state.sendQueue.isEmpty) return;

    final now = DateTime.now();
    final lastFlush = state.lastFlushTime ?? now;
    final secondsSinceLastFlush = now.difference(lastFlush).inSeconds;

    if (secondsSinceLastFlush >= VotingConfig.flushThresholdSeconds) {
      _flushQueue();
    }
  }

  /// キューをFirestoreに送信
  Future<void> _flushQueue() async {
    if (state.sendQueue.isEmpty) return;

    final queueToSend = Map<String, int>.from(state.sendQueue);
    final newSentCounts = Map<String, int>.from(state.sentCounts);

    // 累積カウントを更新
    for (final entry in queueToSend.entries) {
      newSentCounts[entry.key] = (newSentCounts[entry.key] ?? 0) + entry.value;
    }

    // 状態を先に更新（キューをクリア）
    state = state.copyWith(
      sendQueue: {},
      sentCounts: newSentCounts,
      lastFlushTime: DateTime.now(),
    );

    debugPrint('📤 Flushing vote queue: $queueToSend');
    debugPrint('📊 Total sent counts: $newSentCounts');

    // Firestoreに送信（各ターゲットごとに累積カウントを送信）
    try {
      final memberController = _ref.read(memberControllerProvider);
      for (final entry in newSentCounts.entries) {
        // キューにあったターゲットのみ更新
        if (queueToSend.containsKey(entry.key)) {
          await memberController.tapUser(
            sessionId: _sessionId,
            targetUid: entry.key,
            allTapCounts: entry.value,
          );
        }
      }
      debugPrint('✅ Successfully flushed votes to Firestore');
    } catch (e) {
      debugPrint('❌ Failed to flush votes: $e');
    }
  }

  /// インタラクション停止
  void stopInteraction() {
    state = state.copyWith(isTimeUp: true);
    _countdownTimer?.cancel();
    _flushTimer?.cancel();
    _flushQueue();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _flushTimer?.cancel();
    super.dispose();
  }
}

/// 投票状態Provider（sessionIdをパラメータとして受け取る）
final AutoDisposeStateNotifierProviderFamily<
  VotingStateNotifier,
  VotingState,
  String
>
votingStateProvider = StateNotifierProvider.autoDispose
    .family<VotingStateNotifier, VotingState, String>((ref, sessionId) {
      return VotingStateNotifier(ref, sessionId);
    });

// =============================================================================
// Mock Data
// =============================================================================

final _mockMembers = [
  Member(
    uid: 'mock-user-uid',
    iconUrl: 'https://i.pravatar.cc/150?img=1',
    nickname: 'あなた',
    bio: '自分です',
    joinedAt: DateTime.now(),
    lastActiveAt: DateTime.now(),
  ),
  Member(
    uid: 'user-2',
    iconUrl: 'https://i.pravatar.cc/150?img=2',
    nickname: 'たろう',
    bio: 'よろしく！',
    joinedAt: DateTime.now(),
    lastActiveAt: DateTime.now(),
  ),
  Member(
    uid: 'user-3',
    iconUrl: 'https://i.pravatar.cc/150?img=3',
    nickname: 'はなこ',
    bio: 'こんにちは',
    joinedAt: DateTime.now(),
    lastActiveAt: DateTime.now(),
  ),
  Member(
    uid: 'user-4',
    iconUrl: 'https://i.pravatar.cc/150?img=4',
    nickname: 'じろう',
    bio: 'はじめまして',
    joinedAt: DateTime.now(),
    lastActiveAt: DateTime.now(),
  ),
  Member(
    uid: 'user-5',
    iconUrl: 'https://i.pravatar.cc/150?img=5',
    nickname: 'さくら',
    bio: 'どうぞよろしく',
    joinedAt: DateTime.now(),
    lastActiveAt: DateTime.now(),
  ),
  Member(
    uid: 'mock-host-uid',
    iconUrl: 'https://i.pravatar.cc/150?img=6',
    nickname: 'ホスト',
    bio: 'ホストです',
    joinedAt: DateTime.now(),
    lastActiveAt: DateTime.now(),
    role: 'host',
  ),
];
