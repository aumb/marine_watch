import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_watch/features/favorites/presentation/widgets/animated_favorite_button.dart';
import 'package:marine_watch/features/sighting/presentation/bloc/sighting_bloc.dart';
import 'package:marine_watch/features/sighting/presentation/screens/sighting_screen.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/core/injection_container.dart';
import 'package:marine_watch/core/nav/navgiation_manager.dart';
import 'package:marine_watch/core/utils/string_utils.dart';

import '../../../../widgets/custom_outlined_button.dart';

class FavoriteSightingCard extends StatelessWidget {
  FavoriteSightingCard({
    required this.sighting,
  });

  final Sighting? sighting;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SightingBloc>(
        param1: sighting,
      ),
      child: FavoriteSightingCardView(),
    );
  }
}

class FavoriteSightingCardView extends StatefulWidget {
  @override
  _FavoriteSightingCardViewState createState() =>
      _FavoriteSightingCardViewState();
}

class _FavoriteSightingCardViewState extends State<FavoriteSightingCardView>
    with SingleTickerProviderStateMixin {
  SightingBloc get _bloc => context.read<SightingBloc>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  String get _image => _bloc.sighting?.species?.image ?? '';

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
    final _width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (contex) => _bloc,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform(
            transform:
                Matrix4.translationValues(_animation.value * _width, 0.0, 0.0),
            child: _buildCard(_width)),
      ),
    );
  }

  Card _buildCard(double _width) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor,
          image: _image.isNotEmpty
              ? DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.srcOver),
                  image: AssetImage(_bloc.sighting?.species?.image ?? ''),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            _buildFavorite(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  StringUtils.capitalizeFirstofEach(
                      _bloc.sighting?.species?.value ?? ''),
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 6),
                Text(
                  _bloc.sighting?.description != null
                      ? '${_bloc.sighting?.description}\n'
                      : '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                _buildDetailsButton(context.l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder _buildFavorite() {
    return BlocBuilder<SightingBloc, SightingState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedFavoriteButton(
              key: const Key('favorite_button_key'),
              valueChanged: (value) {
                _bloc.add(ToggleFavoriteSightingEvent());
              },
              isFavorite: _bloc.isFavorite,
            ),
          ],
        );
      },
    );
  }

  CustomOutlinedButton _buildDetailsButton(AppLocalizations l10n) {
    return CustomOutlinedButton(
      key: const Key(
        'sighting_details_button1',
      ),
      onPressed: () {
        sl<NavigationManager>().navigateTo(
          BlocProvider.value(
            value: _bloc,
            child: SightingScreen(),
          ),
        );
      },
      label: l10n.details,
    );
  }
}
