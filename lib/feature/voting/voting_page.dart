import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routing/go_router.dart';

class VotingPage extends ConsumerWidget {
  const VotingPage({super.key});

  static const name = 'voting';
  static const path = '/voting';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投票'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('投票メイン画面'),
            const SizedBox(height: 32),
            // TODO: 制限時間のカウントダウンを追加
            // TODO: 参加者一覧と投票ボタン（連打 UI）を追加
            ElevatedButton(
              onPressed: () {
                // TODO: 投票終了時の処理を追加
                const ResultPageRoute().go(context);
              },
              child: const Text('投票終了（テスト用）'),
            ),
          ],
        ),
      ),
    );
  }
}
