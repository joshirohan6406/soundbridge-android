import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme.dart';
import '../../../models/session.dart';
import '../../../services/join/qr_service.dart';

class QrScannerView extends StatefulWidget {
  final void Function(Session session) onSessionFound;

  const QrScannerView({super.key, required this.onSessionFound});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  final MobileScannerController _ctrl = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null) return;
    final session = QrService.parseScannedValue(code);
    if (session != null) {
      _scanned = true;
      widget.onSessionFound(session);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _ctrl,
                    onDetect: _onDetect,
                  ),
                  // Corner guides
                  Positioned.fill(
                    child: CustomPaint(painter: _ScannerOverlay()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Point camera at the QR code\non the host device',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 14,
              color: SBColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SBColors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 28.0;
    const r = 4.0;
    final m = 16.0;

    // Top left
    canvas.drawLine(Offset(m, m + len), Offset(m, m + r), paint);
    canvas.drawLine(Offset(m, m), Offset(m + len, m), paint);
    // Top right
    canvas.drawLine(
        Offset(size.width - m - len, m), Offset(size.width - m, m), paint);
    canvas.drawLine(Offset(size.width - m, m),
        Offset(size.width - m, m + len), paint);
    // Bottom left
    canvas.drawLine(Offset(m, size.height - m - len),
        Offset(m, size.height - m), paint);
    canvas.drawLine(Offset(m, size.height - m),
        Offset(m + len, size.height - m), paint);
    // Bottom right
    canvas.drawLine(Offset(size.width - m - len, size.height - m),
        Offset(size.width - m, size.height - m), paint);
    canvas.drawLine(Offset(size.width - m, size.height - m - len),
        Offset(size.width - m, size.height - m), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}