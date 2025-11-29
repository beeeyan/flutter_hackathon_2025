import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../config/app_sizes.dart';
import '../../routing/go_router.dart';
import '../../widgets/app_filled_button.dart';
import '../../widgets/app_profile_icon.dart';

class RoomLobbyPage extends HookConsumerWidget {
  const RoomLobbyPage({super.key});

  static const name = 'room_lobby';
  static const path = '/room_lobby';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: ホストかゲストかを判定する処理を追加
    final isHost = useState(true); // 仮の値
    // TODO: ルームIDを実際のデータから取得
    const roomId = 'RM4394';
    // TODO: 参加者一覧をFirestoreから取得
    final participants = useState<List<Participant>>([
      const Participant(
        name: '自分',
        bio: '今日はよろしくお願いします!',
        iconUrl: 'https://i.pravatar.cc/150?img=1',
        isMe: true,
      ),
      const Participant(
        name: 'ハナコ',
        bio: 'お酒好きです',
        iconUrl: 'https://i.pravatar.cc/150?img=2',
        isMe: false,
      ),
      const Participant(
        name: 'ケン',
        bio: '趣味はキャンプ',
        iconUrl: 'https://i.pravatar.cc/150?img=3',
        isMe: false,
      ),
      const Participant(
        name: 'ユウキ',
        bio: '遅れてすみません',
        iconUrl: 'https://i.pravatar.cc/150?img=4',
        isMe: false,
      ),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('待機中...'),
        // 右側に退出ボタンを追加
        actions: [
          IconButton(
            onPressed: () {
              const HomePageRoute().go(context);
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
                          Clipboard.setData(const ClipboardData(text: roomId));
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
                          '参加者 (${participants.value.length}人)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      AppGaps.g16,
                      // 参加者リスト
                      ...participants.value.map(
                        (participant) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: participant.isMe
                                    ? Colors.grey.shade100
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AppProfileIcon(
                                    imageUrl: participant.iconUrl,
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
                                              participant.name,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if (participant.isMe) ...[
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
                                          participant.bio,
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
                child: isHost.value
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

// 参加者データのモデル（仮実装）
class Participant {
  const Participant({
    required this.name,
    required this.bio,
    required this.iconUrl,
    required this.isMe,
  });

  final String name;
  final String bio;
  final String iconUrl;
  final bool isMe;
}
