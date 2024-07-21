// author: Lukas Horst

import 'package:flutter_riverpod/flutter_riverpod.dart';

class QrCodeState {
  final String? codeInformation;
  QrCodeState({required this.codeInformation});
}

class QrCodeNotifier extends StateNotifier<QrCodeState> {

  QrCodeNotifier() : super(QrCodeState(codeInformation: null));

  // Method to update the value of the codeInformation
  void updateCodeInformation(String? codeInformation) {
    state = QrCodeState(codeInformation: codeInformation);
  }
}