import 'package:flutter/material.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/utils/string_utils.dart';
import 'package:marine_watch/utils/widgets/custom_outlined_button.dart';

class SightingPreviewWidget extends StatefulWidget {
  const SightingPreviewWidget({
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

class _SighitingPreviewWidgetState extends State<SightingPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late bool _didSwipeUp;

  bool get _showCard => widget.sighting != null;

  String get image => widget.sighting?.species?.image ?? '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final l10n = context.l10n;

    if (_showCard) {
      if (_animationController.status == AnimationStatus.dismissed)
        _animationController.forward();
      return _buildAnimatedBuilder(_height, _width, l10n);
    } else {
      if (_animationController.status == AnimationStatus.completed)
        _animationController.reverse();
      return const SizedBox.shrink();
    }
  }

  AnimatedBuilder _buildAnimatedBuilder(
      double _height, double _width, AppLocalizations l10n) {
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
            child: _buildCard(_width, l10n)),
      ),
    );
  }

  Card _buildCard(double _width, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                _buildImage(_width),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 22,
                            ),
                          ],
                        ),
                        Text(
                          StringUtils.capitalizeFirstofEach(
                              widget.sighting?.species?.value ?? ''),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.sighting?.description ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2),
                        _buildDetailsButton(l10n),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomOutlinedButton _buildDetailsButton(AppLocalizations l10n) {
    return CustomOutlinedButton(
      key: const Key(
        'sighting_details_button',
      ),
      onPressed: () {},
      label: l10n.details,
    );
  }

  Container _buildImage(double width) {
    return Container(
        width: width * 0.2,
        height: width * 0.2,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            const BoxShadow(
                blurRadius: 10, color: Colors.black, spreadRadius: 5)
          ],
          shape: BoxShape.circle,
          image: image.isNotEmpty
              ? DecorationImage(
                  image: AssetImage(widget.sighting?.species?.image ?? ''),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: image.isEmpty
            ? const Center(
                child: Icon(Icons.image),
              )
            : null);
  }
}
