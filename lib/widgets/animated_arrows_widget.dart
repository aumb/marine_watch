import 'package:flutter/material.dart';

class AnimatedArrowsWidget extends StatefulWidget {
  AnimatedArrowsWidget({
    this.numberOfArrows = 3,
    this.arrowSize = 22,
  });

  final int numberOfArrows;
  final double arrowSize;

  @override
  _AnimatedArrowsWidgetState createState() => _AnimatedArrowsWidgetState();
}

class _AnimatedArrowsWidgetState extends State<AnimatedArrowsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation = ColorTween(
      begin: Colors.grey[400],
      end: Theme.of(context).accentColor,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, state) {
        return Column(
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              color: _animation.value,
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: _animation.value,
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: _animation.value,
            ),
          ],
        );
      },
    );
  }
}
