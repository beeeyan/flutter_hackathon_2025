import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config/app_sizes.dart';
import '../../config/theme/theme_extension.dart';
import '../../routing/go_router.dart';
import '../../widgets/app_filled_button.dart';
import '../../widgets/app_profile_icon.dart';
import '../../widgets/app_text_form_field.dart';
import '../user/infra/user_repository.dart';

class ProfileSetupPage extends HookConsumerWidget {
  const ProfileSetupPage({super.key});

  static const name = 'profile_setup';
  static const path = '/profile_setup';

  // https://uifaces.co/から取得した画像URL
  static const iconUrls = [
    'https://mockmind-api.uifaces.co/content/human/80.jpg',
    'https://mockmind-api.uifaces.co/content/human/125.jpg',
    'https://mockmind-api.uifaces.co/content/human/222.jpg',
    'https://mockmind-api.uifaces.co/content/human/219.jpg',
    'https://mockmind-api.uifaces.co/content/human/104.jpg',
    'https://mockmind-api.uifaces.co/content/human/128.jpg',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
    final selectedIconUrl = useState<String>(iconUrls[0]);
    final nicknameController = useTextEditingController();
    final bioController = useTextEditingController();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィール設定'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
            child: Column(
              children: [
                AppGaps.g32,

                // アバター画像
                AppProfileIcon(
                  imageUrl: selectedIconUrl.value,
                  size: 128,
                ),

                AppGaps.g32,

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'またはデフォルトから選択',
                    style: appTextStyles.t14Medium.copyWith(
                      color: appColors.textSecondary,
                    ),
                  ),
                ),

                AppGaps.g8,

                // Wrapで6つの画像を表示
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSizes.s8,
                  children: List.generate(iconUrls.length, (index) {
                    // 選択された画像の場合は枠を表示
                    // 選択されていない画像はうっすら白いブラーをかける
                    final isSelected = iconUrls[index] == selectedIconUrl.value;
                    return GestureDetector(
                      onTap: () {
                        selectedIconUrl.value = iconUrls[index];
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 画像（常に48x48）
                          AppProfileIcon(
                            imageUrl: iconUrls[index],
                            size: AppSizes.s48,
                          ),
                          // 選択時：2pxの余白を設けた枠線（外側に表示）
                          if (isSelected)
                            Container(
                              width:
                                  AppSizes.s48 + AppSizes.s4, // 48 + 2*2 = 52
                              height: AppSizes.s48 + AppSizes.s4,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          // 未選択時：白いブラー
                          if (!isSelected)
                            Container(
                              width: AppSizes.s48,
                              height: AppSizes.s48,
                              decoration: BoxDecoration(
                                color: appColors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),

                AppGaps.g32,

                // nickname入力フォーム
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ニックネーム',
                    style: appTextStyles.t14Medium.copyWith(
                      color: appColors.textMain,
                    ),
                  ),
                ),

                AppTextFormField(
                  controller: nicknameController,
                  hintText: '例：タロウ',
                ),

                AppGaps.g32,

                // bio入力フォーム
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '自己紹介',
                    style: appTextStyles.t14Medium.copyWith(
                      color: appColors.textMain,
                    ),
                  ),
                ),

                AppTextFormField(
                  controller: bioController,
                  hintText: '任意（100文字以内）',
                  maxLines: null,
                  maxLength: 100,
                  minHeight: 120,
                ),

                AppFilledButton(
                  onPressed:
                      nicknameController.value.text.isEmpty ||
                          bioController.value.text.isEmpty
                      ? null
                      : () async {
                          await ref
                              .read(userRepositoryProvider)
                              .createUser(
                                iconUrl: selectedIconUrl.value,
                                nickname: nicknameController.text,
                                bio: bioController.text,
                              );
                          if (context.mounted) {
                            const HomePageRoute().go(context);
                          }
                        },
                  text: '設定を保存してはじめる',
                ),

                AppGaps.g64,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
