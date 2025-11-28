import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 認証リポジトリを提供するプロバイダー
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(firebaseAuth: FirebaseAuth.instance);
});

/// Firebase Authentication の認証リポジトリ
class AuthRepository {
  AuthRepository({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  /// 認証状態の変更を監視するストリーム
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  /// 匿名サインイン
  /// 既にサインイン済みの場合は何もしない
  Future<UserCredential?> signInAnonymously() async {
    // 既存のユーザーがいる場合は再サインインしない
    if (_firebaseAuth.currentUser != null) {
      return null;
    }
    return _firebaseAuth.signInAnonymously();
  }
}
