import 'package:hooks_riverpod/hooks_riverpod.dart';

final loadingStateProvider = NotifierProvider<LoadingNotifier, bool>(
  LoadingNotifier.new,
);

class LoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // 初期値
  }

  void startLoading() {
    state = true;
  }

  void endLoading() {
    state = false;
  }
}
