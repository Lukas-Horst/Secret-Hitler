// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodeGenerator extends StatelessWidget {

  final String codeInformation;
  final double size;

  const QrCodeGenerator({super.key, required this.codeInformation,
    required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: PrettyQrView.data(
        data: codeInformation,
      ),
    );
  }
}
