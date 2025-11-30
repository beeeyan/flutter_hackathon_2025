import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../config/app_sizes.dart';
import '../../config/theme/theme_extension.dart';
import '../../routing/go_router.dart';
import '../../util/page_mixin.dart';
import '../../widgets/app_filled_button.dart';
import '../../widgets/app_profile_icon.dart';
import '../session/provider/member_provider.dart';
import '../session/provider/session_provider.dart';
import '../user/application/state/current_user_provider.dart';
import 'widget/app_icon_animation.dart';

class HomePage extends ConsumerWidget with PageMixin {
  const HomePage({super.key});

  static const name = 'home_page';
  static const path = '/home_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
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
                  title: Text(
                    user?.nickname ?? '',
                    style: appTextStyles.t14Medium.copyWith(
                      color: appColors.textMain,
                    ),
                  ),
                  subtitle: Text(
                    user?.bio ?? '',
                    style: appTextStyles.t12Regular.copyWith(
                      color: appColors.textSecondary,
                    ),
                  ),
                ),
                AppGaps.g8,
                Divider(
                  height: 1,
                  color: appColors.textSecondary,
                ),

                // Main content - Myaku logo and branding
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        SizedBox(
                          width: 160.w,
                          height: 160.w,
                          child: const AppIconAnimation(),
                        ),
                        SizedBox(height: 24.h),
                        // App name
                        Text(
                          'Myaku',
                          style: appTextStyles.t48Black.copyWith(
                            color: appColors.textMain,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Tagline
                        Text(
                          'TAP TO FEEL THE HEAT',
                          style: appTextStyles.t12Medium.copyWith(
                            color: appColors.textSecondary,
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
                              final sessionState = ref.read(
                                sessionNotifierProvider,
                              );
                              if (sessionState.hasValue &&
                                  sessionState.value != null) {
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
                          color: appColors.white,
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
                          color: appColors.black,
                        ),
                        text: 'ルームに参加する (ゲスト)',
                        height: 56,
                        textColor: appColors.black,
                        backgroundColor: appColors.white,
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
