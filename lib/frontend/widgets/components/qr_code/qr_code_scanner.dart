// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';

class QrCodeScanner extends ConsumerStatefulWidget {
  const QrCodeScanner({super.key});

  @override
  ConsumerState<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends ConsumerState<QrCodeScanner> {

  String? _codeInformation;
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void reassemble() {
    super.reassemble();
    _scannerController.stop();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeNotifier = ref.watch(qrCodeProvider.notifier);

    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (_codeInformation != barcode.rawValue
                  && barcode.rawValue!.length == 20) {
                _codeInformation = barcode.rawValue;
                qrCodeNotifier.updateCodeInformation(_codeInformation);
              }
            }
          },
        ),
        QRScannerOverlay(
          overlayColor: Colors.black.withOpacity(0.5),
          scanAreaWidth: ScreenSize.screenWidth * 0.85,
          scanAreaHeight: ScreenSize.screenHeight * 0.425,
        ),
      ],
    );
  }
}
