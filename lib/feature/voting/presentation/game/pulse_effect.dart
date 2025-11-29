import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// タップ時のパルスエフェクト
class PulseEffect extends PositionComponent with HasPaint {
  PulseEffect({
    required Vector2 position,
    this.color = Colors.pinkAccent,
    this.duration = 0.5,
  }) : super(
         position: position,
         size: Vector2.all(40),
         anchor: Anchor.center,
       );

  /// エフェクトの色
  final Color color;

  /// アニメーション時間（秒）
  final double duration;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    paint = Paint()
      ..color = color.withValues(alpha: 1)
      ..style = PaintingStyle.fill;

    // スケールアニメーション: 0.5 → 1.5
    add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: duration),
      ),
    );

    // フェードアウトアニメーション
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: duration),
      ),
    );

    // アニメーション終了後に削除
    add(
      RemoveEffect(delay: duration),
    );

    // 初期スケール
    scale = Vector2.all(0.5);
  }

  @override
  void render(Canvas canvas) {
    // ハート形状を描画
    _drawHeart(canvas);
  }

  /// ハートを描画
  void _drawHeart(Canvas canvas) {
    final heartPath = Path();
    final w = size.x;
    final h = size.y;

    // ハートのパス
    heartPath.moveTo(w / 2, h * 0.3);
    heartPath.cubicTo(
      w * 0.1,
      h * 0.0,
      w * -0.1,
      h * 0.5,
      w / 2,
      h,
    );
    heartPath.moveTo(w / 2, h * 0.3);
    heartPath.cubicTo(
      w * 0.9,
      h * 0.0,
      w * 1.1,
      h * 0.5,
      w / 2,
      h,
    );

    canvas.drawPath(heartPath, paint);
  }
}

/// 波紋エフェクト（代替版）
class RippleEffect extends PositionComponent with HasPaint {
  RippleEffect({
    required Vector2 position,
    this.color = Colors.white,
    this.duration = 0.4,
  }) : super(
         position: position,
         size: Vector2.all(20),
         anchor: Anchor.center,
       );

  /// エフェクトの色
  final Color color;

  /// アニメーション時間（秒）
  final double duration;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // スケールアニメーション
    add(
      ScaleEffect.to(
        Vector2.all(3),
        EffectController(duration: duration),
      ),
    );

    // フェードアウト
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: duration),
      ),
    );

    // アニメーション終了後に削除
    add(
      RemoveEffect(delay: duration),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
  }
}
