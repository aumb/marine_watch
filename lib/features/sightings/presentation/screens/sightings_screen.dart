import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_watch/features/sighting/presentation/widgets/sighting_preview_card.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/filter_widget.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/map_widget.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/bitmap_utils.dart';
import 'package:marine_watch/utils/widgets/bouncing_dot_loader.dart';

class SightingsScreen extends StatefulWidget {
  @override
  _SightingsScreenState createState() => _SightingsScreenState();
}

class _SightingsScreenState extends State<SightingsScreen> {
  late SightingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<SightingsBloc>();
    _bloc.add(GetSightingsEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SightingsBloc, SightingsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SightingsView();
        },
      ),
    );
  }
}

class SightingsView extends StatefulWidget {
  @override
  _SightingsViewState createState() => _SightingsViewState();
}

class _SightingsViewState extends State<SightingsView> {
  late CameraPosition _cameraPosition;

  bool showCard = false;

  SightingsBloc get _bloc => context.read<SightingsBloc>();

  BitmapManager get _bitmapManager => sl<BitmapManager>();

  BitmapDescriptor get _mapPin {
    var pin = BitmapDescriptor.defaultMarker;
    if (_bitmapManager.svgMapPin != null) {
      pin = _bitmapManager.svgMapPin!;
    } else if (_bitmapManager.pngMapPin != null) {
      pin = _bitmapManager.pngMapPin!;
    }
    return pin;
  }

  @override
  void didUpdateWidget(covariant SightingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setupMarkerIcons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          if (_bloc.state is SightingsLoading) _buildLoader(),
          _buildFilter(context),
          showCard
              ? SafeArea(
                  child: SightingPreviewCard(
                    sighting: _bloc.selectedSighting,
                    onDismiss: () => _bloc.selectedSighting = null,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Positioned _buildFilter(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.05,
      left: 0,
      right: 0,
      child: FilterWidget(
        onShowResults: (params) {
          _bloc
            ..species = params?.species
            ..add(
              GetSightingsEvent(
                species: params?.species,
              ),
            );
        },
      ),
    );
  }

  Positioned _buildLoader() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.03,
      left: 0,
      right: 0,
      child: BouncingDotLoader(),
    );
  }

  MapWidget _buildMap() {
    return MapWidget(
      markers: _bloc.markers,
      onCameraIdle: () {
        _bloc.hasMovedCamera = true;
        if (_bloc.shouldGetMarkers) {
          context
              .read<SightingsBloc>()
              .add(GetSightingsEvent(latLng: _cameraPosition.target));
        }
      },
      onCameraMove: (position) {
        _cameraPosition = position;
      },
      onCameraMoveStarted: () {
        _bloc.hasMovedCamera = false;
      },
    );
  }

  Future<void> resetSelectedSighting() async {
    _bloc.selectedSighting = null;
    showCard = false;
    setState(() {});
    await Future.delayed(Duration(milliseconds: 1));
  }

  void setSelectedSighting(Sighting? sighting) {
    showCard = true;
    _bloc.selectedSighting = sighting;
    setState(() {});
  }

  void setupMarkerIcons() async {
    final _sightings = _bloc.sightings ?? [];
    final _prevMarkers = _bloc.markers;

    _bloc.markers = {};

    for (var sighting in _sightings) {
      final canAddMarker = sighting != null &&
          sighting.longitude != null &&
          sighting.latitude != null &&
          sighting.id != null;

      if (canAddMarker)
        _bloc.markers!.add(Marker(
          icon: _mapPin,
          onTap: () async {
            await resetSelectedSighting();
            setSelectedSighting(sighting);
          },
          markerId: MarkerId(sighting!.id ?? ''),
          position: LatLng(
            sighting.latitude!.toDouble(),
            sighting.longitude!.toDouble(),
          ),
        ));
    }

    //If the new markers are empty keep the old ones.
    if (_bloc.markers?.isEmpty ?? false) {
      _bloc.markers = _prevMarkers;
    }
  }
}
