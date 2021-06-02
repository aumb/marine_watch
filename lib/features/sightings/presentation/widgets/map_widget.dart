import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
    this.markers,
    this.onCameraIdle,
    this.onCameraMove,
    this.onCameraMoveStarted,
    this.onTap,
    this.latLng,
  }) : super(key: key);
  final Set<Marker>? markers;
  final Function()? onCameraIdle;
  final Function(CameraPosition)? onCameraMove;
  final Function()? onCameraMoveStarted;
  final Function(LatLng)? onTap;
  final LatLng? latLng;

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget>
    with AutomaticKeepAliveClientMixin<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late CameraPosition initalPosition;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initalPosition = CameraPosition(
      target: widget.latLng ?? const LatLng(47.78, -122.44),
      zoom: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GoogleMap(
        onTap: widget.onTap,
        markers: widget.markers ?? <Marker>{},
        onCameraIdle: widget.onCameraIdle,
        onCameraMove: widget.onCameraMove,
        onCameraMoveStarted: widget.onCameraMoveStarted,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        myLocationEnabled: false,
        initialCameraPosition: initalPosition,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          mapController.setMapStyle(mapstyling);
          _controller.complete(mapController);
        },
      ),
    );
  }

  var mapstyling = jsonEncode([
    {
      'elementType': 'geometry',
      'stylers': [
        {'color': '#242f3e'}
      ]
    },
    {
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#746855'}
      ]
    },
    {
      'elementType': 'labels.text.stroke',
      'stylers': [
        {'color': '#242f3e'}
      ]
    },
    {
      'featureType': 'administrative.locality',
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#d59563'}
      ]
    },
    {
      'featureType': 'poi',
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#d59563'}
      ]
    },
    {
      'featureType': 'poi.park',
      'elementType': 'geometry',
      'stylers': [
        {'color': '#263c3f'}
      ]
    },
    {
      'featureType': 'poi.park',
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#6b9a76'}
      ]
    },
    {
      'featureType': 'road',
      'elementType': 'geometry',
      'stylers': [
        {'color': '#38414e'}
      ]
    },
    {
      'featureType': 'road',
      'elementType': 'geometry.stroke',
      'stylers': [
        {'color': '#212a37'}
      ]
    },
    {
      'featureType': 'road',
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#9ca5b3'}
      ]
    },
    {
      'featureType': 'road.highway',
      'elementType': 'geometry',
      'stylers': [
        {'color': '#746855'}
      ]
    },
    {
      'featureType': 'road.highway',
      'elementType': 'geometry.stroke',
      'stylers': [
        {'color': '#1f2835'}
      ]
    },
    {
      'featureType': 'road.highway',
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#f3d19c'}
      ]
    },
    {
      'featureType': 'transit',
      'elementType': 'geometry',
      'stylers': [
        {'color': '#2f3948'}
      ]
    },
    {
      'featureType': 'transit.station',
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#d59563'}
      ]
    },
    {
      'featureType': 'water',
      'elementType': 'geometry',
      'stylers': [
        {'color': '#17263c'}
      ]
    },
    {
      'featureType': 'water',
      'elementType': 'labels.text.fill',
      'stylers': [
        {'color': '#515c6d'}
      ]
    },
    {
      'featureType': 'water',
      'elementType': 'labels.text.stroke',
      'stylers': [
        {'color': '#17263c'}
      ]
    }
  ]);
}
