import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routing/go_router.dart';

class JoinRoomPage extends ConsumerWidget {
  const JoinRoomPage({super.key});

  static const name = 'join_room';
  static const path = '/join_room';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ルームに参加'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ルーム参加入力画面'),
            const SizedBox(height: 32),
            // TODO: QR コードスキャナーまたはルーム ID 手動入力フォームを追加
            ElevatedButton(
              onPressed: () {
                // TODO: 有効な ID かどうかを確認する処理を追加
                const RoomLobbyPageRoute().go(context);
              },
              child: const Text('参加する'),
            ),
          ],
        ),
      ),
    );
  }
}
