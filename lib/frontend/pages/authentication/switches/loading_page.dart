// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// Page which is shown until the initial load is finished
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF474747),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: ScreenSize.screenWidth * 0.05),
          child: Image.asset(
            'assets/images/Logo.png',
            height: ScreenSize.screenHeight * 0.7,
            width: ScreenSize.screenWidth * 0.7,
          ),
        ),
      ),
    );
  }
}
