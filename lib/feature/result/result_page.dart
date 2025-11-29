import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../config/app_sizes.dart';
import '../../config/theme/theme_extension.dart';
import '../../routing/go_router.dart';
import '../../widgets/app_outlined_button.dart';
import '../../widgets/app_profile_icon.dart';
import '../session/domain/member.dart';
import '../voting/application/state/voting_provider.dart';

class ResultPage extends HookConsumerWidget {
  const ResultPage({super.key, required this.qrCode});

  static const name = 'result';
  static const path = '/result';

  final String qrCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MEMO: 以下はVotingPage用のProviderから取得している
    // メンバー一覧を監視
    final membersAsync = ref.watch(membersStreamProvider(qrCode));

    // 自分のメンバー情報を監視
    final myMemberAsync = ref.watch(myMemberStreamProvider(qrCode));

    // 自分が最も投票した相手
    final topVotedTarget = useMemoized<Member?>(() {
      final myMember = myMemberAsync.value;
      if (myMember == null || myMember.sended.isEmpty) {
        return null;
      }
      final sortedEntries = myMember.sended.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topVotedUid = sortedEntries.first.key;
      final members = membersAsync.value;
      if (members == null) {
        return null;
      }
      return members.firstWhere(
        (member) => member.uid == topVotedUid,
      );
    }, [myMemberAsync.value]);

    // _topVotedMemberが最も投票した相手のメンバーが自分かどうか（マッチしたかどうか）
    final isMatched = useMemoized<bool>(() {
      final members = membersAsync.value;
      if (members == null || topVotedTarget == null) {
        return false;
      }
      final topVotedMember = members.firstWhere(
        (member) => member.uid == topVotedTarget.uid,
      );
      // topVotedMemberが自分を最も投票しているか確認
      final theirTopVotedUid = topVotedMember.sended.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      if (theirTopVotedUid.isEmpty) {
        return false;
      }
      return theirTopVotedUid.first.key == myMemberAsync.value?.uid;
    }, [membersAsync.value, myMemberAsync.value, topVotedTarget]);

    // マッチしたMemberの情報
    final matchedUserName = topVotedTarget?.nickname ?? '';
    final matchedUserIconUrl = topVotedTarget?.iconUrl ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('運命の結果'),
      ),
      body: isMatched
          ? _buildMatchBody(context, matchedUserName, matchedUserIconUrl)
          : _buildNoMatchBody(
              context,
              myMemberAsync.value,
              membersAsync.value,
            ),
    );
  }

  Widget _buildMatchBody(
    BuildContext context,
    String matchedUserName,
    String matchedUserIconUrl,
  ) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
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
                      color: appColors.yellow,
                      width: 3.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: appColors.yellow.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 20,
                      ),
                      BoxShadow(
                        color: appColors.yellow.withValues(alpha: 0.2),
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
                    decoration: BoxDecoration(
                      color: appColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: appColors.white,
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
              style: appTextStyles.t30Black.copyWith(
                color: appColors.textMain,
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
                        style: appTextStyles.t20Bold.copyWith(
                          color: appColors.textMain,
                        ),
                      ),
                      TextSpan(
                        text: 'さんと',
                        style: appTextStyles.t18Medium.copyWith(
                          color: appColors.textMain,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'マッチング成立！',
                  style: appTextStyles.t18Medium.copyWith(
                    color: appColors.textMain,
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
                color: appColors.black,
              ),
              text: 'ホームへ戻る',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatchBody(
    BuildContext context,
    Member? myMember,
    List<Member>? members,
  ) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
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
              decoration: BoxDecoration(
                color: appColors.containerFill.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 48,
                color: appColors.textSecondary,
              ),
            ),
            AppGaps.g24,
            // 「残念... マッチングならず」テキスト
            Text(
              '残念...マッチングならず',
              style: appTextStyles.t20Bold.copyWith(
                color: appColors.textSecondary,
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
                      color: appColors.containerFill.withValues(alpha: 0.2),
                      border: Border.all(
                        color: appColors.textSecondary,
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
                          color: appColors.pink,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'あなたに投票した人',
                          style: appTextStyles.t16Bold.copyWith(
                            color: appColors.textMain,
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
                            color: appColors.textSecondary,
                          ),
                          right: BorderSide(
                            color: appColors.textSecondary,
                          ),
                          bottom: BorderSide(
                            color: appColors.textSecondary,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child:
                          myMember != null &&
                              myMember.sended.isNotEmpty &&
                              members != null &&
                              members.isNotEmpty
                          ? _buildVotersList(
                              context,
                              myMember,
                              members,
                            )
                          : _buildNoVotesMessage(context),
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
                color: appColors.black,
              ),
              text: 'ホームへ戻る',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoVotesMessage(BuildContext context) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;
    return Center(
      child: Text(
        'まだ投票はありませんでした...',
        style: appTextStyles.t16Regular.copyWith(
          color: appColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildVotersList(
    BuildContext context,
    Member myMember,
    List<Member> members,
  ) {
    final appColors = Theme.of(context).appColors;
    final appTextStyles = Theme.of(context).appTextStyles;

    final voters = members.map((member) {
      // 自分は除外
      if (member.uid == myMember.uid) {
        return null;
      }

      // 自分に投票していない人は除外
      if (member.sended[myMember.uid] == null) {
        return null;
      }

      // 自分への投票数を取得
      return Voter(
        uid: member.uid,
        nickname: member.nickname,
        iconUrl: member.iconUrl,
        voteCount: member.sended[myMember.uid]!,
      );
    }).toList();

    // votersを投票数で降順にソート
    if (voters.isNotEmpty) {
      voters.sort((a, b) => (b?.voteCount ?? 0).compareTo(a?.voteCount ?? 0));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.s16),
      itemCount: voters.length,
      separatorBuilder: (context, index) => Divider(
        height: 24,
        thickness: 1,
        color: appColors.textSecondary,
        endIndent: 0,
      ),
      itemBuilder: (context, index) {
        final voter = voters[index];
        return Row(
          children: [
            AppProfileIcon(
              imageUrl: voter?.iconUrl ?? '',
              size: 48.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voter?.nickname ?? '',
                    style: appTextStyles.t16Bold.copyWith(
                      color: appColors.textMain,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 14.w,
                        color: appColors.pink,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${voter?.voteCount ?? ''}回',
                        style: appTextStyles.t14Regular.copyWith(
                          color: appColors.textSecondary,
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
