import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routing/go_router.dart';
import '../user/infra/user_repository.dart';

class ProfileSetupPage extends ConsumerWidget {
  const ProfileSetupPage({super.key});

  static const name = 'profile_setup';
  static const path = '/profile_setup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール設定'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('プロフィール設定画面'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(userRepositoryProvider)
                    .createUser(
                      iconUrl: 'https://placehold.jp/150x150.png',
                      nickname: 'テストユーザー',
                      bio: 'テストユーザーです',
                    );

                // TODO: User ドキュメントを作成する処理を追加
                const HomePageRoute().go(context);
              },
              child: const Text('設定を保存してはじめる'),
            ),
          ],
        ),
      ),
    );
  }
}
