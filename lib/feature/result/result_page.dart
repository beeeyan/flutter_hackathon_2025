import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../config/app_sizes.dart';
import '../../routing/go_router.dart';
import '../../widgets/app_outlined_button.dart';
import '../../widgets/app_profile_icon.dart';

class ResultPage extends HookConsumerWidget {
  const ResultPage({super.key});

  static const name = 'result';
  static const path = '/result';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 実際のマッチしたユーザー情報を取得
    const matchedUserName = 'ハナコ';
    const matchedUserIconUrl = 'https://i.pravatar.cc/150?img=2';

    // マッチしているかどうか
    final isMatch = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('結果発表'),
      ),
      body: isMatch.value
          ? _buildMatchBody(context, matchedUserName, matchedUserIconUrl)
          : _buildNoMatchBody(context),
    );
  }

  Widget _buildMatchBody(
    BuildContext context,
    String matchedUserName,
    String matchedUserIconUrl,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            // プロフィール画像とハートアイコン
            Stack(
              alignment: Alignment.center,
              children: [
                // プロフィール画像
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFDC700),
                      width: 3.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFDC700).withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 20,
                      ),
                      BoxShadow(
                        color: const Color(0xFFFDC700).withValues(alpha: 0.2),
                        blurRadius: 60,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                  child: AppProfileIcon(
                    imageUrl: matchedUserIconUrl,
                    size: 160,
                  ),
                ),

                // ハートアイコン（右下に配置）
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDC700),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 28.w,
                    ),
                  ),
                ),
              ],
            ),
            AppGaps.g48,

            // CONGRATULATIONS! テキスト
            Text(
              'CONGRATULATIONS!',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF2C2C2C),
              ),
            ),
            SizedBox(height: 24.h),
            // 日本語テキスト
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: matchedUserName,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      TextSpan(
                        text: 'さんと',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'マッチング成立！',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // ホームへ戻るボタン
            AppOutlinedButton(
              onPressed: () {
                const HomePageRoute().go(context);
              },
              leading: Icon(
                Symbols.home,
                size: 20.w,
                color: const Color(0xFF2C2C2C),
              ),
              text: 'ホームへ戻る',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatchBody(BuildContext context) {
    // TODO: 実際の投票データを取得
    final voters = useState<List<Voter>>([
      const Voter(
        uid: '1',
        nickname: 'タロウ',
        iconUrl: 'https://i.pravatar.cc/150?img=1',
        voteCount: 5,
      ),
      const Voter(
        uid: '2',
        nickname: 'ハナコ',
        iconUrl: 'https://i.pravatar.cc/150?img=2',
        voteCount: 3,
      ),
      const Voter(
        uid: '3',
        nickname: 'ケン',
        iconUrl: 'https://i.pravatar.cc/150?img=3',
        voteCount: 2,
      ),
      const Voter(
        uid: '1',
        nickname: 'タロウ',
        iconUrl: 'https://i.pravatar.cc/150?img=1',
        voteCount: 5,
      ),
      const Voter(
        uid: '2',
        nickname: 'ハナコ',
        iconUrl: 'https://i.pravatar.cc/150?img=2',
        voteCount: 3,
      ),
      const Voter(
        uid: '3',
        nickname: 'ケン',
        iconUrl: 'https://i.pravatar.cc/150?img=3',
        voteCount: 2,
      ),
    ]);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
        child: Column(
          children: [
            SizedBox(height: 48.h),
            // 壊れたハートアイコン
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 48,
                color: Color(0xFF9E9E9E),
              ),
            ),
            AppGaps.g24,
            // 「残念... マッチングならず」テキスト
            Text(
              '残念... マッチングならず',
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF2C2C2C),
              ),
            ),
            AppGaps.g32,
            // 投票した人のカード
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.s16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 20.w,
                          color: const Color(0xFFFF69B4),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'あなたに投票した人',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          right: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: voters.value.isNotEmpty
                          ? _buildVotersList(voters.value)
                          : _buildNoVotesMessage(),
                    ),
                  ),
                ],
              ),
            ),
            AppGaps.g24,

            // ホームへ戻るボタン
            AppOutlinedButton(
              onPressed: () {
                const HomePageRoute().go(context);
              },
              leading: Icon(
                Symbols.home,
                size: 20.w,
                color: const Color(0xFF2C2C2C),
              ),
              text: 'ホームへ戻る',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoVotesMessage() {
    return Center(
      child: Text(
        'まだ投票はありませんでした...',
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  Widget _buildVotersList(List<Voter> voters) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.s16),
      itemCount: voters.length,
      separatorBuilder: (context, index) => Divider(
        height: 24,
        thickness: 1,
        color: Colors.grey.shade300,
        endIndent: 0,
      ),
      itemBuilder: (context, index) {
        final voter = voters[index];
        return Row(
          children: [
            AppProfileIcon(
              imageUrl: voter.iconUrl,
              size: 48.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voter.nickname,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 14.w,
                        color: const Color(0xFFFF69B4),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${voter.voteCount}回',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 投票した人の情報
class Voter {
  const Voter({
    required this.uid,
    required this.nickname,
    required this.iconUrl,
    required this.voteCount,
  });

  final String uid;
  final String nickname;
  final String iconUrl;
  final int voteCount;
}
