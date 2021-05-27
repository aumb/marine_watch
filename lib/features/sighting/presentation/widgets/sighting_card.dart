import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_watch/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:marine_watch/features/sighting/presentation/bloc/sighting_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/string_utils.dart';

import '../../../../utils/widgets/custom_outlined_button.dart';

class SightingCard extends StatefulWidget {
  SightingCard({
    required this.sighting,
  });

  final Sighting? sighting;

  @override
  _SightingCardState createState() => _SightingCardState();
}

class _SightingCardState extends State<SightingCard> {
  late SightingBloc _bloc;

  String get _image => widget.sighting?.species?.image ?? '';

  @override
  void initState() {
    super.initState();
    _bloc = sl<SightingBloc>(
      param1: widget.sighting,
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (contex) => _bloc,
      child: _buildCard(_width),
    );
  }

  Card _buildCard(double _width) {
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
                _buildImage(_width, context),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        _buildFavorite(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
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
                            _buildDetailsButton(context.l10n),
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

  BlocBuilder _buildFavorite() {
    return BlocBuilder<SightingBloc, SightingState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FavoriteButton(
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
        'sighting_details_button',
      ),
      onPressed: () {},
      label: l10n.details,
    );
  }

  Container _buildImage(double width, BuildContext context) {
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
                  image: AssetImage(widget.sighting?.species?.image ?? ''),
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
