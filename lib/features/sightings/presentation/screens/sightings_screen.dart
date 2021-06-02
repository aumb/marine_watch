import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_watch/features/sighting/presentation/cubit/toggle_sighting_cubit.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/filter_widget.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/map_widget.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/toggle_sighting_widget.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/bitmap_utils.dart';
import 'package:marine_watch/utils/custom_lat_lng.dart';
import 'package:marine_watch/utils/widgets/bouncing_dot_loader.dart';
import 'package:marine_watch/features/l10n/l10n.dart';

class SightingsScreen extends StatefulWidget {
  @override
  _SightingsScreenState createState() => _SightingsScreenState();
}

class _SightingsScreenState extends State<SightingsScreen> {
  late SightingsBloc _bloc;
  late ToggleSightingCubit _toggleSightingCubit;

  @override
  void initState() {
    super.initState();
    _bloc = sl<SightingsBloc>();
    _toggleSightingCubit = sl<ToggleSightingCubit>();
    _bloc.add(GetSightingsEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    _toggleSightingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SightingsBloc>(
          create: (context) => _bloc,
        ),
        BlocProvider<ToggleSightingCubit>(
          create: (context) => _toggleSightingCubit,
        ),
      ],
      child: BlocConsumer<SightingsBloc, SightingsState>(
        listener: _handleListenerStates,
        builder: (context, state) {
          return SightingsView();
        },
      ),
    );
  }

  void _handleListenerStates(BuildContext context, SightingsState state) {
    if (state is SightingsError) {
      final snackBar = SnackBar(
          content: Text(context.l10n.genericError),
          behavior: SnackBarBehavior.floating);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (state is SightingsEmpty) {
      final snackBar = SnackBar(
          content: Text(context.l10n.emptySightings),
          behavior: SnackBarBehavior.floating);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class SightingsView extends StatefulWidget {
  @override
  _SightingsViewState createState() => _SightingsViewState();
}

class _SightingsViewState extends State<SightingsView> {
  late CameraPosition _cameraPosition;

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
  void initState() {
    super.initState();
    _cameraPosition = const CameraPosition(target: LatLng(47.78, -122.44));
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
          ToggleSightingWidget(),
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
          context.read<ToggleSightingCubit>().toggleSightingToNull();
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
          context.read<SightingsBloc>().add(
                GetSightingsEvent(
                  latLng: CustomLatLng(
                    _cameraPosition.target.latitude,
                    _cameraPosition.target.longitude,
                  ),
                ),
              );
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
          onTap: () {
            context
                .read<ToggleSightingCubit>()
                .toggleSightingToNullThenValue(sighting);
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
