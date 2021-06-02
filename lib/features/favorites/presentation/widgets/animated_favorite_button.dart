import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marine_watch/utils/color_utils.dart';

// coverage:ignore-file
class AnimatedFavoriteButton extends StatefulWidget {
  AnimatedFavoriteButton({
    double? iconSize,
    Color? iconDisabledColor,
    bool? isFavorite,
    required Function(bool) valueChanged,
    Key? key,
  })  : _iconSize = iconSize ?? 27.0,
        _iconDisabledColor = iconDisabledColor ?? Colors.grey[400],
        _isFavorite = isFavorite ?? false,
        _valueChanged = valueChanged,
        super(key: key);

  final double _iconSize;
  final bool _isFavorite;
  final Function _valueChanged;
  final Color? _iconDisabledColor;

  @override
  _AnimatedFavoriteButtonState createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _selectedColorAnimation;
  late Animation<Color?> _deSelectedColorAnimation;

  late CurvedAnimation _curve;

  double _maxIconSize = 0.0;
  double _minIconSize = 0.0;

  final int _animationTime = 400;

  bool _isFavorite = false;
  bool _isAnimationCompleted = false;

  Color? _iconColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setupColorAnimations();
  }

  @override
  void initState() {
    super.initState();

    _maxIconSize = (widget._iconSize < 20.0)
        ? 20.0
        : (widget._iconSize > 100.0)
            ? 100.0
            : widget._iconSize;
    final _sizeDifference = _maxIconSize * 0.30;
    _minIconSize = _maxIconSize - _sizeDifference;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animationTime),
    );

    _curve = CurvedAnimation(curve: Curves.slowMiddle, parent: _controller);

    _controller.addStatusListener(listener);
    _colorAnimation = ColorTween().animate(_curve);
    _colorAnimation.addListener(() {
      _iconColor = _colorAnimation.value;
    });
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
      builder: (BuildContext context, _) {
        return InkResponse(
          onTap: () {
            setState(() {
              if (_isAnimationCompleted == true) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            });
          },
          child: Icon(
            (Icons.favorite),
            color: _iconColor,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }

  void listener(status) {
    if (status == AnimationStatus.completed) {
      _isAnimationCompleted = true;
      _isFavorite = !_isFavorite;
      widget._valueChanged(_isFavorite);
    } else if (status == AnimationStatus.dismissed) {
      _isAnimationCompleted = false;
      _isFavorite = !_isFavorite;
      widget._valueChanged(_isFavorite);
    }
  }

  void setupColorAnimations() {
    _isFavorite = widget._isFavorite;
    _iconColor = _isFavorite ? Theme.of(context).accentColor : Colors.grey[400];
    _selectedColorAnimation = ColorTween(
      begin: ColorUtils.accentColor,
      end: widget._iconDisabledColor,
    ).animate(_curve);
    _deSelectedColorAnimation = ColorTween(
      begin: widget._iconDisabledColor,
      end: ColorUtils.accentColor,
    ).animate(_curve);

    _colorAnimation = (_isFavorite == true)
        ? _selectedColorAnimation
        : _deSelectedColorAnimation;

    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _minIconSize,
            end: _maxIconSize,
          ),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _maxIconSize,
            end: _minIconSize,
          ),
          weight: 50,
        ),
      ],
    ).animate(_curve);
  }
}
