import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/session.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(FirebaseFirestore.instance);
});

class SessionRepository {
  const SessionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// QRコード発行 - セッションを作成し、QRコードを生成
  Future<Session> createSession({String? sessionName}) async {
    try {
      debugPrint('Creating new session with name: $sessionName');
      
      // TODO(beeeyan): 他とuidの取り出し方が異なる気はするので最終確認
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not authenticated');
        throw Exception('User not authenticated');
      }

      // QRコード生成（SES-XXXX-XXXX形式）
      final qrCode = _generateQRCode();
      final now = DateTime.now();

      debugPrint('Generated QR code: $qrCode');

      final session = Session(
        name: sessionName,
        hostUid: user.uid,
        qrCode: qrCode,
        joinedAt: now,
        lastActiveAt: now,
      );

      // Firestoreに保存
      final docRef = _firestore.collection('sessions').doc();
      await docRef.set(session.toJson());

      debugPrint('Session created successfully with ID: ${docRef.id}');

      return session.copyWith(id: docRef.id);
    } catch (e) {
      debugPrint('Failed to create session: $e');
      throw Exception('Failed to create session: $e');
    }
  }

  /// QRコードでセッション取得 - QRコードのデータを取得
  Future<Session?> getSessionByQRCode(String qrCode) async {
    try {
      debugPrint('Getting session by QR code: $qrCode');
      
      final querySnapshot = await _firestore
          .collection('sessions')
          .where('qrCode', isEqualTo: qrCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('No session found for QR code: $qrCode');
        return null;
      }

      final doc = querySnapshot.docs.first;
      final sessionData = {
        ...doc.data(),
        'id': doc.id,
      };
      
      debugPrint('Session found: ${doc.id}');
      return Session.fromJson(sessionData);
    } catch (e) {
      debugPrint('Failed to get session by QR code: $e');
      throw Exception('Failed to get session by QR code: $e');
    }
  }

  /// 開始ボタン押下 - セッションのステータスをactiveに更新
  Future<void> startSession(String qrCode) async {
    try {
      debugPrint('Starting session with QR code: $qrCode');
      
      // QRコードでセッション取得
      final session = await getSessionByQRCode(qrCode);
      if (session?.id == null) {
        debugPrint('Session not found for QR code: $qrCode');
        throw Exception('Session not found');
      }

      await _firestore.collection('sessions').doc(session!.id).update({
        'status': 'active',
      });
      
      debugPrint('Session started successfully: ${session.id}');
    } catch (e) {
      debugPrint('Failed to start session: $e');
      throw Exception('Failed to start session: $e');
    }
  }

  /// ホストが終了ボタン押下 - セッションのステータスをresultに更新
  Future<void> endSession(String qrCode) async {
    try {
      debugPrint('Ending session with QR code: $qrCode');
      
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not authenticated');
        throw Exception('User not authenticated');
      }

      // QRコードでセッション取得
      final session = await getSessionByQRCode(qrCode);
      if (session?.id == null) {
        debugPrint('Session not found for QR code: $qrCode');
        throw Exception('Session not found');
      }

      // ホストかどうか確認
      if (session!.hostUid != user.uid) {
        debugPrint('User ${user.uid} is not the host of session ${session.id}');
        throw Exception('Only host can end the session');
      }

      await _firestore.collection('sessions').doc(session.id).update({
        'status': 'result',
      });
      
      debugPrint('Session ended successfully: ${session.id}');
    } catch (e) {
      debugPrint('Failed to end session: $e');
      throw Exception('Failed to end session: $e');
    }
  }

  /// セッションの状態変更をリッスン（QRコードベース）
  Stream<Session?> watchSession(String qrCode) {
    debugPrint('Watching session with QR code: $qrCode');
    
    return _firestore
        .collection('sessions')
        .where('qrCode', isEqualTo: qrCode)
        .limit(1)
        .snapshots()
        .asyncMap((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        debugPrint('No session found for QR code during watch: $qrCode');
        return null;
      }

      final doc = querySnapshot.docs.first;
      final sessionData = {
        ...doc.data(),
        'id': doc.id,
      };
      
      debugPrint('Session data updated: ${doc.id}');
      return Session.fromJson(sessionData);
    }).handleError((Object error) {
      debugPrint('Error watching session: $error');
      return null;
    });
  }

  /// セッション名を更新（QRコードベース）
  /// ※ 今のところ使っていない
  Future<void> updateSessionName(String qrCode, String name) async {
    try {
      debugPrint('Updating session name for QR code: $qrCode, new name: $name');
      
      // QRコードでセッション取得
      final session = await getSessionByQRCode(qrCode);
      if (session?.id == null) {
        debugPrint('Session not found for QR code: $qrCode');
        throw Exception('Session not found');
      }

      await _firestore.collection('sessions').doc(session!.id).update({
        'name': name,
      });
      
      debugPrint('Session name updated successfully: ${session.id}');
    } catch (e) {
      debugPrint('Failed to update session name: $e');
      throw Exception('Failed to update session name: $e');
    }
  }

  /// QRコード生成（SES-XXXX-XXXX形式）
  String _generateQRCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    String generateSegment() {
      return List.generate(
        4,
        (index) => characters[random.nextInt(characters.length)],
      ).join();
    }

    return 'SES-${generateSegment()}-${generateSegment()}';
  }
}
