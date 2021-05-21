import 'package:flutter/material.dart';

class BouncingDotLoader extends StatefulWidget {
  BouncingDotLoader({
    this.numberOfDots = 3,
    this.dotSize = 6,
  });

  ///The Number of dots that are added to the list. Defaults to 3
  final int numberOfDots;

  ///The size of the dot. Defaults to 6
  final double dotSize;

  @override
  _BouncingDotLoaderState createState() => _BouncingDotLoaderState();
}

class _BouncingDotLoaderState extends State<BouncingDotLoader>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween _tween;
  late List<Widget> _animatedDots;
  late double currentAnimationValue;
  late double prevAnimationValue;

  Animation get animation => _tween.animate(
        CurvedAnimation(
          curve: Interval(
            prevAnimationValue,
            currentAnimationValue,
            curve: Curves.easeInOut,
          ),
          parent: _animationController,
        ),
      );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener(listener);
    _tween = Tween(begin: 0.0, end: 1.0);
    _animatedDots = [];

    _setupAnimationAndDots();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController
      ..removeStatusListener(listener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _animatedDots,
    );
  }

  void listener(AnimationStatus status) {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else if (_animationController.status == AnimationStatus.dismissed) {
      _animationController.forward();
    }
  }

  void _setupAnimationAndDots() {
    for (var i = 0; i < widget.numberOfDots; i++) {
      i == 0
          ? prevAnimationValue = 0.0
          : prevAnimationValue = currentAnimationValue;
      currentAnimationValue = (i + 1) / widget.numberOfDots;
      _animatedDots.add(
        _AnimatedDot(
          animation: animation,
          animationController: _animationController,
          size: widget.dotSize,
        ),
      );
      if (i != widget.numberOfDots - 1)
        _animatedDots.add(
          const SizedBox(width: 2),
        );
    }
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({
    Key? key,
    required this.animationController,
    required this.animation,
    this.size,
  }) : super(key: key);
  final AnimationController animationController;
  final Animation animation;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.translationValues(0, (-animation.value * 2), 0),
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        });
  }
}
