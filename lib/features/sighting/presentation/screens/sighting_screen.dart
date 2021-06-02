import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_watch/features/sighting/presentation/bloc/sighting_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/map_widget.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/bitmap_utils.dart';
import 'package:marine_watch/utils/date_utils.dart';
import 'package:marine_watch/utils/string_utils.dart';
import 'package:marine_watch/utils/widgets/custom_elevated_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:marine_watch/features/l10n/l10n.dart';

class SightingScreen extends StatefulWidget {
  @override
  _SightingScreenState createState() => _SightingScreenState();
}

class _SightingScreenState extends State<SightingScreen> {
  BitmapManager get _bitmapManager => sl<BitmapManager>();

  Sighting get sighting => context.read<SightingBloc>().sighting!;

  AppLocalizations get l10n => context.l10n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                _buildTitle(),
                _buildDivider(),
                _buildBody(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.bottom,
                horizontal: 32),
            child: CustomElevatedButton(
              key: const Key('track_button_key'),
              onPressed: () {
                context.read<SightingBloc>().add(TrackButtonPressedEvent());
              },
              label: l10n.track,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildBody() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: SightingInfoWidget(
                    title: l10n.sightedOn,
                    subtitle: CustomDateUtils.getStrDate(sighting.sightedAt,
                        pattern: 'MMMMd'),
                    icon: MdiIcons.binoculars,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SightingInfoWidget(
                    title: l10n.quantity,
                    subtitle: sighting.quantity?.toString() ??
                        l10n.unknown.toLowerCase(),
                    icon: MdiIcons.fish,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.description,
                      style: Theme.of(context).textTheme.headline5),
                  const SizedBox(height: 4),
                  Text(sighting.description ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildDivider() {
    return SliverToBoxAdapter(
      child: Container(
        height: 0.1,
        color: Colors.white,
      ),
    );
  }

  SliverPadding _buildTitle() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                Text(
                  StringUtils.capitalizeFirstofEach(
                    sighting.species?.value ?? '',
                  ),
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 4),
                Text(
                  sighting.location!.isEmpty
                      ? l10n.unknown
                      : sighting.location!,
                ),
                const SizedBox(height: 28),
              ],
            ),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  Container _buildImage() {
    final _image = sighting.species?.image ?? '';
    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width * 0.18,
        height: width * 0.18,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            const BoxShadow(
                blurRadius: 10, color: Colors.black, spreadRadius: 5)
          ],
          shape: BoxShape.circle,
          image: _image.isNotEmpty
              ? DecorationImage(
                  image: AssetImage(sighting.species?.image ?? ''),
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

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: false,
      expandedHeight: MediaQuery.of(context).size.height * 0.4,
      actions: [
        BlocBuilder<SightingBloc, SightingState>(
          builder: (context, state) {
            return IconButton(
              key: const Key('favorite_icon_button_key'),
              onPressed: () => context
                  .read<SightingBloc>()
                  .add(ToggleFavoriteSightingEvent()),
              icon: Icon(Icons.favorite,
                  color: context.read<SightingBloc>().isFavorite
                      ? Theme.of(context).accentColor
                      : Colors.grey[400]),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: IgnorePointer(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
            child: MapWidget(
              latLng: (sighting.latitude != null && sighting.longitude != null)
                  ? LatLng(
                      sighting.latitude!.toDouble(),
                      sighting.longitude!.toDouble(),
                    )
                  : null,
              markers: {
                Marker(
                  icon: _bitmapManager.svgMapPin ??
                      BitmapDescriptor.defaultMarker,
                  markerId:
                      MarkerId(context.read<SightingBloc>().sighting?.id ?? ''),
                  position: LatLng(
                    context.read<SightingBloc>().sighting!.latitude!.toDouble(),
                    context
                        .read<SightingBloc>()
                        .sighting!
                        .longitude!
                        .toDouble(),
                  ),
                )
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SightingInfoWidget extends StatelessWidget {
  const SightingInfoWidget({
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(
          title,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}
