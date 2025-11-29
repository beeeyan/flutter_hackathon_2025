import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../config/app_sizes.dart';
import '../../routing/go_router.dart';
import '../../util/page_mixin.dart';
import '../../widgets/app_filled_button.dart';
import '../../widgets/app_profile_icon.dart';
import '../session/provider/member_provider.dart';
import '../session/provider/session_provider.dart';
import '../user/application/state/current_user_provider.dart';

class HomePage extends ConsumerWidget with PageMixin {
  const HomePage({super.key});

  static const name = 'home_page';
  static const path = '/home_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          data: (user) {

            


            return Column(
              children: [
                // User profile section
                ListTile(
                  leading: AppProfileIcon(
                    imageUrl: user?.iconUrl ?? '',
                    size: 56.w,
                  ),
                  title: Text(user?.nickname ?? ''),
                  subtitle: Text(user?.bio ?? ''),
                ),
                AppGaps.g8,
                Divider(
                  height: 1,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),

                // Main content - Myaku logo and branding
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo circle
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF2C2C2C),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Symbols.favorite,
                            size: 64.w,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // App name
                        Text(
                          'Myaku',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1C1C1C),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Tagline
                        Text(
                          'TAP TO FEEL THE HEAT',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E8E),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Action buttons
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      AppFilledButton(
                        onPressed: () async {
                          await execute(
                            context,
                            ref,
                            action: () async {
                              final controller = ref.read(
                                sessionControllerProvider,
                              );
                              // セッションを作成してQRコードを取得
                              final session = await controller.issueQRCode();

                              if (user == null) {
                                throw Exception('ユーザー情報が見つかりません');
                              }

                              // 自分自身をホストとしてセッションに追加
                              final memberController = ref.read(
                                memberControllerProvider,
                              );
                              await memberController.joinSession(
                                sessionId: session.id!,
                                iconUrl: user.iconUrl,
                                nickname: user.nickname,
                                bio: user.bio,
                                role: 'host', // ホストとして追加
                              );
                            },
                            onComplete: () async {
                              // 最新のセッション情報を取得して遷移
                              final sessionState = ref.read(sessionNotifierProvider);
                              if (sessionState.hasValue && sessionState.value != null) {
                                await RoomLobbyPageRoute(
                                  qrCode: sessionState.value!.qrCode,
                                ).push<void>(context);
                              }
                            },
                            onExceptionCatch: (e) async {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('エラーが発生しました: $e')),
                                );
                              }
                            },
                          );
                        },
                        leading: Icon(
                          Symbols.group,
                          size: 24.w,
                          color: Colors.white,
                        ),
                        text: 'ルームを作成する (幹事)',
                        height: 56,
                      ),
                      AppGaps.g16,
                      AppFilledButton(
                        onPressed: () {
                          const JoinRoomPageRoute().push<void>(context);
                        },
                        leading: Icon(
                          Symbols.login,
                          size: 24.w,
                          color: Colors.black,
                        ),
                        text: 'ルームに参加する (ゲスト)',
                        height: 56,
                        textColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (e, s) => const Center(child: Text('エラーが発生しました')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
