import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppIconAnimation extends StatefulWidget {
  const AppIconAnimation({super.key});

  @override
  State<AppIconAnimation> createState() => _AppIconAnimationState();
}

class _AppIconAnimationState extends State<AppIconAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hasVibrated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(); // ずっと流れ続ける

    // 中央到達時（t ≈ 0.5）でバイブレーション
    _controller.addListener(_onAnimationTick);
  }

  void _onAnimationTick() {
    final value = _controller.value;
    // 中央付近（0.48〜0.52）でバイブレーション発火
    if (value >= 0.48 && value <= 0.52 && !_hasVibrated) {
      HapticFeedback.mediumImpact();
      _hasVibrated = true;
    }
    // 範囲外に出たらリセット（次のサイクル用）
    if (value < 0.4 || value > 0.6) {
      _hasVibrated = false;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PulsePainter(animation: _controller),
      size: Size.infinite, // 親のサイズにフィット
    );
  }
}

class _PulsePainter extends CustomPainter {
  _PulsePainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value; // 0.0〜1.0

    final w = size.width;
    final h = size.height;

    final strokeWidth = h * 0.075;

    // SVGの座標を正規化（viewBox: 983 x 793）
    double x(double svgX) => w * (svgX / 983);
    double y(double svgY) => h * (svgY / 793);

    // ====== 左半分のパス ======
    // M30 442 → H251.5 → L323 288.5 → L356 350
    final leftPath = Path()
      ..moveTo(x(30), y(442))
      ..lineTo(x(251.5), y(442))
      ..lineTo(x(323), y(288.5))
      ..lineTo(x(356), y(350));

    // ====== 右半分のパス ======
    // M394 480 → L429 559 → L551 30 → L685 763 → L778.5 419.5 → H952.5
    final rightPath = Path()
      ..moveTo(x(394), y(480))
      ..lineTo(x(429), y(559))
      ..lineTo(x(551), y(30))
      ..lineTo(x(685), y(763))
      ..lineTo(x(778.5), y(419.5))
      ..lineTo(x(952.5), y(419.5));

    const baseColor = Color(0xFFCCCCCC);
    const highlightColor = Color(0xFF111111);

    // ====== グラデーション帯の計算 ======
    const bandWidth = 0.35;

    List<double> calcStops(double center) {
      final start = (center - bandWidth / 2).clamp(0.0, 1.0);
      final end = (center + bandWidth / 2).clamp(0.0, 1.0);
      final mid = (start + end) / 2;
      return [0.0, start, mid, end, 1.0];
    }

    // ハイライトが完全に外から入って外に出るように範囲を拡張
    // t=0 でハイライト全体が左外、t=1 でハイライト全体が右外
    const halfBand = bandWidth / 2;
    final leftCenter = -halfBand + t * (1.0 + bandWidth);
    final rightCenter = -halfBand + t * (1.0 + bandWidth);

    final leftStops = calcStops(leftCenter);
    final rightStops = calcStops(rightCenter);

    // 左半分用グラデーション（左 → 右に流れる）
    final leftGradient = LinearGradient(
      colors: const [
        baseColor,
        baseColor,
        highlightColor,
        baseColor,
        baseColor,
      ],
      stops: leftStops,
    );

    // 右半分用グラデーション（右 → 左に流れる）
    final rightGradient = LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: const [
        baseColor,
        baseColor,
        highlightColor,
        baseColor,
        baseColor,
      ],
      stops: rightStops,
    );

    // ====== 左半分を描画 ======
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = leftGradient.createShader(Rect.fromLTRB(x(30), 0, x(356), h));
    canvas.drawPath(leftPath, leftPaint);

    // ====== 右半分を描画 ======
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = rightGradient.createShader(
        Rect.fromLTRB(x(394), 0, x(952.5), h),
      );
    canvas.drawPath(rightPath, rightPaint);
  }

  @override
  bool shouldRepaint(covariant _PulsePainter oldDelegate) => false;
}
