// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';
import 'package:secret_hitler/frontend/widgets/header/header_image.dart';

// Animation to change the color and images of the header
class HeaderAnimation extends StatefulWidget {

  final Duration duration;
  final Color firstColor;
  final Color secondColor;
  final String headerText;

  const HeaderAnimation({super.key, required this.duration,
    required this.firstColor, required this.secondColor, required this.headerText});

  @override
  State<HeaderAnimation> createState() => HeaderAnimationState();
}

class HeaderAnimationState extends State<HeaderAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _firstImageAnimation;
  late Animation<double> _secondImageAnimation;
  late Animation _colorAnimation;
  AnimationStatus _status = AnimationStatus.dismissed;
  late String firstHeaderImage;
  late String secondHeaderImage;

  Future<void> animate() async {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    await Future.delayed(widget.duration);
  }

  @override
  void initState() {
    _controller = AnimationControllers.getController(widget.duration, this);
    _colorAnimation = ColorTween(begin: widget.firstColor, end: widget.secondColor)
        .animate(_controller);
    _colorAnimation.addStatusListener((status) {});
    _colorAnimation.addStatusListener((status) {
      _status = status;
    });
    _firstImageAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    _firstImageAnimation.addStatusListener((status) {});
    _secondImageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _secondImageAnimation.addStatusListener((status) {});
    firstHeaderImage = HeaderImage.getHeaderImage(widget.firstColor);
    HeaderImage.resetNewHeader();
    secondHeaderImage = HeaderImage.getHeaderImage(widget.secondColor);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return _AnimatedHeader(
          headerText: widget.headerText,
          headerColor: _colorAnimation.value,
          firstImage: firstHeaderImage,
          secondImage: secondHeaderImage,
          firstImageAnimation: _firstImageAnimation,
          secondImageAnimation: _secondImageAnimation,
        );
      },
    );
  }
}

// The header widget but with the possibilities to change the color and image with animation
class _AnimatedHeader extends StatefulWidget {

  final String headerText;
  final Color headerColor;
  final String firstImage;
  final String secondImage;
  final Animation<double> firstImageAnimation;
  final Animation<double> secondImageAnimation;

  const _AnimatedHeader({super.key, required this.headerText,
    required this.headerColor, required this.firstImage,
    required this.secondImage, required this.firstImageAnimation,
    required this.secondImageAnimation});

  @override
  State<_AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<_AnimatedHeader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSize.screenHeight * 0.185,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 1.5,
            heightFactor: 1,
            child: CustomPaint(
              painter: HalfCirclePainter(color: widget.headerColor),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    FadeTransition(
                      opacity: widget.firstImageAnimation,
                      child: Image.asset(
                        'assets/images/${widget.firstImage}.png',
                        height: ScreenSize.screenHeight * 0.135,
                        width: ScreenSize.screenWidth * 0.25,
                      ),
                    ),
                    FadeTransition(
                      opacity: widget.secondImageAnimation,
                      child: Image.asset(
                        'assets/images/${widget.secondImage}.png',
                        height: ScreenSize.screenHeight * 0.135,
                        width: ScreenSize.screenWidth * 0.25,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: ScreenSize.screenHeight * 0.1,
                      width: ScreenSize.screenWidth * 0.3,
                    ),
                    SizedBox(
                      width: ScreenSize.screenWidth * 0.47,
                      height: ScreenSize.screenHeight * 0.07,
                      child: Center(
                        child: Text(
                          widget.headerText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'EskapadeFrakturW04BlackFamily',
                            color: Colors.white,
                            fontSize: ScreenSize.screenHeight * 0.024 +
                                ScreenSize.screenWidth * 0.024,
                            height: 0.9,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: ScreenSize.screenHeight * 0.005,
                    )
                  ],
                ),
                Stack(
                  children: [
                    FadeTransition(
                      opacity: widget.firstImageAnimation,
                      child: Image.asset(
                        'assets/images/${widget.firstImage}_inverted.png',
                        height: ScreenSize.screenHeight * 0.135,
                        width: ScreenSize.screenWidth * 0.25,
                      ),
                    ),
                    FadeTransition(
                      opacity: widget.secondImageAnimation,
                      child: Image.asset(
                        'assets/images/${widget.secondImage}_inverted.png',
                        height: ScreenSize.screenHeight * 0.135,
                        width: ScreenSize.screenWidth * 0.25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

