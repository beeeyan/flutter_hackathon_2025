import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routing/go_router.dart';

class RoomLobbyPage extends HookConsumerWidget {
  const RoomLobbyPage({super.key});

  static const name = 'room_lobby';
  static const path = '/room_lobby';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: ホストかゲストかを判定する処理を追加
    final isHost = useState(true); // 仮の値

    return Scaffold(
      appBar: AppBar(
        title: const Text('ルーム待機室'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ルーム待機室（ロビー）'),
            const SizedBox(height: 32),
            // TODO: 参加者一覧（名前・アイコン・bio）のリアルタイム表示を追加
            if (isHost.value) ...[
              // TODO: QR コード/ID 表示を追加
              ElevatedButton(
                onPressed: () {
                  const VotingPageRoute().go(context);
                },
                child: const Text('投票開始'),
              ),
            ] else ...[
              const Text('ホストが開始するのを待っています'),
            ],
          ],
        ),
      ),
    );
  }
}
