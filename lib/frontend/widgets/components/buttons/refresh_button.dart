// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/animations/rotation_animation.dart';

class RefreshButton extends StatelessWidget {

  final double size;
  final Function onPressed;

  const RefreshButton({super.key, required this.size, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    GlobalKey<RotationAnimationState> rotationKey = GlobalKey<RotationAnimationState>();
    bool loading = false;
    return RotationAnimation(
      key: rotationKey,
      duration: const Duration(milliseconds: 1500),
      firstRotationPosition: 0,
      secondRotationPosition: 360,
      child: IconButton(
        icon: Icon(
          Icons.refresh,
          size: size,
          color: Colors.white,
        ),
        onPressed: () async {
          if (!loading) {
            loading = true;
            rotationKey.currentState?.endlessAnimation();
            await onPressed();
            rotationKey.currentState?.stopAnimation();
            loading = false;
          }
        },
      ),
    );
  }
}
