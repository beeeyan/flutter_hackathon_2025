import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../session/domain/member.dart';
import '../../../session/domain/session.dart';
import 'voting_state.dart';

// =============================================================================
// Session / Member Providers (モック版)
// TODO: infra層完成後に実際のFirestoreストリームに差し替え
// =============================================================================

/// 現在参加中のセッションID
final currentSessionIdProvider = StateProvider<String>((ref) {
  return 'mock-session-id';
});

/// 現在のユーザーUID
/// TODO: 実際のauthStateProviderから取得するように変更
final currentUserUidProvider = StateProvider<String>((ref) {
  return 'mock-user-uid';
});

/// セッションのリアルタイム監視（モック版）
final sessionStreamProvider = StreamProvider<Session>((ref) {
  // TODO: infra層完成後に以下のように差し替え
  // final sessionId = ref.watch(currentSessionIdProvider);
  // final repository = ref.watch(votingRepositoryProvider);
  // return repository.streamSession(sessionId);

  return Stream.value(
    Session(
      id: 'mock-session-id',
      name: 'テストセッション',
      hostUid: 'mock-host-uid',
      qrCode: 'SES-TEST-1234',
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
});

/// メンバー一覧のリアルタイム監視（モック版）
final membersStreamProvider = StreamProvider<List<Member>>((ref) {
  // TODO: infra層完成後に以下のように差し替え
  // final sessionId = ref.watch(currentSessionIdProvider);
  // final repository = ref.watch(votingRepositoryProvider);
  // return repository.streamMembers(sessionId);

  return Stream.value(_mockMembers);
});

/// 自分のメンバー情報のリアルタイム監視（モック版）
final myMemberStreamProvider = StreamProvider<Member>((ref) {
  // TODO: infra層完成後に以下のように差し替え
  // final sessionId = ref.watch(currentSessionIdProvider);
  // final myUid = ref.watch(currentUserUidProvider);
  // final repository = ref.watch(votingRepositoryProvider);
  // return repository.streamMyMember(sessionId, myUid);

  final myUid = ref.watch(currentUserUidProvider);
  return Stream.value(
    _mockMembers.firstWhere(
      (m) => m.uid == myUid,
      orElse: () => _mockMembers.first,
    ),
  );
});

/// 現在のユーザーがホストかどうか
final isHostProvider = Provider<bool>((ref) {
  final session = ref.watch(sessionStreamProvider).valueOrNull;
  final myUid = ref.watch(currentUserUidProvider);
  return session?.hostUid == myUid;
});

// =============================================================================
// Voting State Provider
// =============================================================================

/// 投票状態管理のNotifier
class VotingStateNotifier extends StateNotifier<VotingState> {
  VotingStateNotifier(this._ref) : super(const VotingState()) {
    _startTimer();
  }

  // ignore: unused_field
  final Ref _ref;
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
  void _flushQueue() {
    if (state.sendQueue.isEmpty) return;

    final queueToSend = Map<String, int>.from(state.sendQueue);

    // TODO: infra層完成後に以下のように実装
    // final sessionId = _ref.read(currentSessionIdProvider);
    // final repository = _ref.read(votingRepositoryProvider);
    // repository.incrementVotes(sessionId, queueToSend);

    debugPrint('📤 Flushing vote queue: $queueToSend');

    state = state.copyWith(
      sendQueue: {},
      lastFlushTime: DateTime.now(),
    );
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

/// 投票状態Provider
final AutoDisposeStateNotifierProvider<VotingStateNotifier, VotingState>
votingStateProvider =
    StateNotifierProvider.autoDispose<VotingStateNotifier, VotingState>((ref) {
      return VotingStateNotifier(ref);
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
