import 'package:app_frontend/screens/game/create.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatelessWidget {
  const QRCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(onDetect: (code, _) {
      print("Detected basket ${code.rawValue}");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CreateGame(int.parse(code.rawValue!))));
    });
  }
}
