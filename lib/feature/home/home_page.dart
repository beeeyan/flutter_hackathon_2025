import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routing/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const name = 'home_page';
  static const path = '/home_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ホーム画面'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: ルームを作成する処理を追加
                const RoomLobbyPageRoute().push<void>(context);
              },
              child: const Text('ルームを作成'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                const JoinRoomPageRoute().push<void>(context);
              },
              child: const Text('ルームに参加'),
            ),
          ],
        ),
      ),
    );
  }
}
