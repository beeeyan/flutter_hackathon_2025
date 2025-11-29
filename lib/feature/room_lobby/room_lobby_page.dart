import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../config/app_sizes.dart';
import '../../routing/go_router.dart';
import '../../util/page_mixin.dart';
import '../../widgets/app_filled_button.dart';
import '../../widgets/app_profile_icon.dart';
import '../auth/application/state/auth_state.dart';
import '../session/domain/member.dart';
import '../session/provider/member_provider.dart';
import '../session/provider/session_provider.dart';

class RoomLobbyPage extends ConsumerWidget with PageMixin {
  const RoomLobbyPage({
    super.key,
    required this.qrCode,
  });

  final String qrCode;

  static const name = 'room_lobby';
  static const path = '/room_lobby';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のユーザー認証状態を取得
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.value?.uid;

    // セッション情報を監視
    final sessionAsync = ref.watch(watchSessionProvider(qrCode));

    return sessionAsync.when(
      data: (session) {
        if (session == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('エラー')),
            body: const Center(
              child: Text('セッションが見つかりません'),
            ),
          );
        }

        // ホストかどうかを判定（現在のユーザーIDとセッションのhostUidを比較）
        final isHost = session.hostUid == currentUserId;

        // アクティブなメンバー一覧を監視
        final activeMembersAsync = ref.watch(
          watchActiveSessionMembersProvider(session.id!),
        );

        return activeMembersAsync.when(
          data: (members) => _buildLobbyContent(
            context,
            ref,
            session.qrCode,
            members,
            isHost,
            currentUserId ?? '',
          ),
          loading: _buildLoadingScaffold,
          error: (error, stackTrace) => _buildErrorScaffold(
            error.toString(),
            context,
          ),
        );
      },
      loading: _buildLoadingScaffold,
      error: (error, stackTrace) =>
          _buildErrorScaffold(error.toString(), context),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(title: const Text('読み込み中...')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScaffold(String error, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('エラー')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('エラーが発生しました: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                const HomePageRoute().go(context);
              },
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLobbyContent(
    BuildContext context,
    WidgetRef ref,
    String roomId,
    List<Member> members,
    bool isHost,
    String myUid,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('待機中...'),
        // ゲストの場合のみ退出ボタンを表示
        actions: [
          if (!isHost)
            IconButton(
              onPressed: () async {
                await execute(
                  context,
                  ref,
                  action: () async {
                    // セッションから退出
                    final memberController = ref.read(memberControllerProvider);
                    // セッション情報からsessionIdを取得
                    final sessionAsync = ref.read(watchSessionProvider(roomId));
                    final session = sessionAsync.value;
                    if (session != null) {
                      await memberController.leaveSession(session.id!);
                    }
                  },
                  onComplete: () async {
                    // ホームに戻る
                    if (context.mounted) {
                      const HomePageRoute().go(context);
                    }
                  },
                  onExceptionCatch: (e) async {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('退出に失敗しました: $e')),
                      );
                    }
                  },
                );
              },
              icon: const Icon(Icons.exit_to_app),
            ),
        ],
      ),
      body: Stack(
        children: [
          // スクロール可能なコンテンツ
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFECECF0).withValues(alpha: 0.2),
                  child: Column(
                    children: [
                      AppGaps.g16,
                      // QRコード
                      Container(
                        padding: const EdgeInsets.all(AppSizes.s16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSizes.s16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 1,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: roomId,
                          size: 200.w,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      AppGaps.g16,
                      // ルームID表示とコピーボタン
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: roomId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('コピーしました'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.s16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ID: $roomId',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: AppSizes.s8),
                              Icon(
                                Symbols.content_copy,
                                size: 18.w,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppGaps.g24,
                    ],
                  ),
                ),
                // 区切り線
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s24,
                  ),
                  child: Column(
                    children: [
                      AppGaps.g16,
                      // 参加者数表示
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '参加者 (${members.length}人)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      AppGaps.g16,
                      // 参加者リスト
                      ...members.map(
                        (Member member) {
                          final isMe = member.uid == myUid;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.grey.shade100 : null,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AppProfileIcon(
                                    imageUrl: member.iconUrl,
                                    size: 48.w,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              member.nickname,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if (isMe) ...[
                                              const SizedBox(
                                                width: AppSizes.s8,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: AppSizes.s8,
                                                      vertical: AppSizes.s2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10,
                                                      ),
                                                ),
                                                child: Text(
                                                  'YOU',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: AppSizes.s4),
                                        Text(
                                          member.bio,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // ボタン分のスペースを確保
                      const SizedBox(height: 160),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 下部に固定表示されるボタン
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.s24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: isHost
                    ? AppFilledButton(
                        onPressed: () {
                          const VotingPageRoute().go(context);
                        },
                        text: '投票をスタートする！',
                        height: 56,
                      )
                    : Container(
                        padding: const EdgeInsets.all(AppSizes.s16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'ホストが開始するのを待っています...',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
