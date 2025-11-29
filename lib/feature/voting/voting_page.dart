import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routing/go_router.dart';
import '../session/infra/session_repository.dart';
import 'application/state/voting_provider.dart';
import 'presentation/game/myaku_game.dart';

class VotingPage extends HookConsumerWidget {
  const VotingPage({super.key, required this.qrCode});

  static const name = 'voting';
  static const path = '/voting';

  final String qrCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ゲームインスタンスを保持
    final game = useMemoized(MyakuGame.new, const []);

    // セッションIDを取得
    final sessionId = ref.watch(currentSessionIdProvider(qrCode));

    // 投票状態を監視
    final votingState = ref.watch(votingStateProvider(sessionId));

    // メンバー一覧を監視
    final membersAsync = ref.watch(membersStreamProvider(qrCode));

    // セッション状態を監視（status変更で画面遷移）
    final sessionAsync = ref.watch(sessionStreamProvider(qrCode));

    // ホストかどうか
    final isHost = ref.watch(isHostProvider(qrCode));

    // 自分のメンバー情報を監視（被投票数の変化検知用）
    final myMemberAsync = ref.watch(myMemberStreamProvider(qrCode));

    // 自分のUID
    final myUid = ref.watch(currentUserUidProvider);

    // ゲームのタップコールバックを設定
    useEffect(
      () {
        game.onTapUserCallback = (uid) {
          ref.read(votingStateProvider(sessionId).notifier).onTap(uid);
        };
        return null;
      },
      [game, sessionId],
    );

    // メンバー一覧が取得できたらゲームに追加
    useEffect(
      () {
        membersAsync.whenData((members) {
          if (game.getAllMemberBodies().isEmpty && members.isNotEmpty) {
            game.addMembers(members, myUid: myUid);
          }
        });
        return null;
      },
      [membersAsync, myUid],
    );

    // 自分への投票数が変化したらボールサイズを更新
    useEffect(
      () {
        myMemberAsync.whenData((myMember) {
          if (myMember != null) {
            game.updateAllMemberSizes(myMember.bySender);
          }
        });
        return null;
      },
      [myMemberAsync],
    );

    // タイムアップ時の処理
    useEffect(
      () {
        if (votingState.isTimeUp) {
          game.stopInteraction();
        }
        return null;
      },
      [votingState.isTimeUp],
    );

    // セッションステータスが'result'になったら画面遷移
    useEffect(
      () {
        sessionAsync.whenData((session) {
          if (session != null && session.status == 'result') {
            ResultPageRoute(qrCode: qrCode).go(context);
          }
        });
        return null;
      },
      [sessionAsync],
    );

    return Scaffold(
      body: Stack(
        children: [
          // E03: 物理演算ワールド（最背面）
          Positioned.fill(
            child: GameWidget(game: game),
          ),

          // E01: 残り時間タイマー（上部中央）
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Center(
              child: _TimerDisplay(
                remainingSeconds: votingState.remainingSeconds,
              ),
            ),
          ),

          // E02: 残り持ち点カウンター（上部右）
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: _PointsDisplay(
              remainingPoints: votingState.remainingPoints,
            ),
          ),

          // E06〜09: 終了オーバーレイ
          if (votingState.isTimeUp)
            _TimeUpOverlay(
              isHost: isHost,
              onResultPressed: () async {
                await ref.read(sessionRepositoryProvider).endSession(qrCode);
              },
            ),
        ],
      ),
    );
  }
}

/// E01: 残り時間タイマー表示
class _TimerDisplay extends StatelessWidget {
  const _TimerDisplay({required this.remainingSeconds});

  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final isUrgent = remainingSeconds <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isUrgent
            ? Colors.red.withValues(alpha: 0.9)
            : Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        timeString,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// E02: 残り持ち点表示
class _PointsDisplay extends StatelessWidget {
  const _PointsDisplay({required this.remainingPoints});

  final int remainingPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.pinkAccent,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '残り $remainingPoints 回',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// E06〜E09: 終了オーバーレイ
class _TimeUpOverlay extends StatelessWidget {
  const _TimeUpOverlay({
    required this.isHost,
    required this.onResultPressed,
  });

  final bool isHost;
  final VoidCallback onResultPressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // E07: 終了ラベル
            const Text(
              'TIME UP!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // E08 or E09: ホスト/ゲストで表示分岐
            if (isHost)
              ElevatedButton(
                onPressed: onResultPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  '結果を見る',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              const Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ホストが結果を表示するのを\n待っています...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
