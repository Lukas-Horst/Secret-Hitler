// author Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'dart:math' as math;

import 'header_image.dart';


// Widget for the header
class Header extends StatelessWidget {
  final String headerText;
  late final Color headerColor;
  late String headerImage;

  Header({super.key, required this.headerText}) {
    headerColor = AppDesign.getPrimaryColor();
    headerImage = HeaderImage.getHeaderImage(headerColor);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 1,
        heightFactor: 0.2,
        child: Container(
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: 1.5,
                heightFactor: 1,
                child: Container(
                  child: CustomPaint(
                    painter: HalfCirclePainter(color: headerColor),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/${headerImage}.png',
                      height: ScreenSize.screenHeight * 0.135,
                      width: ScreenSize.screenWidth * 0.25,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/Logo.png',
                          height: ScreenSize.screenHeight * 0.1,
                          width: ScreenSize.screenWidth * 0.3,
                        ),
                        Text(
                          headerText,
                          style: TextStyle(
                            fontFamily: 'EskapadeFrakturW04BlackFamily',
                            color: Colors.white,
                            fontSize: ScreenSize.screenHeight * 0.025 +
                                ScreenSize.screenWidth * 0.025,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/${headerImage}_inverted.png',
                      height: ScreenSize.screenHeight * 0.135,
                      width: ScreenSize.screenWidth * 0.25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Creates a half circle
class HalfCirclePainter extends CustomPainter {
  final Color color;

  HalfCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    const double startAngle = math.pi;
    const double sweepAngle = math.pi;

    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
