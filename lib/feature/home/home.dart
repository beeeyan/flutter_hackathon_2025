import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/state/auth_state.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  static const name = 'home';
  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);
    final authState = ref.watch(authStateProvider);

    void incrementCounter() {
      counter.value++;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('UID: ${authState.value?.uid}'),
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
