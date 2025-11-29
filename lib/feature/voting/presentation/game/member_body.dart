import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

/// 参加者ボール（物理演算オブジェクト）
class MemberBody extends BodyComponent {
  MemberBody({
    required this.uid,
    required this.nickname,
    required Vector2 initialPosition,
    this.avatarImage,
  }) : _initialPosition = initialPosition;

  /// ユーザーUID
  final String uid;

  /// ニックネーム
  final String nickname;

  /// アバター画像（非同期でロード）
  ui.Image? avatarImage;

  /// 初期位置
  final Vector2 _initialPosition;

  /// 基本半径（メートル換算）
  static const double baseRadius = 3;

  /// 現在の半径
  double currentRadius = baseRadius;

  /// 最大半径（上限）
  static const double maxRadius = 10;

  /// 巨大化係数
  static const double growthFactor = 0.1;

  /// ボディを所有していることを示すフラグ
  bool _bodyCreated = false;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: _initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);
    _createFixture(body, currentRadius);
    _bodyCreated = true;

    return body;
  }

  /// Fixtureを作成
  void _createFixture(Body targetBody, double radius) {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(
      shape,
      friction: 0.3,
      restitution: 0.4,
    );
    targetBody.createFixture(fixtureDef);
  }

  /// サイズを更新（投票数に応じて巨大化）
  void updateSize(int tapCount) {
    if (!_bodyCreated) return;

    final newRadius = min(
      baseRadius + (tapCount * growthFactor),
      maxRadius,
    );

    if ((newRadius - currentRadius).abs() < 0.01) return;

    currentRadius = newRadius;

    // 既存のFixtureを削除
    while (body.fixtures.isNotEmpty) {
      body.destroyFixture(body.fixtures.first);
    }

    // 新しいサイズのFixtureを作成
    _createFixture(body, currentRadius);
  }

  @override
  void render(Canvas canvas) {
    // 円形のクリッピングパス
    final screenRadius = currentRadius * 10; // ズームに応じて調整
    final rect = Rect.fromCircle(center: Offset.zero, radius: screenRadius);

    canvas.save();

    // 円形にクリップ
    final clipPath = Path()..addOval(rect);
    canvas.clipPath(clipPath);

    if (avatarImage != null) {
      // アバター画像を描画
      final srcRect = Rect.fromLTWH(
        0,
        0,
        avatarImage!.width.toDouble(),
        avatarImage!.height.toDouble(),
      );
      canvas.drawImageRect(avatarImage!, srcRect, rect, Paint());
    } else {
      // プレースホルダー（グレー円）
      canvas.drawOval(
        rect,
        Paint()..color = Colors.grey.shade400,
      );

      // ニックネームの頭文字
      final textPainter = TextPainter(
        text: TextSpan(
          text: nickname.isNotEmpty ? nickname[0] : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenRadius * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          -textPainter.width / 2,
          -textPainter.height / 2,
        ),
      );
    }

    canvas.restore();

    // 外枠
    canvas.drawCircle(
      Offset.zero,
      screenRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  /// アバター画像を設定
  void setAvatarImage(ui.Image image) {
    avatarImage = image;
  }
}
