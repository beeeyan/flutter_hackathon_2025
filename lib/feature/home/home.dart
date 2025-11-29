import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/application/state/auth_state.dart';
import '../user/domain/users.dart';
import '../user/infra/user_repository.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  static const name = 'home';
  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);
    final authState = ref.watch(authStateProvider);
    final user = useState<Users?>(null);

    void incrementCounter() {
      counter.value++;
    }

    useEffect(() {
      () async {
        user.value = await ref.watch(userRepositoryProvider).getUser();
      }();
      return;
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('UID: ${authState.value?.uid}'),
            Text('Nickname: ${user.value?.nickname}'),
            Text('Bio: ${user.value?.bio}'),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
