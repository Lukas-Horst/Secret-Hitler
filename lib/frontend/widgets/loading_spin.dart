// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';

void loadingSpin(bool show, BuildContext context) {
  if (show) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: SpinKitPulse(
            color: Colors.white,
            size: ScreenSize.screenHeight * 0.1,
          ),
        );
      },
    );
  } else {
    if (isThereCurrentDialogShowing(context)) {
      Navigator.of(context).pop();
    }
  }
}