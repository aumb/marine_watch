import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/features/favorites/presentation/widgets/favorite_sighting_card.dart';
import 'package:marine_watch/features/sighting/presentation/widgets/sighting_card.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/utils/widgets/animated_arrows_widget.dart';
import 'package:marine_watch/utils/widgets/custom_elevated_button.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavoritesBloc>()..add(GetCachedSightingsEvent()),
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          return FavoritesView();
        },
      ),
    );
  }
}

class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  FavoritesBloc get _bloc => context.read<FavoritesBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBodyAccordingToState());
  }

  Widget _buildBodyAccordingToState() {
    if (_bloc.state is FavoritesEmpty) {
      return EmptyState();
    } else if (_bloc.state is FavoritesLoading) {
      return LoadingState();
    } else if (_bloc.state is FavoritesError) {
      return ErrorState(onRetry: () {
        _bloc.add(GetCachedSightingsEvent());
      });
    } else if (_bloc.state is FavoritesLoaded) {
      return LoadedState(context: context, bloc: _bloc);
    } else {
      return const SizedBox.shrink();
    }
  }
}

class LoadedState extends StatelessWidget {
  const LoadedState({
    Key? key,
    required this.context,
    required FavoritesBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final BuildContext context;
  final FavoritesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildFavoritesTitle(context),
        _buildFavoriteSightings(),
      ],
    );
  }

  SliverList _buildFavoriteSightings() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            FavoriteSightingCard(sighting: _bloc.favoriteSightings[index]!),
        childCount: _bloc.favoriteSightings.length,
      ),
    );
  }

  SliverSafeArea _buildFavoritesTitle(BuildContext context) {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Text(
                context.l10n.favorites,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.onRetry,
  });

  final Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(context.l10n.genericError),
            const SizedBox(height: 16),
            CustomElevatedButton(
              key: const ValueKey('favorites_retry_button'),
              onPressed: onRetry,
              label: context.l10n.retry,
            ),
          ],
        ),
      ],
    );
  }
}

class LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildExplainationText(l10n),
              ),
            ],
          ),
          _buildAnimatedArrows(),
          _buildMockSightingCard(),
        ],
      ),
    );
  }

  IgnorePointer _buildMockSightingCard() {
    return IgnorePointer(
      child: SightingCard(
        sighting: Sighting.defaultSighting,
      ),
    );
  }

  Container _buildAnimatedArrows() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        AnimatedArrowsWidget(),
      ]),
    );
  }

  RichText _buildExplainationText(AppLocalizations l10n) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: l10n.noFavsTitle,
          ),
          WidgetSpan(
            child: Icon(
              Icons.favorite,
              size: 14,
              color: Colors.grey[400],
            ),
          ),
          TextSpan(
            text: l10n.noFavsTitle2,
          ),
        ],
      ),
    );
  }
}
