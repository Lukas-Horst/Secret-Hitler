// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/qr_code/qr_code_generator.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class QrCodeJoin extends StatefulWidget {

  final String waitingRoomId;

  const QrCodeJoin({super.key, required this.waitingRoomId});

  @override
  State<QrCodeJoin> createState() => _QrCodeJoinState();
}

class _QrCodeJoinState extends State<QrCodeJoin> {

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF474747),
          body: Column(
            children: [
              Header(headerText: AppLanguage.getLanguageData()['Waiting room QR-Code']),
              SizedBox(height: ScreenSize.screenHeight * 0.1),
              QrCodeGenerator(
                codeInformation: widget.waitingRoomId,
                size: ScreenSize.screenWidth * 0.8,
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            borderRadius: const BorderRadius.only(),
            children: [
              NavigationBackButton(onPressed: () {
                _goBack(context);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
