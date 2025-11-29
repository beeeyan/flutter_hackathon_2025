import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routing/go_router.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key});

  static const name = 'result';
  static const path = '/result';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('結果発表'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('結果発表画面'),
            const SizedBox(height: 32),
            // TODO: マッチング成立ペアの演出表示を追加
            ElevatedButton(
              onPressed: () {
                const HomePageRoute().go(context);
              },
              child: const Text('ホームへ戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
