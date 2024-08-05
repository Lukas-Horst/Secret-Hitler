// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_room_collection_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/activate_widget.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/qr_code/qr_code_scanner.dart';

class QrCodeScannerPage extends ConsumerStatefulWidget {
  const QrCodeScannerPage({super.key});

  @override
  ConsumerState<QrCodeScannerPage> createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends ConsumerState<QrCodeScannerPage> {

  final GlobalKey<ActivateWidgetState> _navigationBarActivateKey = GlobalKey<ActivateWidgetState>();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Method to check the code information of the scanned qr code and join the
  // waiting room if we have a valid id
  Future<void> checkQrCodeInformation(String codeInformation,
      BuildContext context) async {
    Document? potencialWaitingRoom = await getWaitingRoom(
      ref,
      codeInformation,
      null,
    );
    if (potencialWaitingRoom != null) {
      await joinWaitingRoom(
        ref,
        potencialWaitingRoom,
        context,
        2,
        _navigationBarActivateKey
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeState = ref.watch(qrCodeProvider);

    if (qrCodeState.codeInformation != null) {
      checkQrCodeInformation(qrCodeState.codeInformation!, context);
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: const QrCodeScanner(),
          bottomNavigationBar: ActivateWidget(
            key: _navigationBarActivateKey,
            child: CustomBottomNavigationBar(
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
      ),
    );
  }
}
