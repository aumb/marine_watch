import 'package:flutter/material.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sighting/presentation/widgets/sighting_card.dart';

class SightingPreviewCard extends StatefulWidget {
  const SightingPreviewCard({
    required this.sighting,
    this.onTap,
    this.onDismiss,
  });

  final Sighting? sighting;
  final Function()? onTap;
  final Function()? onDismiss;

  @override
  _SighitingPreviewWidgetState createState() => _SighitingPreviewWidgetState();
}

class _SighitingPreviewWidgetState extends State<SightingPreviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late bool _didSwipeUp;

  bool get _showCard => widget.sighting != null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: -1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _handleShowCard();
  }

  Widget _handleShowCard() {
    final _height = MediaQuery.of(context).size.height;
    late Widget _widget;
    if (_showCard) {
      if (_animationController.status == AnimationStatus.dismissed)
        _animationController.forward();

      _widget = _buildAnimatedBuilder(_height);
    } else {
      if (_animationController.status == AnimationStatus.completed)
        _animationController.reverse();

      _widget = const SizedBox.shrink();
    }

    return _widget;
  }

  AnimatedBuilder _buildAnimatedBuilder(double _height) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform(
        transform:
            Matrix4.translationValues(0.0, _animation.value * _height, 0.0),
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 0) {
              _didSwipeUp = false;
            } else {
              _didSwipeUp = true;
            }
          },
          onPanEnd: (details) {
            if (_didSwipeUp) {
              _animationController.reverse();
              widget.onDismiss!();
            }
          },
          onTap: widget.onTap,
          child: SightingCard(
            sighting: widget.sighting,
          ),
        ),
      ),
    );
  }
}
