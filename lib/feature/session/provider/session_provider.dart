import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/session.dart';
import '../infra/session_repository.dart';

/// セッション作成処理
final FutureProviderFamily<Session, String?> createSessionProvider =
    FutureProvider.family<Session, String?>((ref, sessionName) async {
      final repository = ref.read(sessionRepositoryProvider);
      return repository.createSession(sessionName: sessionName);
    });

/// QRコードでセッション取得
// MEMO(beeeyan): watchSessionProviderで足りるのではないかと思っている。
final FutureProviderFamily<Session?, String> getSessionByQRCodeProvider =
    FutureProvider.family<Session?, String>((ref, qrCode) {
      final repository = ref.read(sessionRepositoryProvider);
      return repository.getSessionByQRCode(qrCode);
    });

/// セッション状態監視プロバイダー
final StreamProviderFamily<Session?, String> watchSessionProvider =
    StreamProvider.family<Session?, String>((ref, qrCode) {
      final repository = ref.read(sessionRepositoryProvider);
      return repository.watchSession(qrCode);
    });

/// セッション操作用のAsyncNotifier
class SessionNotifier extends AsyncNotifier<Session?> {
  @override
  FutureOr<Session?> build() {
    // 初期状態はnull
    return null;
  }

  SessionRepository get _repository => ref.read(sessionRepositoryProvider);

  /// セッションを作成してQRコードを生成
  Future<Session> createSession({String? sessionName}) async {
    state = const AsyncValue.loading();
    try {
      final session = await _repository.createSession(sessionName: sessionName);
      state = AsyncValue.data(session);

      return session;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// QRコードからセッション取得
  Future<Session?> getSessionByQRCode(String qrCode) async {
    state = const AsyncValue.loading();
    try {
      final session = await _repository.getSessionByQRCode(qrCode);
      state = AsyncValue.data(session);

      return session;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// セッション開始
  Future<void> startSession(String qrCode) async {
    try {
      await _repository.startSession(qrCode);
      // セッション状態が変更されたので現在のセッションを再取得
      final currentSession = state.value;
      if (currentSession != null) {
        final updatedSession = currentSession.copyWith(status: 'active');
        state = AsyncValue.data(updatedSession);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// セッション終了
  Future<void> endSession(String qrCode) async {
    try {
      await _repository.endSession(qrCode);
      // セッション状態が変更されたので現在のセッションを再取得
      final currentSession = state.value;
      if (currentSession != null) {
        final updatedSession = currentSession.copyWith(status: 'result');
        state = AsyncValue.data(updatedSession);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// セッション名更新
  Future<void> updateSessionName(String qrCode, String name) async {
    try {
      await _repository.updateSessionName(qrCode, name);
      // セッション名が変更されたので現在のセッションを更新
      final currentSession = state.value;
      if (currentSession != null) {
        final updatedSession = currentSession.copyWith(name: name);
        state = AsyncValue.data(updatedSession);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// セッション情報をクリア
  void clearSession() {
    state = const AsyncValue.data(null);
  }
}

/// セッション操作プロバイダー
final sessionNotifierProvider =
    AsyncNotifierProvider<SessionNotifier, Session?>(() {
      return SessionNotifier();
    });

/// セッション作成・操作用のコントローラープロバイダー
final sessionControllerProvider = Provider<SessionController>((ref) {
  return SessionController(ref);
});

class SessionController {
  SessionController(this._ref);

  final Ref _ref;

  /// QRコード発行
  Future<Session> issueQRCode({String? sessionName}) async {
    final notifier = _ref.read(sessionNotifierProvider.notifier);
    final session = await notifier.createSession(sessionName: sessionName);

    return session;
  }

  /// QRコード読み込み
  Future<Session?> readQRCode(String qrCode) async {
    final notifier = _ref.read(sessionNotifierProvider.notifier);
    final session = await notifier.getSessionByQRCode(qrCode);

    return session;
  }

  /// 開始ボタン押下
  Future<void> startSession() async {
    final currentSession = _ref.read(sessionNotifierProvider).value;
    if (currentSession == null) {
      throw Exception('No current session');
    }

    final notifier = _ref.read(sessionNotifierProvider.notifier);
    await notifier.startSession(currentSession.qrCode);
  }

  /// ホストが終了ボタン押下
  Future<void> endSession() async {
    final currentSession = _ref.read(sessionNotifierProvider).value;
    if (currentSession == null) {
      throw Exception('No current session');
    }

    final notifier = _ref.read(sessionNotifierProvider.notifier);
    await notifier.endSession(currentSession.qrCode);
  }

  /// セッション名更新
  Future<void> updateSessionName(String name) async {
    final currentSession = _ref.read(sessionNotifierProvider).value;
    if (currentSession == null) {
      throw Exception('No current session');
    }

    final notifier = _ref.read(sessionNotifierProvider.notifier);
    await notifier.updateSessionName(currentSession.qrCode, name);
  }

  /// セッション情報をクリア
  void clearSession() {
    final notifier = _ref.read(sessionNotifierProvider.notifier);
    notifier.clearSession();
  }

  /// 現在のQRコードを取得
  String? getCurrentQRCode() {
    final session = _ref.read(sessionNotifierProvider).value;
    return session?.qrCode;
  }

  /// 現在のセッションを取得
  Session? getCurrentSession() {
    return _ref.read(sessionNotifierProvider).value;
  }
}
