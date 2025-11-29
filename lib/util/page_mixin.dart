import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'loading_state_provider.dart';

// 二重タップ防止のためのmixin
mixin PageMixin {
  Future<void> execute(
    BuildContext context,
    WidgetRef ref, {
    required AsyncCallback action,
    AsyncCallback? onComplete,
    Future<void> Function(Exception)? onExceptionCatch,
  }) async {
    try {
      ref.read(loadingStateProvider.notifier).startLoading();

      await action();

      ref.read(loadingStateProvider.notifier).endLoading();

      await onComplete?.call();
    } on Exception catch (e) {
      ref.read(loadingStateProvider.notifier).endLoading();

      if (onExceptionCatch != null) {
        await onExceptionCatch(e);
      }
    }
  }
}
