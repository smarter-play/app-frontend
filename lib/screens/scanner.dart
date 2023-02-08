import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatelessWidget {
  const QRCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(onDetect: (code, _) {});
  }
}
