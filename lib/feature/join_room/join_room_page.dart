import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../config/app_sizes.dart';
import '../../routing/go_router.dart';
import '../../widgets/app_filled_button.dart';
import '../../widgets/app_text_form_field.dart';

class JoinRoomPage extends HookConsumerWidget {
  const JoinRoomPage({super.key});

  static const name = 'join_room';
  static const path = '/join_room';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomIdController = useTextEditingController();
    final scannerController = useMemoized(MobileScannerController.new);

    useEffect(() {
      return scannerController.dispose;
    }, [scannerController]);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ルームに参加'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
              child: Column(
                children: [
                  AppGaps.g16,

                  // QR コードスキャナー
                  SizedBox(
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          MobileScanner(
                            controller: scannerController,
                            onDetect: (capture) {
                              final barcodes = capture.barcodes;
                              for (final barcode in barcodes) {
                                if (barcode.rawValue != null) {
                                  // QRコードが検出されたときの処理
                                  roomIdController.text = barcode.rawValue!;
                                  const RoomLobbyPageRoute().go(context);
                                }
                              }
                            },
                          ),
                          // カスタムオーバーレイ
                          const _QRScannerOverlay(),
                        ],
                      ),
                    ),
                  ),
                  AppGaps.g24,

                  // またはIDを入力
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.s16,
                        ),
                        child: Text(
                          'または ID を入力',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),

                  AppGaps.g32,

                  // ルームID入力フォーム
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ルームID'),
                  ),

                  AppTextFormField(
                    controller: roomIdController,
                    hintText: 'ルームIDを入力',
                  ),

                  AppGaps.g16,

                  // この部屋に入るボタン
                  AppFilledButton(
                    onPressed: roomIdController.text.isNotEmpty
                        ? () {
                            const RoomLobbyPageRoute().go(context);
                          }
                        : null,
                    text: 'この部屋に入る',
                  ),

                  AppGaps.g64,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// QRコードスキャナーのオーバーレイウィジェット
class _QRScannerOverlay extends StatelessWidget {
  const _QRScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // L字型のコーナー
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              children: [
                // 左上のコーナー
                Positioned(
                  top: 0,
                  left: 0,
                  child: CustomPaint(
                    size: const Size(40, 40),
                    painter: _CornerPainter(
                      corner: Corner.topLeft,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                // 右上のコーナー
                Positioned(
                  top: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(40, 40),
                    painter: _CornerPainter(
                      corner: Corner.topRight,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                // 左下のコーナー
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CustomPaint(
                    size: const Size(40, 40),
                    painter: _CornerPainter(
                      corner: Corner.bottomLeft,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                // 右下のコーナー
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(40, 40),
                    painter: _CornerPainter(
                      corner: Corner.bottomRight,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum Corner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({
    required this.corner,
    required this.color,
  });

  final Corner corner;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 20.0;

    switch (corner) {
      case Corner.topLeft:
        // 縦線
        canvas.drawLine(
          const Offset(0, cornerLength),
          const Offset(0, 0),
          paint,
        );
        // 横線
        canvas.drawLine(
          const Offset(0, 0),
          const Offset(cornerLength, 0),
          paint,
        );
      case Corner.topRight:
        // 横線
        canvas.drawLine(
          Offset(size.width - cornerLength, 0),
          Offset(size.width, 0),
          paint,
        );
        // 縦線
        canvas.drawLine(
          Offset(size.width, 0),
          Offset(size.width, cornerLength),
          paint,
        );
      case Corner.bottomLeft:
        // 縦線
        canvas.drawLine(
          Offset(0, size.height - cornerLength),
          Offset(0, size.height),
          paint,
        );
        // 横線
        canvas.drawLine(
          Offset(0, size.height),
          Offset(cornerLength, size.height),
          paint,
        );
      case Corner.bottomRight:
        // 横線
        canvas.drawLine(
          Offset(size.width - cornerLength, size.height),
          Offset(size.width, size.height),
          paint,
        );
        // 縦線
        canvas.drawLine(
          Offset(size.width, size.height),
          Offset(size.width, size.height - cornerLength),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
