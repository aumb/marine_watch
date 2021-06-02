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

class SightingCard extends StatelessWidget {
  SightingCard({
    this.sighting,
  });

  final Sighting? sighting;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SightingBloc>(
        param1: sighting,
      ),
      child: SightingCardView(),
    );
  }
}

class SightingCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.select((SightingBloc c) => c.state);
    final _bloc = context.read<SightingBloc>();
    final _width = MediaQuery.of(context).size.width;
    return _buildCard(_width, context, _bloc);
  }

  Card _buildCard(double _width, BuildContext context, SightingBloc bloc) {
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
                _buildImage(_width, context, bloc.sighting),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        _buildFavorite(bloc),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              StringUtils.capitalizeFirstofEach(
                                  bloc.sighting?.species?.value ?? ''),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              bloc.sighting?.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 2),
                            _buildDetailsButton(context.l10n, bloc),
                          ],
                        ),
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

  BlocBuilder _buildFavorite(SightingBloc bloc) {
    return BlocBuilder<SightingBloc, SightingState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedFavoriteButton(
              valueChanged: (value) {
                bloc.add(ToggleFavoriteSightingEvent());
              },
              isFavorite: bloc.isFavorite,
            ),
          ],
        );
      },
    );
  }

  CustomOutlinedButton _buildDetailsButton(
      AppLocalizations l10n, SightingBloc bloc) {
    return CustomOutlinedButton(
      key: const Key(
        'sighting_details_button',
      ),
      onPressed: () {
        sl<NavigationManager>().navigateTo(
          BlocProvider.value(
            value: bloc,
            child: SightingScreen(),
          ),
        );
      },
      label: l10n.details,
    );
  }

  Container _buildImage(
      double width, BuildContext context, Sighting? sighting) {
    final _image = sighting?.species?.image ?? '';

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
          image: _image.isNotEmpty
              ? DecorationImage(
                  image: AssetImage(sighting?.species?.image ?? ''),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image.isEmpty
            ? const Center(
                child: Icon(Icons.image),
              )
            : null);
  }
}
